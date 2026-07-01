import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class ApiConfig {
  ApiConfig._();
  static final ApiConfig instance = ApiConfig._();

  SharedPreferences? _prefs;

  // حالت backend: 'local' (Drift) یا 'api' (سرور)
  String _backendMode = 'local';
  String _baseUrl = 'http://localhost:5080';
  String? _token;

  // آیا اپ از روی سرور واقعی سرو شده؟ 
  bool get _isServedFromServer {
    final port = html.window.location.port;
    // پورت‌های رایج محیط توسعه‌ی فلاتر
    const devPorts = ['8080', '8083', '8084', '8085', '8086', '8087', '8090', '8091'];
    return !devPorts.contains(port);
  }

  String get backendMode => _backendMode;
  bool get isApiMode => _backendMode == 'api';
  
  /// آدرس نهایی که باید استفاده شود
  String get baseUrl {
    if (_isServedFromServer) {
      // روی سرور واقعی هستیم → از آدرس سرور شرکت استفاده کن
      return 'http://172.31.15.196:9000';
    }
    return _baseUrl; // حالت توسعه (localhost)
  }

  String? get token => _token;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _backendMode = _prefs?.getString('backend_mode') ?? 'local';
    _baseUrl = _prefs?.getString('api_base_url') ?? 'http://localhost:5080';
    _token = _prefs?.getString('api_token');

    // اگر از سرور واقعی سرو شده‌ایم، حالت را به API تغییر بده
    if (_isServedFromServer) {
      _backendMode = 'api';
      // baseUrl رو اینجا تغییر نمی‌دیم چون getter بالا خودش مدیریت می‌کنه
    }
  }

  Future<void> setBackendMode(String mode) async {
    _backendMode = mode;
    await _prefs?.setString('backend_mode', mode);
  }

  Future<void> setBaseUrl(String url) async {
    // حذف اسلش انتهایی
    _baseUrl = url.endsWith('/') ? url.substring(0, url.length - 1) : url;
    await _prefs?.setString('api_base_url', _baseUrl);
  }

  Future<void> setToken(String? token) async {
    _token = token;
    if (token == null) {
      await _prefs?.remove('api_token');
    } else {
      await _prefs?.setString('api_token', token);
    }
  }
}