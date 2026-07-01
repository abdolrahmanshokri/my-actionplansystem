import 'package:flutter/material.dart';
import 'auth_manager.dart';
import 'data_repository.dart';
import 'settings_manager.dart';
import 'season_themes.dart';

class UsersManagementContent extends StatefulWidget {
  const UsersManagementContent({super.key});

  @override
  State<UsersManagementContent> createState() => _UsersManagementContentState();
}

class _UsersManagementContentState extends State<UsersManagementContent> {
  List<AppUser> _users = [];
  List<RoleInfo> _roles = [];
  bool _loading = true;
  String _search = '';

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = AuthManager.instance.repository;
    final users = await repo.getAllUsers();
    final roles = await repo.getAllRoles();
    if (!mounted) return;
    setState(() {
      _users = users;
      _roles = roles;
      _loading = false;
    });
  }

  List<AppUser> get _filtered {
    if (_search.trim().isEmpty) return _users;
    final q = _search.trim();
    return _users
        .where((u) =>
            u.fullName.contains(q) ||
            u.username.contains(q) ||
            (u.email ?? '').contains(q))
        .toList();
  }

  Future<void> _openUserDialog({AppUser? existing}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _UserDialog(roles: _roles, existing: existing),
    );
    if (result == true) {
      await _load();
    }
  }

  Future<void> _deleteUser(AppUser user) async {
    if (user.username == AuthManager.instance.currentUser?.username) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('نمی‌توانید حساب خودتان را حذف کنید')),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف کاربر'),
        content: Text('کاربر «${user.fullName}» حذف شود؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('لغو')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC0392B),
                foregroundColor: Colors.white),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await AuthManager.instance.repository.deleteUser(user.id);
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2238);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مدیریت کاربران و نقش‌ها',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                    const SizedBox(height: 4),
                    Text('${_users.length} کاربر',
                        style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF777777))),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _openUserDialog(),
                icon: const Icon(Icons.add),
                label: const Text('کاربر جدید'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _primary, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'جستجوی نام، نام کاربری یا ایمیل...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: isDark ? const Color(0xFF252D45) : Colors.white,
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) =>
                        _userRow(_filtered[i], isDark, textColor),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _userRow(AppUser user, bool isDark, Color textColor) {
    final roleTitles = user.roleCodes.map((c) {
      final r = _roles.where((x) => x.code == c);
      return r.isNotEmpty ? r.first.title : c;
    }).toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _primary.withOpacity(0.15),
            child: Icon(Icons.person, color: _primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(user.fullName,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                    const SizedBox(width: 8),
                    if (!user.isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFDECEA),
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text('غیرفعال',
                            style: TextStyle(
                                fontSize: 11, color: Color(0xFFC0392B))),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                    '${user.username}   •   ${roleTitles.isEmpty ? "بدون نقش" : roleTitles.join("، ")}',
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF777777))),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            color: _primary,
            tooltip: 'ویرایش',
            onPressed: () => _openUserDialog(existing: user),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: const Color(0xFFC0392B),
            tooltip: 'حذف',
            onPressed: () => _deleteUser(user),
          ),
        ],
      ),
    );
  }
}

class _UserDialog extends StatefulWidget {
  final List<RoleInfo> roles;
  final AppUser? existing;
  const _UserDialog({required this.roles, this.existing});

  @override
  State<_UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<_UserDialog> {
  late TextEditingController _username;
  late TextEditingController _fullName;
  late TextEditingController _email;
  late TextEditingController _password;
  late Set<int> _selectedRoles;
  late bool _isActive;
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _username = TextEditingController(text: e?.username ?? '');
    _fullName = TextEditingController(text: e?.fullName ?? '');
    _email = TextEditingController(text: e?.email ?? '');
    _password = TextEditingController();
    _selectedRoles = (e?.roleIds ?? []).toSet();
    _isActive = e?.isActive ?? true;
  }

  Future<void> _save() async {
    if (_username.text.trim().isEmpty || _fullName.text.trim().isEmpty) {
      setState(() => _error = 'نام کاربری و نام کامل الزامی است');
      return;
    }
    if (_selectedRoles.isEmpty) {
      setState(() => _error = 'حداقل یک نقش انتخاب کنید');
      return;
    }

    final repo = AuthManager.instance.repository;
    try {
      if (_isEdit) {
        await repo.updateUser(
          userId: widget.existing!.id,
          fullName: _fullName.text.trim(),
          email: _email.text.trim().isEmpty ? null : _email.text.trim(),
          isActive: _isActive,
          roleIds: _selectedRoles.toList(),
        );
        if (_password.text.isNotEmpty) {
          await repo.setUserPassword(widget.existing!.id, _password.text);
        }
      } else {
        await repo.createUser(
          username: _username.text.trim(),
          fullName: _fullName.text.trim(),
          email: _email.text.trim().isEmpty ? null : _email.text.trim(),
          password: _password.text.isEmpty ? null : _password.text,
          roleIds: _selectedRoles.toList(),
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = 'خطا: نام کاربری تکراری است یا مشکلی پیش آمد');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'ویرایش کاربر' : 'کاربر جدید'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _username,
                enabled: !_isEdit,
                decoration: const InputDecoration(
                    labelText: 'نام کاربری', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _fullName,
                decoration: const InputDecoration(
                    labelText: 'نام کامل', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _email,
                decoration: const InputDecoration(
                    labelText: 'ایمیل (اختیاری)',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: _isEdit
                        ? 'رمز عبور جدید (خالی = بدون تغییر)'
                        : 'رمز عبور (برای ورود لوکال)',
                    border: const OutlineInputBorder()),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('فعال'),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                ),
              ],
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerRight,
                child: Text('نقش‌ها:',
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 4),
              ...widget.roles.map((r) => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(r.title),
                    value: _selectedRoles.contains(r.id),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          _selectedRoles.add(r.id);
                        } else {
                          _selectedRoles.remove(r.id);
                        }
                      });
                    },
                  )),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!,
                    style: const TextStyle(
                        color: Color(0xFFC0392B), fontSize: 13)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('لغو')),
        ElevatedButton(onPressed: _save, child: const Text('ذخیره')),
      ],
    );
  }
}