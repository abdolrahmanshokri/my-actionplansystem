import 'package:flutter/material.dart';
import 'auth_manager.dart';
import 'settings_manager.dart';
import 'season_themes.dart';
import 'api_config.dart';
import 'api_client.dart';

class ConnectionSettingsContent extends StatefulWidget {
  const ConnectionSettingsContent({super.key});

  @override
  State<ConnectionSettingsContent> createState() =>
      _ConnectionSettingsContentState();
}

class _ConnectionSettingsContentState extends State<ConnectionSettingsContent> {
  bool _loading = true;
  bool _saving = false;
  String? _status;

  String _dbType = 'drift';

  String _backendMode = 'local';
  final _apiUrl = TextEditingController();
  String? _testResult;
  bool _testing = false;

  final _sqlServer = TextEditingController();
  final _sqlDatabase = TextEditingController();
  final _sqlUser = TextEditingController();
  final _sqlPassword = TextEditingController();
  final _adDomain = TextEditingController();
  final _adOu = TextEditingController();
  final _ssoUrl = TextEditingController();

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = AuthManager.instance.repository;
    _backendMode = ApiConfig.instance.backendMode;
    _apiUrl.text = ApiConfig.instance.baseUrl;
    _dbType = await repo.getSetting('db_type') ?? 'drift';
    _sqlServer.text = await repo.getSetting('sql_server_host') ?? '';
    _sqlDatabase.text = await repo.getSetting('sql_server_database') ?? '';
    _sqlUser.text = await repo.getSetting('sql_server_user') ?? '';
    _sqlPassword.text = await repo.getSetting('sql_server_password') ?? '';
    _adDomain.text = await repo.getSetting('ad_domain') ?? '';
    _adOu.text = await repo.getSetting('ad_ou') ?? '';
    _ssoUrl.text = await repo.getSetting('sso_url') ?? '';
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _status = null;
    });
    final repo = AuthManager.instance.repository;
    try {
      await repo.setSetting('db_type', _dbType);
      await repo.setSetting('sql_server_host', _sqlServer.text.trim());
      await repo.setSetting('sql_server_database', _sqlDatabase.text.trim());
      await repo.setSetting('sql_server_user', _sqlUser.text.trim());
      await repo.setSetting('sql_server_password', _sqlPassword.text);
      await repo.setSetting('ad_domain', _adDomain.text.trim());
      await repo.setSetting('ad_ou', _adOu.text.trim());
      await repo.setSetting('sso_url', _ssoUrl.text.trim());
      setState(() => _status = 'تنظیمات ذخیره شد ✓');
    } catch (e) {
      setState(() => _status = 'خطا در ذخیره: $e');
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2238);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تنظیمات اتصال',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: textColor)),
          const SizedBox(height: 4),
          Text('نوع دیتابیس و تنظیمات احراز هویت سازمانی',
              style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : const Color(0xFF777777))),
          const SizedBox(height: 24),

          _buildBackendCard(isDark, textColor),
          const SizedBox(height: 20),

          _sectionCard(
            isDark: isDark,
            textColor: textColor,
            title: 'نوع دیتابیس',
            icon: Icons.storage,
            children: [
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text('Drift (لوکال - همراه برنامه)'),
                subtitle: const Text('برای توسعه و حالت آفلاین'),
                value: 'drift',
                groupValue: _dbType,
                onChanged: (v) => setState(() => _dbType = v!),
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                title: const Text('SQL Server (سرور شرکت)'),
                subtitle: const Text('برای محیط واقعی (از طریق API)'),
                value: 'sqlserver',
                groupValue: _dbType,
                onChanged: (v) => setState(() => _dbType = v!),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (_dbType == 'sqlserver')
            _sectionCard(
              isDark: isDark,
              textColor: textColor,
              title: 'کانکشن SQL Server',
              icon: Icons.dns,
              children: [
                _field(_sqlServer, 'آدرس سرور (مثلاً 172.16.7.54)'),
                _field(_sqlDatabase, 'نام دیتابیس'),
                _field(_sqlUser, 'نام کاربری دیتابیس'),
                _field(_sqlPassword, 'رمز عبور', obscure: true),
              ],
            ),
          if (_dbType == 'sqlserver') const SizedBox(height: 16),

          _sectionCard(
            isDark: isDark,
            textColor: textColor,
            title: 'اکتیو دایرکتوری (AD)',
            icon: Icons.account_tree,
            children: [
              _field(_adDomain, 'دامنه (مثلاً jpcomplex.local)'),
              _field(_adOu, 'OU (واحد سازمانی)'),
            ],
          ),
          const SizedBox(height: 16),

          _sectionCard(
            isDark: isDark,
            textColor: textColor,
            title: 'SSO',
            icon: Icons.vpn_key,
            children: [
              _field(_ssoUrl, 'آدرس سرور SSO (مثلاً http://172.16.7.54)'),
            ],
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.save),
                label: const Text('ذخیره تنظیمات'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14)),
              ),
              const SizedBox(width: 16),
              if (_saving) const CircularProgressIndicator(),
              if (_status != null)
                Text(_status!,
                    style: const TextStyle(color: Color(0xFF2E7D52))),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2D3552)
                  : const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 18, color: Color(0xFFBA7517)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'این تنظیمات ذخیره می‌شوند. اتصال واقعی به SQL Server و AD/SSO پس از راه‌اندازی API سرور فعال خواهد شد.',
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF777777)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _testApi() async {
    setState(() {
      _testing = true;
      _testResult = null;
    });
    final old = ApiConfig.instance.baseUrl;
    await ApiConfig.instance.setBaseUrl(_apiUrl.text.trim());
    try {
      final res = await ApiClient.instance.get('/api/Health');
      final db = res is Map ? res['database'] : null;
      final env = res is Map ? res['environment'] : null;
      setState(() => _testResult =
          'OK_اتصال موفق بود — دیتابیس: $db — محیط: $env');
    } catch (e) {
      await ApiConfig.instance.setBaseUrl(old);
      setState(() => _testResult = 'ERR_اتصال ناموفق: $e');
    } finally {
      if (mounted) setState(() => _testing = false);
    }
  }

  Future<void> _saveBackend() async {
    await ApiConfig.instance.setBackendMode(_backendMode);
    await ApiConfig.instance.setBaseUrl(_apiUrl.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'حالت اتصال ذخیره شد. برای اعمال کامل، خارج شوید و دوباره وارد شوید.')));
  }

  Widget _buildBackendCard(bool isDark, Color textColor) {
    final isApi = _backendMode == 'api';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('حالت اتصال',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor)),
          const SizedBox(height: 4),
          Text(
              'انتخاب کنید که اپ به دیتابیس محلی (داخل مرورگر) وصل شود یا به سرور (API).',
              style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : const Color(0xFF777777))),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                  value: 'local',
                  label: Text('دیتابیس محلی'),
                  icon: Icon(Icons.storage)),
              ButtonSegment(
                  value: 'api',
                  label: Text('سرور (API)'),
                  icon: Icon(Icons.cloud)),
            ],
            selected: {_backendMode},
            onSelectionChanged: (s) =>
                setState(() => _backendMode = s.first),
          ),
          if (isApi) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _apiUrl,
              decoration: const InputDecoration(
                labelText: 'آدرس سرور (مثلاً http://localhost:5080)',
                border: OutlineInputBorder(),
                isDense: true,
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _testing ? null : _testApi,
                  icon: _testing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.wifi_tethering, size: 18),
                  label: const Text('تست اتصال'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _saveBackend,
                  icon: const Icon(Icons.save, size: 18),
                  label: const Text('ذخیره‌ی حالت'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white),
                ),
              ],
            ),
            if (_testResult != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: _testResult!.startsWith('OK_')
                        ? const Color(0xFF2E7D52).withOpacity(0.12)
                        : const Color(0xFFC0392B).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                    _testResult!.substring(3),
                    style: TextStyle(
                        fontSize: 12,
                        color: _testResult!.startsWith('OK_')
                            ? const Color(0xFF2E7D52)
                            : const Color(0xFFC0392B))),
              ),
            ],
          ] else ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _saveBackend,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('ذخیره‌ی حالت'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _primary, foregroundColor: Colors.white),
            ),
          ],
        ],
      ),
    );
  }


  Widget _sectionCard({
    required bool isDark,
    required Color textColor,
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: _primary),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor)),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}