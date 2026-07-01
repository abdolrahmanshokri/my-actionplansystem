import 'dart:convert';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';
import 'package:file_picker/file_picker.dart';
import 'auth_manager.dart';
import 'settings_manager.dart';
import 'api_client.dart';
import 'season_themes.dart';

class AdminToolsContent extends StatefulWidget {
  const AdminToolsContent({super.key});

  @override
  State<AdminToolsContent> createState() => _AdminToolsContentState();
}

class _AdminToolsContentState extends State<AdminToolsContent> {
  bool _busy = false;
  String? _status;

  final _titleCtrl = TextEditingController(
      text: SettingsManager.instance.appTitle);
  final _sloganCtrl = TextEditingController(
      text: SettingsManager.instance.appSlogan);
  final _browserTitleCtrl = TextEditingController(
      text: SettingsManager.instance.browserTitle);
  final _systemNameCtrl = TextEditingController(
      text: SettingsManager.instance.systemName);
  bool _savingHeader = false;

  // --- تنظیمات SSO ---
  bool _ssoEnabled = false;
  final _ssoClientIdCtrl = TextEditingController();
  final _ssoClientSecretCtrl = TextEditingController();
  final _ssoAuthorizeCtrl = TextEditingController();
  final _ssoTokenCtrl = TextEditingController();
  final _ssoUserinfoCtrl = TextEditingController();
  final _ssoScopeCtrl = TextEditingController();
  final _ssoUsernameFieldCtrl = TextEditingController();
  bool _ssoLoading = true;
  bool _savingSso = false;

  // --- تنظیمات Active Directory ---
  bool _adEnabled = false;
  final _adLdapCtrl = TextEditingController();
  final _adDomainCtrl = TextEditingController();
  final _adServiceUserCtrl = TextEditingController();
  final _adServicePassCtrl = TextEditingController();
  bool _savingAd = false;

  // --- تنظیمات فونت داینامیک ---
  bool _uploadingFont = false;

  @override
  void initState() {
    super.initState();
    _loadSsoSettings();
  }

  Future<void> _loadSsoSettings() async {
    final repo = AuthManager.instance.repository;
    Future<String> g(String k) async => (await repo.getSetting(k)) ?? '';
    _ssoEnabled = (await g('sso_enabled')) == 'true';
    _ssoClientIdCtrl.text = await g('sso_client_id');
    _ssoClientSecretCtrl.text = await g('sso_client_secret');
    _ssoAuthorizeCtrl.text = await g('sso_authorize_url');
    _ssoTokenCtrl.text = await g('sso_token_url');
    _ssoUserinfoCtrl.text = await g('sso_userinfo_url');
    _ssoScopeCtrl.text = await g('sso_scope');
    _ssoUsernameFieldCtrl.text = await g('sso_username_field');
    _adEnabled = (await g('ad_enabled')) == 'true';
    _adLdapCtrl.text = await g('ad_ldap_path');
    _adDomainCtrl.text = await g('ad_domain');
    _adServiceUserCtrl.text = await g('ad_service_user');
    _adServicePassCtrl.text = await g('ad_service_pass');
    if (!mounted) return;
    setState(() => _ssoLoading = false);
  }

  bool _testingAd = false;

  Future<void> _testAdConnection() async {
    setState(() => _testingAd = true);
    try {
      final res = await ApiClient.instance.post('/api/Auth/ad-test', body: {
        'ldapPath': _adLdapCtrl.text.trim(),
        'serviceUser': _adServiceUserCtrl.text.trim(),
        'servicePass': _adServicePassCtrl.text.trim(),
      });
      final ok = res?['ok'] == true;
      final msg = res?['message']?.toString() ?? '';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: ok ? Colors.green.shade700 : Colors.red.shade700,
        duration: const Duration(seconds: 3),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('خطا در تست: $e'),
        backgroundColor: Colors.red.shade700,
      ));
    } finally {
      if (mounted) setState(() => _testingAd = false);
    }
  }

  Future<void> _saveAdSettings() async {
    setState(() => _savingAd = true);
    final repo = AuthManager.instance.repository;
    await repo.setSetting('ad_enabled', _adEnabled ? 'true' : 'false');
    await repo.setSetting('ad_ldap_path', _adLdapCtrl.text.trim());
    await repo.setSetting('ad_domain', _adDomainCtrl.text.trim());
    await repo.setSetting('ad_service_user', _adServiceUserCtrl.text.trim());
    await repo.setSetting('ad_service_pass', _adServicePassCtrl.text.trim());
    SettingsManager.instance.setAdEnabled(_adEnabled);
    if (!mounted) return;
    setState(() => _savingAd = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('تنظیمات اکتیو دایرکتوری ذخیره شد'),
        duration: Duration(seconds: 2)));
  }

  Future<void> _saveSsoSettings() async {
    setState(() => _savingSso = true);
    final repo = AuthManager.instance.repository;
    await repo.setSetting('sso_enabled', _ssoEnabled ? 'true' : 'false');
    await repo.setSetting('sso_client_id', _ssoClientIdCtrl.text.trim());
    await repo.setSetting('sso_client_secret', _ssoClientSecretCtrl.text.trim());
    await repo.setSetting('sso_authorize_url', _ssoAuthorizeCtrl.text.trim());
    await repo.setSetting('sso_token_url', _ssoTokenCtrl.text.trim());
    await repo.setSetting('sso_userinfo_url', _ssoUserinfoCtrl.text.trim());
    await repo.setSetting('sso_scope', _ssoScopeCtrl.text.trim());
    await repo.setSetting(
        'sso_username_field', _ssoUsernameFieldCtrl.text.trim());
    SettingsManager.instance.setSsoEnabled(_ssoEnabled);
    if (!mounted) return;
    setState(() => _savingSso = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('تنظیمات SSO ذخیره شد'),
        duration: Duration(seconds: 2)));
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _sloganCtrl.dispose();
    _browserTitleCtrl.dispose();
    _systemNameCtrl.dispose();
    _ssoClientIdCtrl.dispose();
    _ssoClientSecretCtrl.dispose();
    _ssoAuthorizeCtrl.dispose();
    _ssoTokenCtrl.dispose();
    _ssoUserinfoCtrl.dispose();
    _ssoScopeCtrl.dispose();
    _ssoUsernameFieldCtrl.dispose();
    _adLdapCtrl.dispose();
    _adDomainCtrl.dispose();
    _adServiceUserCtrl.dispose();
    _adServicePassCtrl.dispose();
    super.dispose();
  }

  Future<String?> _pickImageDataUrl() async {
    final input = html.FileUploadInputElement()
      ..accept = 'image/png,image/jpeg,image/x-icon,image/svg+xml,.ico';
    input.click();
    await input.onChange.first;
    final files = input.files;
    if (files == null || files.isEmpty) return null;
    final file = files.first;
    final reader = html.FileReader();
    reader.readAsDataUrl(file);
    await reader.onLoad.first;
    return reader.result as String?;
  }

  Future<void> _uploadHeaderLogo() async {
    final dataUrl = await _pickImageDataUrl();
    if (dataUrl == null) return;
    final repo = AuthManager.instance.repository;
    await SettingsManager.instance.saveHeaderLogo(dataUrl, repo.setSetting);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('لوگوی هدر ذخیره شد'), duration: Duration(seconds: 2)));
  }

  Future<void> _removeHeaderLogo() async {
    final repo = AuthManager.instance.repository;
    await SettingsManager.instance.saveHeaderLogo('', repo.setSetting);
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _uploadFavicon() async {
    final dataUrl = await _pickImageDataUrl();
    if (dataUrl == null) return;
    final repo = AuthManager.instance.repository;
    await SettingsManager.instance.saveFavicon(dataUrl, repo.setSetting);
    _applyFavicon(dataUrl);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('آیکون تب مرورگر ذخیره شد'),
        duration: Duration(seconds: 2)));
  }

  Future<void> _removeFavicon() async {
    final repo = AuthManager.instance.repository;
    await SettingsManager.instance.saveFavicon('', repo.setSetting);
    if (!mounted) return;
    setState(() {});
  }

  void _applyFavicon(String dataUrl) {
    if (dataUrl.isEmpty) return;
    final existing =
        html.document.querySelectorAll("link[rel*='icon']");
    for (final e in existing) {
      e.remove();
    }
    final link = html.LinkElement()
      ..rel = 'icon'
      ..href = dataUrl;
    html.document.head?.append(link);
  }

  // --- بخش مدیریت فونت اختصاصی ادمین ---
  Future<void> _uploadCustomFont() async {
    setState(() => _uploadingFont = true);
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ttf'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      final bytes = file.bytes;
      final fileName = file.name; // استخراج نام فایل آپلودی

      if (bytes == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('خطا در خواندن فایل فونت')));
        return;
      }

      final base64String = base64Encode(bytes);
      final repo = AuthManager.instance.repository;
      
      // نام فونت را هم برای ذخیره سازی می‌فرستیم
      await SettingsManager.instance.saveCustomFont(base64String, fileName, repo.setSetting);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فونت سفارشی با موفقیت ذخیره و اعمال شد ✓')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در آپلود فونت: $e')));
    } finally {
      if (mounted) setState(() => _uploadingFont = false);
    }
  }

  Future<void> _removeCustomFont() async {
    final repo = AuthManager.instance.repository;
    // ارسال نام خالی برای حذف کامل
    await SettingsManager.instance.saveCustomFont('', '', repo.setSetting);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فونت سفارشی حذف شد؛ سیستم به حالت پیش‌فرض (Vazirmatn) بازگشت.')));
  }

  Widget _imgPreview(String dataUrl) {
    Widget box(Widget child) => Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFBA7517).withOpacity(0.10),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFBA7517).withOpacity(0.3)),
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        );
    if (dataUrl.isEmpty) {
      return box(const Icon(Icons.image_outlined,
          color: Color(0xFFBA7517), size: 22));
    }
    try {
      final base64Part =
          dataUrl.contains(',') ? dataUrl.split(',').last : dataUrl;
      final bytes = base64Decode(base64Part);
      return box(Image.memory(bytes, fit: BoxFit.contain));
    } catch (_) {
      return box(const Icon(Icons.broken_image_outlined,
          color: Color(0xFFBA7517), size: 22));
    }
  }

  Widget _ssoField(String label, TextEditingController ctrl) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  Future<void> _saveHeaderTexts() async {
    setState(() => _savingHeader = true);
    final repo = AuthManager.instance.repository;
    await SettingsManager.instance.saveHeaderTexts(
      title: _titleCtrl.text.trim(),
      slogan: _sloganCtrl.text.trim(),
      browserTitle: _browserTitleCtrl.text.trim(),
      systemName: _systemNameCtrl.text.trim(),
      setSetting: repo.setSetting,
    );
    if (!mounted) return;
    setState(() => _savingHeader = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('متن‌های هدر ذخیره شد'),
        duration: Duration(seconds: 2)));
  }

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  Future<Uint8List> _makeBackup() async {
    return Uint8List.fromList(
        await AuthManager.instance.repository.backupDatabase());
  }

  Future<void> _downloadBackup(Uint8List bytes) async {
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    await FileSaver.instance.saveFile(
      name: 'actionplan_backup_$stamp',
      bytes: bytes,
      fileExtension: 'json',
      mimeType: MimeType.json,
    );
  }

  Future<void> _doBackup() async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final bytes = await _makeBackup();
      await _downloadBackup(bytes);
      setState(() => _status = 'بک‌آپ گرفته شد و دانلود شد ✓');
    } catch (e) {
      setState(() => _status = 'خطا در بک‌آپ: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _doMigrate() async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      await AuthManager.instance.repository.createOrMigrate();
      setState(() => _status = 'ساخت/مهاجرت جدول‌ها انجام شد ✓');
    } catch (e) {
      setState(() => _status = 'خطا در مهاجرت: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _doReset() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ریست دیتابیس'),
        content: const Text(
            'همه‌ی داده‌ها پاک و دوباره ساخته می‌شوند. ابتدا یک بک‌آپ '
            'به‌طور خودکار گرفته و دانلود می‌شود، سپس ریست انجام می‌گیرد.\n\n'
            'آیا مطمئن هستید؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('لغو')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC0392B),
                foregroundColor: Colors.white),
            child: const Text('بک‌آپ و ریست'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      final bytes = await _makeBackup();
      await _downloadBackup(bytes);
      await AuthManager.instance.repository.resetDatabase();
      setState(() =>
          _status = 'بک‌آپ دانلود شد و دیتابیس با موفقیت ریست شد ✓');
    } catch (e) {
      setState(() => _status = 'خطا در ریست: $e');
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2238);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ابزارهای ادمین',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: textColor)),
          const SizedBox(height: 4),
          Text('مدیریت دیتابیس سامانه',
              style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : const Color(0xFF777777))),
          const SizedBox(height: 24),

          _toolCard(
            icon: Icons.build_circle,
            color: _primary,
            title: 'ساخت / مهاجرت جدول‌ها',
            desc:
                'اگر دیتابیس خالی است، همه‌ی جدول‌ها، ایندکس‌ها و داده‌های اولیه ساخته می‌شوند.',
            buttonText: 'اجرای Migrate',
            onPressed: _busy ? null : _doMigrate,
          ),
          const SizedBox(height: 12),
          _toolCard(
            icon: Icons.backup,
            color: const Color(0xFF2E7D52),
            title: 'بک‌آپ دیتابیس',
            desc: 'یک نسخه‌ی پشتیبان از همه‌ی داده‌ها می‌گیرد و دانلود می‌کند.',
            buttonText: 'گرفتن و دانلود بک‌آپ',
            onPressed: _busy ? null : _doBackup,
          ),
          const SizedBox(height: 12),
          _toolCard(
            icon: Icons.restart_alt,
            color: const Color(0xFFC0392B),
            title: 'ریست دیتابیس',
            desc:
                'همه‌ی داده‌ها پاک و از نو ساخته می‌شوند. قبلش به‌طور خودکار بک‌آپ گرفته و دانلود می‌شود.',
            buttonText: 'بک‌آپ و ریست',
            onPressed: _busy ? null : _doReset,
            danger: true,
          ),

          if (AuthManager.instance.currentUser?.isSuperAdmin ?? false) ...[
            const SizedBox(height: 24),
            Text('متن‌های هدر و عنوان',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor)),
            const SizedBox(height: 4),
            Text(
                'نوشته‌های بالای صفحه و عنوان تب مرورگر را اینجا تغییر دهید.',
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : const Color(0xFF777777))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252D45) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? const Color(0xFF3A4468)
                        : const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'نام سیستم (بالا سمت چپ هدر)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _sloganCtrl,
                    decoration: const InputDecoration(
                      labelText: 'شعار (وسط هدر)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _browserTitleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'عنوان تب مرورگر',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _systemNameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'نام سامانه (در صفحه‌ی ورود و خوش‌آمد)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: ElevatedButton.icon(
                      onPressed: _savingHeader ? null : _saveHeaderTexts,
                      icon: _savingHeader
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.save, size: 18),
                      label: const Text('ذخیره‌ی متن‌ها'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('لوگو و آیکون',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor)),
            const SizedBox(height: 4),
            Text(
                'لوگوی بالای صفحه و آیکون تب مرورگر را اینجا آپلود کنید. (PNG یا JPG)',
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : const Color(0xFF777777))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252D45) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? const Color(0xFF3A4468)
                        : const Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _imgPreview(SettingsManager.instance.headerLogo),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('لوگوی هدر (بالا کنار نام سیستم)',
                            style:
                                TextStyle(fontSize: 13, color: textColor)),
                      ),
                      TextButton.icon(
                        onPressed: _uploadHeaderLogo,
                        icon: const Icon(Icons.upload, size: 18),
                        label: const Text('آپلود'),
                      ),
                      if (SettingsManager.instance.hasHeaderLogo)
                        IconButton(
                          tooltip: 'حذف',
                          onPressed: _removeHeaderLogo,
                          icon: const Icon(Icons.delete_outline, size: 20),
                        ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      _imgPreview(SettingsManager.instance.browserFavicon),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text('آیکون تب مرورگر (favicon)',
                            style:
                                TextStyle(fontSize: 13, color: textColor)),
                      ),
                      TextButton.icon(
                        onPressed: _uploadFavicon,
                        icon: const Icon(Icons.upload, size: 18),
                        label: const Text('آپلود'),
                      ),
                      if (SettingsManager.instance.hasFavicon)
                        IconButton(
                          tooltip: 'حذف',
                          onPressed: _removeFavicon,
                          icon: const Icon(Icons.delete_outline, size: 20),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // ---------------- کارت مدیریت فونت آپدیت شده ----------------
            const SizedBox(height: 16),
            Text('فونت اختصاصی سامانه',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor)),
            const SizedBox(height: 4),
            Text(
                'فونت پیش‌فرض سیستم Vazirmatn (آفلاین) است. برای بارگذاری فونت جدید، یک فایل با پسوند ttf انتخاب کنید.',
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : const Color(0xFF777777))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252D45) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? const Color(0xFF3A4468)
                        : const Color(0xFFE0E0E0)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBA7517).withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFBA7517).withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.font_download_outlined,
                        color: Color(0xFFBA7517), size: 22),
                  ),
                  const SizedBox(width: 12),
                  
                  // نمایش وضعیت و نام فونت
                  Expanded(
                    child: Text(
                        SettingsManager.instance.currentFontFamily == 'CustomAdminFont'
                            ? 'فونت اختصاصی آپلود شده: ${SettingsManager.instance.customFontName}' // نام فایل را نشان می‌دهد
                            : 'فونت پیش‌فرض سیستم (Vazirmatn - غیرقابل حذف) فعال است.',
                        style: TextStyle(fontSize: 13, color: textColor, fontWeight: FontWeight.w500)),
                  ),
                  
                  ElevatedButton.icon(
                    onPressed: _uploadingFont ? null : _uploadCustomFont,
                    icon: _uploadingFont
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.upload, size: 18),
                    label: const Text('آپلود فونت (ttf)'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _primary,
                        foregroundColor: Colors.white),
                  ),
                  if (SettingsManager.instance.currentFontFamily == 'CustomAdminFont') ...[
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: 'بازگشت به فونت پیش‌فرض سیستم',
                      onPressed: _removeCustomFont,
                      icon: const Icon(Icons.delete_outline, color: Color(0xFFC0392B)),
                    ),
                  ],
                ],
              ),
            ),
            // -------------------------------------------------------------

            const SizedBox(height: 24),
            Text('ورود یکپارچه (SSO)',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor)),
            const SizedBox(height: 4),
            Text(
                'تنظیمات ورود از طریق سامانه‌ی احراز هویت سازمانی. پس از فعال‌سازی، دکمه‌ی «ورود با SSO» در صفحه‌ی ورود ظاهر می‌شود.',
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : const Color(0xFF777777))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252D45) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? const Color(0xFF3A4468)
                        : const Color(0xFFE0E0E0)),
              ),
              child: _ssoLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('فعال‌سازی ورود با SSO',
                              style:
                                  TextStyle(fontSize: 14, color: textColor)),
                          value: _ssoEnabled,
                          onChanged: (v) => setState(() => _ssoEnabled = v),
                        ),
                        const SizedBox(height: 8),
                        _ssoField('Client ID', _ssoClientIdCtrl),
                        const SizedBox(height: 12),
                        _ssoField('Client Secret', _ssoClientSecretCtrl),
                        const SizedBox(height: 12),
                        _ssoField('Authorize URL', _ssoAuthorizeCtrl),
                        const SizedBox(height: 12),
                        _ssoField('Token URL', _ssoTokenCtrl),
                        const SizedBox(height: 12),
                        _ssoField('User Info URL', _ssoUserinfoCtrl),
                        const SizedBox(height: 12),
                        _ssoField('Scope', _ssoScopeCtrl),
                        const SizedBox(height: 12),
                        _ssoField(
                            'فیلد نام کاربری در پاسخ (مثلاً name)',
                            _ssoUsernameFieldCtrl),
                        const SizedBox(height: 12),
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: ElevatedButton.icon(
                            onPressed: _savingSso ? null : _saveSsoSettings,
                            icon: _savingSso
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2))
                                : const Icon(Icons.save, size: 18),
                            label: const Text('ذخیره‌ی تنظیمات SSO'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: _primary,
                                foregroundColor: Colors.white),
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            Text('ورود با اکتیو دایرکتوری (AD)',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor)),
            const SizedBox(height: 4),
            Text(
                'ورود کاربران با نام کاربری و رمز اکتیو دایرکتوری سازمان. پس از فعال‌سازی، تب «اکتیو دایرکتوری» در صفحه‌ی ورود ظاهر می‌شود.',
                style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : const Color(0xFF777777))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252D45) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? const Color(0xFF3A4468)
                        : const Color(0xFFE0E0E0)),
              ),
              child: _ssoLoading
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('فعال‌سازی ورود با اکتیو دایرکتوری',
                              style:
                                  TextStyle(fontSize: 14, color: textColor)),
                          value: _adEnabled,
                          onChanged: (v) => setState(() => _adEnabled = v),
                        ),
                        const SizedBox(height: 8),
                        _ssoField('آدرس LDAP (مثلاً LDAP://172.31.15.2)',
                            _adLdapCtrl),
                        const SizedBox(height: 12),
                        _ssoField('دامنه (مثلاً jpc.ir)', _adDomainCtrl),
                        const SizedBox(height: 12),
                        _ssoField('کاربر سرویس (برای خواندن نام نمایشی)',
                            _adServiceUserCtrl),
                        const SizedBox(height: 12),
                        _ssoField('رمز کاربر سرویس', _adServicePassCtrl),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _savingAd ? null : _saveAdSettings,
                              icon: _savingAd
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))
                                  : const Icon(Icons.save, size: 18),
                              label: const Text('ذخیره‌ی تنظیمات AD'),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: _primary,
                                  foregroundColor: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: _testingAd ? null : _testAdConnection,
                              icon: _testingAd
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2))
                                  : const Icon(Icons.wifi_tethering, size: 18),
                              label: const Text('تست اتصال'),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 24),
            Text('تنظیمات توسعه‌دهنده',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF252D45) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDark
                        ? const Color(0xFF3A4468)
                        : const Color(0xFFE0E0E0)),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                secondary: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                      color: const Color(0xFFBA7517).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.developer_mode,
                      color: Color(0xFFBA7517)),
                ),
                title: Text('حالت توسعه‌دهنده (Developer Mode)',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textColor)),
                subtitle: Text(
                    'وقتی روشن باشد، دکمه‌های ورود سریع در صفحه‌ی لاگین نمایش داده می‌شوند.',
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF777777))),
                value: AuthManager.instance.developerMode,
                activeColor: const Color(0xFFBA7517),
                onChanged: (v) async {
                  await AuthManager.instance.setDeveloperMode(v);
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('دسترسی نمایش فعالیت‌ها',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor)),
            const SizedBox(height: 4),
            Text(
                'تعیین کنید که تیک‌های «نمایش غیرفعال‌ها» و «نمایش بدون تارگت» برای چه نقش‌هایی فعال باشد. (ادمین و سوپرادمین همیشه می‌بینند.)',
                style: TextStyle(
                    fontSize: 12,
                    color:
                        isDark ? Colors.white60 : const Color(0xFF777777))),
            const SizedBox(height: 8),
            _visSwitch(
                'نمایش غیرفعال‌ها برای ادمین۲',
                AuthManager.instance.showInactiveAdmin2,
                'show_inactive_admin2',
                textColor,
                isDark),
            _visSwitch(
                'نمایش غیرفعال‌ها برای کاربران عادی',
                AuthManager.instance.showInactiveUser,
                'show_inactive_user',
                textColor,
                isDark),
            _visSwitch(
                'نمایش بدون تارگت برای ادمین۲',
                AuthManager.instance.showNoTargetAdmin2,
                'show_notarget_admin2',
                textColor,
                isDark),
            _visSwitch(
                'نمایش بدون تارگت برای کاربران عادی',
                AuthManager.instance.showNoTargetUser,
                'show_notarget_user',
                textColor,
                isDark),
          ],

          if (_busy) ...[
            const SizedBox(height: 20),
            const Center(child: CircularProgressIndicator()),
          ],
          if (_status != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E3A2A)
                    : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_status!,
                  style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF1B5E20))),
            ),
          ],
        ],
      ),
    );
  }

  Widget _visSwitch(String title, bool value, String key, Color textColor,
      bool isDark) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(title,
          style: TextStyle(fontSize: 13, color: textColor)),
      value: value,
      activeColor: const Color(0xFF2E7D52),
      onChanged: (v) async {
        await AuthManager.instance.setVisibilitySetting(key, v);
        setState(() {});
      },
    );
  }

  Widget _toolCard({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required String buttonText,
    required VoidCallback? onPressed,
    bool danger = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2238);
    final cardColor = isDark ? const Color(0xFF252D45) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color:
                isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: textColor)),
                const SizedBox(height: 4),
                Text(desc,
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF777777))),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: color, foregroundColor: Colors.white),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}