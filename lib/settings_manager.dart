// ============================================================
//  مغز مرکزی تنظیمات (settings_manager.dart)
// ============================================================
//  این فایل، «مغز» همه‌ی تنظیمات کاربر است.
//  هر تنظیمی که کاربر عوض می‌کند (تم شب/روز، فصل، لیست/کاشی و ...)
//  اینجا نگه داشته می‌شود، خودکار ذخیره می‌شود، و می‌توان آن را
//  به صورت یک فایل متنی خروجی گرفت (export) یا وارد کرد (import).
//
//  چرا یک فایل جداگانه؟ چون می‌خواهیم همه‌ی تنظیمات «یک جا» باشند.
//  هر بخش از برنامه به این مغز وصل می‌شود، نه اینکه هر کدام جدا
//  تنظیماتش را نگه دارد. این کار را تمیز و قابل‌گسترش می‌کند.
// ============================================================

import 'dart:convert'; // برای تبدیل تنظیمات به متن (JSON) و برعکس
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ابزار ذخیره‌سازی
import 'api_client.dart';

// ============================================================
//  کلاس SettingsManager
//  «ChangeNotifier» یعنی این کلاس می‌تواند به بقیه‌ی برنامه
//  «خبر بدهد» که چیزی عوض شد، تا صفحه خودش را به‌روز کند.
// ============================================================
class SettingsManager extends ChangeNotifier {
  // ----- الگوی تک‌نمونه (Singleton) -----
  // یعنی در کل برنامه فقط «یک» مغز تنظیمات داریم، نه چندتا.
  // هر جای برنامه که SettingsManager.instance را صدا بزنیم،
  // همان یک مغز مشترک را می‌گیریم.
  static final SettingsManager instance = SettingsManager._internal();
  SettingsManager._internal();

  // متغیری برای دسترسی به انبار ذخیره‌سازی دستگاه.
  SharedPreferences? _prefs;

  // ============================================================
  //  مقادیر تنظیمات
  //  فعلاً فقط یک تنظیم داریم: حالت تاریک (شب) یا روشن (روز).
  //  بعداً فصل، لیست/کاشی و بقیه را همین‌جا اضافه می‌کنیم.
  // ============================================================

  // آیا حالت شب (تاریک) فعال است؟ پیش‌فرض: خیر (یعنی حالت روز).
  bool _isDarkMode = false;

  // این یک «گتر» است؛ یعنی راهی برای خواندن مقدار از بیرون.
  bool get isDarkMode => _isDarkMode;

  // ----- فصل انتخاب‌شده -----
  // مقدار آن یکی از این چهارتاست: 'spring' (بهار)، 'summer' (تابستان)،
  // 'autumn' (پاییز)، 'winter' (زمستان).
  // پیش‌فرض: زمستان (همان سرمه‌ای فعلی برنامه).
  String _season = 'winter';

  // گتر برای خواندن فصل از بیرون.
  String get season => _season;

  // ----- متن‌های قابل‌ویرایش هدر (تنظیمات سازمانی، در دیتابیس) -----
  String _appTitle = 'ثبت پیشرفت اکشن پلن جم';
  String _appSlogan = 'پتروشیمی جم - راهکاری متفاوت';
  String _browserTitle = 'ثبت پیشرفت اکشن پلن';
  String _systemName = 'سامانه ثبت پیشرفت اکشن پلن جم';

  String get appTitle => _appTitle;
  String get appSlogan => _appSlogan;
  String get browserTitle => _browserTitle;
  String get systemName => _systemName;

  // ----- تصاویر قابل‌ویرایش (base64، در دیتابیس) -----
  // لوگوی هدر و آیکون تب مرورگر (favicon). اگر خالی باشند، پیش‌فرض استفاده می‌شود.
  String _headerLogo = ''; // data URL یا base64 خام
  String _browserFavicon = '';

  String get headerLogo => _headerLogo;
  String get browserFavicon => _browserFavicon;
  bool get hasHeaderLogo => _headerLogo.isNotEmpty;
  bool get hasFavicon => _browserFavicon.isNotEmpty;

  // آیا ورود از طریق SSO فعال است؟ (برای نمایش دکمه در صفحه‌ی لاگین)
  bool _ssoEnabled = false;
  bool get ssoEnabled => _ssoEnabled;
  bool _adEnabled = false;
  bool get adEnabled => _adEnabled;

  // به‌روزرسانی محلی وضعیت روش‌های ورود (پس از ذخیره توسط ادمین)
  void setSsoEnabled(bool v) {
    _ssoEnabled = v;
    notifyListeners();
  }

  void setAdEnabled(bool v) {
    _adEnabled = v;
    notifyListeners();
  }

  // بارگذاری متن‌های ظاهری از endpoint عمومی سرور (بدون توکن)
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
      if (t != null && t.toString().isNotEmpty) _appTitle = t.toString();
      if (s != null && s.toString().isNotEmpty) _appSlogan = s.toString();
      if (b != null && b.toString().isNotEmpty) _browserTitle = b.toString();
      if (n != null && n.toString().isNotEmpty) _systemName = n.toString();
      if (logo != null) _headerLogo = logo.toString();
      if (fav != null) _browserFavicon = fav.toString();
      _ssoEnabled = (res['sso_enabled']?.toString() ?? 'false') == 'true';
      _adEnabled = (res['ad_enabled']?.toString() ?? 'false') == 'true';
      notifyListeners();
    }
  }

  // بارگذاری متن‌های هدر از دیتابیس (از طریق repository)
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
    notifyListeners();
  }

  // ذخیره‌ی لوگوی هدر (base64/dataURL). برای حذف، رشته‌ی خالی بده.
  Future<void> saveHeaderLogo(
    String dataUrl,
    Future<void> Function(String key, String value) setSetting,
  ) async {
    _headerLogo = dataUrl;
    await setSetting('header_logo', dataUrl);
    notifyListeners();
  }

  // ذخیره‌ی آیکون تب مرورگر (favicon).
  Future<void> saveFavicon(
    String dataUrl,
    Future<void> Function(String key, String value) setSetting,
  ) async {
    _browserFavicon = dataUrl;
    await setSetting('browser_favicon', dataUrl);
    notifyListeners();
  }

  // ذخیره و به‌روزرسانی متن‌های هدر
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

  // ============================================================
  //  راه‌اندازی اولیه
  //  این تابع را یک‌بار در شروع برنامه صدا می‌زنیم تا تنظیمات
  //  ذخیره‌شده‌ی قبلی کاربر را از انبار بخواند.
  // ============================================================
  Future<void> init() async {
    // انبار ذخیره‌سازی را باز می‌کنیم.
    _prefs = await SharedPreferences.getInstance();

    // مقدار ذخیره‌شده‌ی «حالت شب» را می‌خوانیم.
    // اگر قبلاً چیزی ذخیره نشده باشد (null)، پیش‌فرض false می‌گذاریم.
    _isDarkMode = _prefs?.getBool('isDarkMode') ?? false;

    // فصل ذخیره‌شده را می‌خوانیم. اگر چیزی نبود، پیش‌فرض 'winter'.
    _season = _prefs?.getString('season') ?? 'winter';

    // به برنامه خبر می‌دهیم که تنظیمات آماده شد.
    notifyListeners();
  }

  // ============================================================
  //  عوض کردن حالت شب/روز
  //  وقتی کاربر دکمه را می‌زند، این تابع صدا زده می‌شود.
  // ============================================================
  Future<void> toggleDarkMode() async {
    // مقدار را برعکس می‌کنیم (اگر شب بود، روز شود و برعکس).
    _isDarkMode = !_isDarkMode;

    // مقدار جدید را در انبار ذخیره می‌کنیم تا دفعه‌ی بعد بماند.
    await _prefs?.setBool('isDarkMode', _isDarkMode);

    // به همه‌ی صفحه‌ها خبر می‌دهیم که تم عوض شد، تا خودشان را به‌روز کنند.
    notifyListeners();
  }

  // ============================================================
  //  عوض کردن فصل
  //  یک نام فصل می‌گیرد ('spring'، 'summer'، 'autumn'، 'winter')
  //  و آن را ذخیره می‌کند.
  // ============================================================
  Future<void> setSeason(String newSeason) async {
    _season = newSeason;
    // فصل جدید را ذخیره می‌کنیم تا دفعه‌ی بعد بماند.
    await _prefs?.setString('season', _season);
    // به برنامه خبر می‌دهیم فصل عوض شد.
    notifyListeners();
  }

  // ============================================================
  //  خروجی گرفتن از تنظیمات (Export)
  //  همه‌ی تنظیمات را به یک متن (JSON) تبدیل می‌کند تا کاربر
  //  بتواند آن را ذخیره/کپی کند و برای دیگری بفرستد.
  // ============================================================
  String exportSettings() {
    // یک «دفترچه» (Map) از همه‌ی تنظیمات می‌سازیم.
    final Map<String, dynamic> data = {
      'isDarkMode': _isDarkMode,
      'season': _season,
      // بعداً تنظیمات دیگر هم اینجا اضافه می‌شوند، مثلاً:
      // 'viewMode': _viewMode,
    };

    // دفترچه را به یک متن مرتب JSON تبدیل می‌کنیم و برمی‌گردانیم.
    // jsonEncode یعنی «این داده را به متن تبدیل کن».
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  // ============================================================
  //  وارد کردن تنظیمات (Import)
  //  یک متن JSON می‌گیرد، آن را می‌خواند و تنظیمات را اعمال می‌کند.
  //  اگر متن درست بود true برمی‌گرداند، اگر خراب بود false.
  // ============================================================
  Future<bool> importSettings(String jsonText) async {
    try {
      // متن را به دفترچه تبدیل می‌کنیم.
      // jsonDecode یعنی «این متن را به داده تبدیل کن».
      final Map<String, dynamic> data =
          jsonDecode(jsonText) as Map<String, dynamic>;

      // اگر کلید «isDarkMode» در متن بود، مقدارش را می‌گذاریم.
      if (data.containsKey('isDarkMode')) {
        _isDarkMode = data['isDarkMode'] as bool;
        await _prefs?.setBool('isDarkMode', _isDarkMode);
      }

      // اگر کلید «season» در متن بود، مقدارش را می‌گذاریم.
      if (data.containsKey('season')) {
        _season = data['season'] as String;
        await _prefs?.setString('season', _season);
      }

      // به برنامه خبر می‌دهیم تنظیمات عوض شد.
      notifyListeners();
      return true; // موفق بود
    } catch (e) {
      // اگر متن خراب بود یا فرمتش غلط بود، اینجا می‌آییم.
      return false; // ناموفق بود
    }
  }
}