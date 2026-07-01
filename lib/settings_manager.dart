// ============================================================
//  مغز مرکزی تنظیمات (settings_manager.dart)
// ============================================================

import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'dart:html' as html; // برای رفع مشکل فونت در فایرفاکس
import 'api_client.dart';

class SettingsManager extends ChangeNotifier {
  static final SettingsManager instance = SettingsManager._internal();
  SettingsManager._internal();

  SharedPreferences? _prefs;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  String _season = 'winter';
  String get season => _season;

  String _appTitle = 'ثبت پیشرفت اکشن پلن جم';
  String _appSlogan = 'پتروشیمی جم - راهکاری متفاوت';
  String _browserTitle = 'ثبت پیشرفت اکشن پلن';
  String _systemName = 'سامانه ثبت پیشرفت اکشن پلن جم';

  String get appTitle => _appTitle;
  String get appSlogan => _appSlogan;
  String get browserTitle => _browserTitle;
  String get systemName => _systemName;

  String _headerLogo = ''; 
  String _browserFavicon = '';

  String get headerLogo => _headerLogo;
  String get browserFavicon => _browserFavicon;
  bool get hasHeaderLogo => _headerLogo.isNotEmpty;
  bool get hasFavicon => _browserFavicon.isNotEmpty;

  // ----- مدیریت فونت سفارشی سازمانی -----
  String _customFontBase64 = '';
  String _customFontName = ''; // ذخیره نام فایل فونت
  
  String get currentFontFamily => _customFontBase64.isNotEmpty ? 'CustomAdminFont' : 'Vazirmatn';
  String get customFontName => _customFontName; // دسترسی به نام فونت

  // متد داخلی بارگذاری فونت با پشتیبانی کامل از کروم و فایرفاکس
  Future<void> _loadFontFromBase64(String base64Data) async {
    try {
      final bytes = base64Decode(base64Data);

      // ۱. لود در موتور فلاتر
      final fontLoader = FontLoader('CustomAdminFont');
      fontLoader.addFont(Future.value(ByteData.view(bytes.buffer, bytes.offsetInBytes, bytes.lengthInBytes)));
      await fontLoader.load();

      // ۲. تزریق به مرورگر برای فایرفاکس
      _injectFontToBrowserCSS('CustomAdminFont', base64Data);

    } catch (e) {
      debugPrint('خطا در لود فونت اختصاصی: $e');
    }
  }

  void _injectFontToBrowserCSS(String fontName, String base64Data) {
    try {
      final oldStyle = html.document.getElementById('custom-font-style');
      if (oldStyle != null) oldStyle.remove();

      final style = html.StyleElement();
      style.id = 'custom-font-style';
      style.innerHtml = '''
        @font-face {
          font-family: '$fontName';
          src: url(data:font/ttf;base64,$base64Data) format('truetype');
          font-weight: normal;
          font-style: normal;
        }
      ''';
      html.document.head?.append(style);
    } catch (e) {
      debugPrint('خطا در تزریق فونت به HTML: $e');
    }
  }

  // ذخیره فونت همراه با نام آن
  Future<void> saveCustomFont(
    String base64Data,
    String fontName, // نام فونت اضافه شد
    Future<void> Function(String key, String value) setSetting,
  ) async {
    _customFontBase64 = base64Data;
    _customFontName = fontName;

    // ذخیره در دیتابیس
    await setSetting('custom_font', base64Data);
    await setSetting('custom_font_name', fontName);
    
    // ذخیره در کش مرورگر
    await _prefs?.setString('cached_custom_font', base64Data);
    await _prefs?.setString('cached_custom_font_name', fontName);
    
    if (base64Data.isNotEmpty) {
      await _loadFontFromBase64(base64Data);
    }
    notifyListeners();
  }

  bool _ssoEnabled = false;
  bool get ssoEnabled => _ssoEnabled;
  bool _adEnabled = false;
  bool get adEnabled => _adEnabled;

  void setSsoEnabled(bool v) {
    _ssoEnabled = v;
    notifyListeners();
  }

  void setAdEnabled(bool v) {
    _adEnabled = v;
    notifyListeners();
  }

  Future<void> loadPublicBranding() async {
    final res = await ApiClient.instance
        .get('/api/Settings/public-branding', withAuth: false)
        .timeout(const Duration(seconds: 3));
    if (res is Map) {
      final t = res['app_title'];
      final s = res['app_slogan'];
      final b = res['browser_title'];
      final n = res['system_name'];
      final logo = res['header_logo'];
      final fav = res['browser_favicon'];
      final cFont = res['custom_font']; 
      final cFontName = res['custom_font_name']; // گرفتن نام فونت از سرور

      if (t != null && t.toString().isNotEmpty) _appTitle = t.toString();
      if (s != null && s.toString().isNotEmpty) _appSlogan = s.toString();
      if (b != null && b.toString().isNotEmpty) _browserTitle = b.toString();
      if (n != null && n.toString().isNotEmpty) _systemName = n.toString();
      if (logo != null) _headerLogo = logo.toString();
      if (fav != null) _browserFavicon = fav.toString();
      _ssoEnabled = (res['sso_enabled']?.toString() ?? 'false') == 'true';
      _adEnabled = (res['ad_enabled']?.toString() ?? 'false') == 'true';

      if (cFontName != null) {
        _customFontName = cFontName.toString();
        await _prefs?.setString('cached_custom_font_name', _customFontName);
      }

      if (cFont != null && cFont.toString() != _customFontBase64) {
        _customFontBase64 = cFont.toString();
        await _prefs?.setString('cached_custom_font', _customFontBase64);
        if (_customFontBase64.isNotEmpty) {
          await _loadFontFromBase64(_customFontBase64);
        }
      }

      notifyListeners();
    }
  }

  Future<void> loadHeaderTexts(
      Future<String?> Function(String key) getSetting) async {
    final t = await getSetting('app_title');
    final s = await getSetting('app_slogan');
    final b = await getSetting('browser_title');
    final n = await getSetting('system_name');
    final logo = await getSetting('header_logo');
    final fav = await getSetting('browser_favicon');
    
    if (t != null && t.isNotEmpty) _appTitle = t;
    if (s != null && s.isNotEmpty) _appSlogan = s;
    if (b != null && b.isNotEmpty) _browserTitle = b;
    if (n != null && n.isNotEmpty) _systemName = n;
    if (logo != null) _headerLogo = logo;
    if (fav != null) _browserFavicon = fav;

    final customFontName = await getSetting('custom_font_name');
    if (customFontName != null) {
      _customFontName = customFontName;
      await _prefs?.setString('cached_custom_font_name', customFontName);
    }

    final customFont = await getSetting('custom_font');
    if (customFont != null && customFont != _customFontBase64) {
      _customFontBase64 = customFont;
      await _prefs?.setString('cached_custom_font', customFont);
      if (customFont.isNotEmpty) {
        await _loadFontFromBase64(customFont);
      }
    }

    notifyListeners();
  }

  Future<void> saveHeaderLogo(
    String dataUrl,
    Future<void> Function(String key, String value) setSetting,
  ) async {
    _headerLogo = dataUrl;
    await setSetting('header_logo', dataUrl);
    notifyListeners();
  }

  Future<void> saveFavicon(
    String dataUrl,
    Future<void> Function(String key, String value) setSetting,
  ) async {
    _browserFavicon = dataUrl;
    await setSetting('browser_favicon', dataUrl);
    notifyListeners();
  }

  Future<void> saveHeaderTexts({
    required String title,
    required String slogan,
    required String browserTitle,
    required String systemName,
    required Future<void> Function(String key, String value) setSetting,
  }) async {
    _appTitle = title;
    _appSlogan = slogan;
    _browserTitle = browserTitle;
    _systemName = systemName;
    await setSetting('app_title', title);
    await setSetting('app_slogan', slogan);
    await setSetting('browser_title', browserTitle);
    await setSetting('system_name', systemName);
    notifyListeners();
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs?.getBool('isDarkMode') ?? false;
    _season = _prefs?.getString('season') ?? 'winter';

    // خواندن نام و خود فونت از کش در لحظه لود
    _customFontName = _prefs?.getString('cached_custom_font_name') ?? '';
    final cachedFont = _prefs?.getString('cached_custom_font') ?? '';
    if (cachedFont.isNotEmpty) {
      _customFontBase64 = cachedFont;
      await _loadFontFromBase64(cachedFont);
    }

    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _prefs?.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setSeason(String newSeason) async {
    _season = newSeason;
    await _prefs?.setString('season', _season);
    notifyListeners();
  }

  String exportSettings() {
    final Map<String, dynamic> data = {
      'isDarkMode': _isDarkMode,
      'season': _season,
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  Future<bool> importSettings(String jsonText) async {
    try {
      final Map<String, dynamic> data = jsonDecode(jsonText) as Map<String, dynamic>;
      if (data.containsKey('isDarkMode')) {
        _isDarkMode = data['isDarkMode'] as bool;
        await _prefs?.setBool('isDarkMode', _isDarkMode);
      }
      if (data.containsKey('season')) {
        _season = data['season'] as String;
        await _prefs?.setString('season', _season);
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}