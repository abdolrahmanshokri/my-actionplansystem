import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_repository.dart';
import 'drift_repository.dart';
import 'api_repository.dart';
import 'api_config.dart';
import 'api_client.dart';
import 'settings_manager.dart';

class AuthManager extends ChangeNotifier {
  static final AuthManager instance = AuthManager._internal();
  AuthManager._internal();

  final DriftRepository _driftRepo = DriftRepository();
  final ApiRepository _apiRepo = ApiRepository();

  DataRepository get repository =>
      ApiConfig.instance.isApiMode ? _apiRepo : _driftRepo;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  bool _developerMode = false;
  bool get developerMode => _developerMode;

  bool _showInactiveAdmin2 = true;
  bool _showInactiveUser = false;
  bool _showNoTargetAdmin2 = true;
  bool _showNoTargetUser = false;

  bool get showInactiveAdmin2 => _showInactiveAdmin2;
  bool get showInactiveUser => _showInactiveUser;
  bool get showNoTargetAdmin2 => _showNoTargetAdmin2;
  bool get showNoTargetUser => _showNoTargetUser;

  bool get canSeeInactiveToggle {
    final u = _currentUser;
    if (u == null) return false;
    if (u.isSuperAdmin || (u.isAdmin && !u.isAdmin2)) return true;
    if (u.isAdmin2) return _showInactiveAdmin2;
    return _showInactiveUser;
  }

  bool get canSeeNoTargetToggle {
    final u = _currentUser;
    if (u == null) return false;
    if (u.isSuperAdmin || (u.isAdmin && !u.isAdmin2)) return true;
    if (u.isAdmin2) return _showNoTargetAdmin2;
    return _showNoTargetUser;
  }

  Future<void> setVisibilitySetting(String key, bool value) async {
    switch (key) {
      case 'show_inactive_admin2':
        _showInactiveAdmin2 = value;
        break;
      case 'show_inactive_user':
        _showInactiveUser = value;
        break;
      case 'show_notarget_admin2':
        _showNoTargetAdmin2 = value;
        break;
      case 'show_notarget_user':
        _showNoTargetUser = value;
        break;
    }
    await repository.setSetting(key, value ? 'true' : 'false');
    notifyListeners();
  }

  Future<void> _loadVisibilitySettings([DataRepository? repo]) async {
    final r = repo ?? repository;
    _showInactiveAdmin2 =
        (await r.getSetting('show_inactive_admin2')) != 'false';
    _showInactiveUser =
        (await r.getSetting('show_inactive_user')) == 'true';
    _showNoTargetAdmin2 =
        (await r.getSetting('show_notarget_admin2')) != 'false';
    _showNoTargetUser =
        (await r.getSetting('show_notarget_user')) == 'true';
  }

  Future<void> reloadDeveloperMode() async {
    final v = await repository.getSetting('developer_mode');
    _developerMode = v == 'true';
    notifyListeners();
  }

  Future<void> setDeveloperMode(bool value) async {
    _developerMode = value;
    await repository.setSetting('developer_mode', value ? 'true' : 'false');
    notifyListeners();
  }

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await ApiConfig.instance.init();
    // Drift همیشه راه‌اندازی می‌شود (برای حالت محلی)
    await _driftRepo.initialize();
    await _driftRepo.createOrMigrate();

    // تنظیمات اولیه‌ی ظاهری همیشه از Drift خوانده می‌شود
    // (در حالت API هنوز توکن نداریم؛ بعد از لاگین از سرور به‌روز می‌شود)
    final devMode = await _driftRepo.getSetting('developer_mode');
    _developerMode = devMode == 'true';
    await _loadVisibilitySettings(_driftRepo);
    // متن‌های هدر از Drift
    await SettingsManager.instance.loadHeaderTexts(_driftRepo.getSetting);

    // متن‌های ظاهری را از endpoint عمومی سرور می‌گیریم.
    // این مستقل از حالت (API/محلی) امتحان می‌شود تا اگر سرور در دسترس بود،
    // حتی پیش از لاگین (و حتی اگر با تغییر پورت حالت ریست شده) متن/لوگو درست بیاید.
    // اگر سرور در دسترس نبود (حالت محلی خالص)، بی‌صدا رد می‌شود.
    try {
      await SettingsManager.instance.loadPublicBranding();
    } catch (e) {
      // ignore: avoid_print
      print('loadPublicBranding خطا: $e');
    }

    // auto-login فقط در حالت محلی (در حالت API نیاز به توکن تازه است)
    if (!ApiConfig.instance.isApiMode) {
      final savedUsername = _prefs?.getString('logged_in_username');
      if (savedUsername != null && savedUsername.isNotEmpty) {
        final user = await repository.getUserByUsername(savedUsername);
        if (user != null) {
          _currentUser = user;
        }
      }
    }
    notifyListeners();
  }

  Future<bool> loginAsUsername(String username) async {
    // در حالت API، ورود سریع = لاگین واقعی با رمز پیش‌فرض 1234
    // (چون بدون توکن نمی‌توان به سرور دسترسی داشت)
    if (ApiConfig.instance.isApiMode) {
      return _loginViaApi(username, '1234');
    }
    final user = await repository.getUserByUsername(username);
    if (user == null) return false;
    _currentUser = user;
    await repository.recordLogin(user.id);
    await _prefs?.setString('logged_in_username', username);
    notifyListeners();
    return true;
  }

  Future<bool> loginLocal(String username, String password) async {
    // حالت API: از سرور توکن بگیر
    if (ApiConfig.instance.isApiMode) {
      return _loginViaApi(username, password);
    }
    final user = await repository.authenticateLocal(username, password);
    if (user == null) return false;
    _currentUser = user;
    await repository.recordLogin(user.id);
    await _prefs?.setString('logged_in_username', username);
    notifyListeners();
    return true;
  }

  Future<bool> _loginViaApi(String username, String password) async {
    try {
      final res = await ApiClient.instance.post(
        '/api/Auth/login',
        body: {'username': username, 'password': password},
        withAuth: false,
      );
      if (res == null) return false;
      await ApiConfig.instance.setToken(res['token'] as String?);
      final roles = (res['roles'] as List?)?.cast<String>() ?? [];
      _currentUser = AppUser(
        id: res['userId'] as int,
        username: res['username'] as String,
        fullName: res['fullName'] as String,
        roleCodes: roles,
      );
      await _prefs?.setString('logged_in_username', username);
      // حالا که توکن داریم، تنظیمات را از سرور به‌روز کن
      try {
        final devMode = await _apiRepo.getSetting('developer_mode');
        _developerMode = devMode == 'true';
        await _loadVisibilitySettings(_apiRepo);
        await SettingsManager.instance.loadHeaderTexts(_apiRepo.getSetting);
      } catch (_) {}
      notifyListeners();
      return true;
    } on ApiException {
      return false;
    } catch (_) {
      return false;
    }
  }

  // ورود با اکتیو دایرکتوری از طریق سرور
  Future<bool> loginViaAd(String username, String password) async {
    try {
      final res = await ApiClient.instance.post(
        '/api/Auth/ad-login',
        body: {'username': username, 'password': password},
        withAuth: false,
      );
      if (res == null) return false;
      await ApiConfig.instance.setToken(res['token'] as String?);
      final roles = (res['roles'] as List?)?.cast<String>() ?? [];
      _currentUser = AppUser(
        id: res['userId'] as int,
        username: res['username'] as String,
        fullName: res['fullName'] as String,
        roleCodes: roles,
      );
      await _prefs?.setString('logged_in_username', res['username'] as String);
      try {
        final devMode = await _apiRepo.getSetting('developer_mode');
        _developerMode = devMode == 'true';
        await _loadVisibilitySettings(_apiRepo);
        await SettingsManager.instance.loadHeaderTexts(_apiRepo.getSetting);
      } catch (_) {}
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  // تبدیل بلیت یکبارمصرف SSO به توکن و ورود
  Future<bool> exchangeSsoTicket(String ticket) async {
    try {
      final res = await ApiClient.instance.post(
        '/api/Auth/sso-exchange',
        body: {'ticket': ticket},
        withAuth: false,
      );
      if (res == null) return false;
      await ApiConfig.instance.setToken(res['token'] as String?);
      final roles = (res['roles'] as List?)?.cast<String>() ?? [];
      _currentUser = AppUser(
        id: res['userId'] as int,
        username: res['username'] as String,
        fullName: res['fullName'] as String,
        roleCodes: roles,
      );
      await _prefs?.setString('logged_in_username', res['username'] as String);
      try {
        final devMode = await _apiRepo.getSetting('developer_mode');
        _developerMode = devMode == 'true';
        await _loadVisibilitySettings(_apiRepo);
        await SettingsManager.instance.loadHeaderTexts(_apiRepo.getSetting);
      } catch (_) {}
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await ApiConfig.instance.setToken(null);
    await _prefs?.remove('logged_in_username');
    notifyListeners();
  }
}