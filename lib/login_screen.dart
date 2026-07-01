import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'auth_manager.dart';
import 'settings_manager.dart';
import 'season_themes.dart';
import 'api_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _loginType = 'local';
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _busy = false;
  String? _error;

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;
  Color get _accent => seasonColorsOf(SettingsManager.instance.season).accent;

  Future<void> _quickLogin(String username) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await AuthManager.instance.loginAsUsername(username);
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) {
      setState(() => _error = ApiConfig.instance.isApiMode
          ? 'ورود سریع ناموفق بود (رمز این کاربر باید 1234 باشد)'
          : 'کاربر $username یافت نشد');
    }
  }

  void _ssoLogin() {
    final loc = html.window.location;
    final returnUrl = '${loc.protocol}//${loc.host}${loc.pathname}';
    final base = ApiConfig.instance.baseUrl;
    final url =
        '$base/api/Auth/sso-login?returnUrl=${Uri.encodeComponent(returnUrl)}';
    html.window.location.href = url;
  }

  Future<void> _doLogin() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    bool ok = false;
    if (_loginType == 'local') {
      ok = await AuthManager.instance
          .loginLocal(_userController.text.trim(), _passController.text);
    } else if (_loginType == 'ad') {
      ok = await AuthManager.instance
          .loginViaAd(_userController.text.trim(), _passController.text);
    } else {
      // sso از این مسیر نمی‌آید (دکمه‌ی جدا دارد)
      setState(() => _busy = false);
      return;
    }

    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) {
      setState(() => _error = 'نام کاربری یا رمز عبور اشتباه است');
    }
  }

  Widget _loginLogoImage(String dataUrl) {
    try {
      final base64Part =
          dataUrl.contains(',') ? dataUrl.split(',').last : dataUrl;
      final bytes = base64Decode(base64Part);
      return Image.memory(bytes, fit: BoxFit.contain);
    } catch (_) {
      return const Icon(Icons.dashboard_rounded,
          color: Colors.white, size: 32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: SettingsManager.instance,
      builder: (context, _) {
        return Scaffold(
      backgroundColor: _primary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SettingsManager.instance.hasHeaderLogo
                      ? _loginLogoImage(SettingsManager.instance.headerLogo)
                      : const Icon(Icons.dashboard_rounded,
                          color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                Text(
                  SettingsManager.instance.systemName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: _primary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'برای ورود، یکی از روش‌های زیر را انتخاب کنید',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF777777)),
                ),
                const SizedBox(height: 24),

                Builder(builder: (context) {
                  final apiMode = ApiConfig.instance.isApiMode;
                  final adOn = apiMode && SettingsManager.instance.adEnabled;
                  final ssoOn = apiMode && SettingsManager.instance.ssoEnabled;
                  final segments = <ButtonSegment<String>>[
                    const ButtonSegment(value: 'local', label: Text('لوکال')),
                    if (adOn)
                      const ButtonSegment(value: 'ad', label: Text('اکتیو')),
                    if (ssoOn)
                      const ButtonSegment(value: 'sso', label: Text('SSO')),
                  ];
                  // اگر نوع انتخابی دیگر معتبر نیست، به لوکال برگرد
                  if ((_loginType == 'ad' && !adOn) ||
                      (_loginType == 'sso' && !ssoOn)) {
                    _loginType = 'local';
                  }
                  // اگر فقط یک روش هست، نیازی به دکمه‌های انتخاب نیست
                  if (segments.length == 1) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SegmentedButton<String>(
                      segments: segments,
                      selected: {_loginType},
                      onSelectionChanged: (s) {
                        setState(() {
                          _loginType = s.first;
                          _error = null;
                        });
                      },
                    ),
                  );
                }),

                if (_loginType != 'sso') ...[
                  TextField(
                    controller: _userController,
                    decoration: const InputDecoration(
                      labelText: 'نام کاربری',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'رمز عبور',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                ],

                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDECEA),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(
                          color: Color(0xFFC0392B), fontSize: 13),
                    ),
                  ),
                ],

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _busy
                        ? null
                        : (_loginType == 'sso' ? _ssoLogin : _doLogin),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _busy
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(_loginType == 'sso'
                            ? 'ورود از طریق SSO'
                            : 'ورود'),
                  ),
                ),


                if (AuthManager.instance.developerMode) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.bug_report, size: 16, color: _accent),
                      const SizedBox(width: 6),
                      const Text(
                        'ورود سریع (موقت - فقط برای توسعه)',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _quickButton('ab.shokri', 'عبدالرحمن شکری (سوپر ادمین)'),
                  const SizedBox(height: 8),
                  _quickButton('y.nikakhtar', 'مهندس نیک‌اختر'),
                  const SizedBox(height: 8),
                  _quickButton('m.amirsadat', 'محسن امیرسادات'),
                  const SizedBox(height: 8),
                  _quickButton('e.aradmehr', 'اسحاق آرادمهر'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _quickButton(String username, String label) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _busy ? null : () => _quickLogin(username),
        style: OutlinedButton.styleFrom(
          foregroundColor: _primary,
          side: BorderSide(color: _primary.withOpacity(0.3)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.centerRight,
        ),
        child: Row(
          children: [
            Icon(Icons.login, size: 18, color: _accent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Text(
              username,
              style: const TextStyle(
                  fontSize: 11, color: Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }
}