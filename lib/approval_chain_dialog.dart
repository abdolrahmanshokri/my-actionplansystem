import 'package:flutter/material.dart';
import 'auth_manager.dart';
import 'data_repository.dart';
import 'settings_manager.dart';
import 'season_themes.dart';

const Map<String, String> kApprovalTypeLabels = {
  'or': 'یا (OR) - یکی کافی است',
  'and_sum': 'و-جمعی (And-sum) - همه با هم',
  'and_alone': 'و-تنها (And-alone) - حتماً این یک‌نفر',
};

class ApprovalChainDialog extends StatefulWidget {
  final UnitInfo unit;
  final String unitPath;
  const ApprovalChainDialog(
      {super.key, required this.unit, required this.unitPath});

  @override
  State<ApprovalChainDialog> createState() => _ApprovalChainDialogState();
}

class _ApprovalChainDialogState extends State<ApprovalChainDialog> {
  List<ApprovalStepInfo> _steps = [];
  List<ApprovalStepInfo> _inherited = [];
  List<RoleInfo> _roles = [];
  List<AppUser> _users = [];
  bool _loading = true;

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = AuthManager.instance.repository;
    final steps = await repo.getApprovalSteps(widget.unit.id);
    final roles = await repo.getAllRoles();
    final users = await repo.getAllUsers();
    final inherited = await repo.getParentApprovalSteps(widget.unit.id);
    if (!mounted) return;
    setState(() {
      _steps = steps;
      _inherited = inherited;
      _roles = roles;
      _users = users;
      _loading = false;
    });
  }

  String _subjectName(ApprovalStepInfo s) {
    if (s.subjectType == 'role') {
      final r = _roles.where((x) => x.id == s.roleId);
      return r.isNotEmpty ? 'نقش: ${r.first.title}' : 'نقش نامشخص';
    } else {
      final u = _users.where((x) => x.id == s.userId);
      return u.isNotEmpty ? 'کاربر: ${u.first.fullName}' : 'کاربر نامشخص';
    }
  }

  Future<void> _addStep() async {
    final added = await showDialog<bool>(
      context: context,
      builder: (ctx) =>
          _AddStepDialog(unitId: widget.unit.id, roles: _roles, users: _users),
    );
    if (added == true) await _load();
  }

  Future<void> _deleteStep(ApprovalStepInfo s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف مرحله'),
        content: Text('این مرحله‌ی تأیید (${_subjectName(s)}) حذف شود؟'),
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
    if (confirmed != true) return;
    await AuthManager.instance.repository.deleteApprovalStep(s.id);
    await _load();
  }

  Future<void> _move(ApprovalStepInfo s, bool up) async {
    await AuthManager.instance.repository.moveApprovalStep(s.id, up);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2238);

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('زنجیره‌ی تأیید'),
          const SizedBox(height: 4),
          Text(widget.unitPath,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF777777))),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: _loading
            ? const SizedBox(
                height: 120, child: Center(child: CircularProgressIndicator()))
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_inherited.isNotEmpty) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.account_tree,
                                    size: 16, color: Color(0xFFBA7517)),
                                SizedBox(width: 6),
                                Text('مراحل تأیید واحدهای بالادست (افزوده می‌شوند)',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFBA7517))),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ..._inherited.map((s) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                      '• ${_subjectName(s)}  (${kApprovalTypeLabels[s.approvalType] ?? s.approvalType})',
                                      style: const TextStyle(fontSize: 12)),
                                )),
                            const SizedBox(height: 6),
                            const Text(
                                'این مراحل پس از مراحل خودِ این واحد، روی زنجیره اضافه می‌شوند (اول این واحد، بعد بالادست‌ها).',
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF999999))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (_steps.isEmpty && _inherited.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                              'هنوز زنجیره‌ای تعریف نشده و از بالادست هم چیزی ارث نرسیده',
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.white60
                                      : const Color(0xFF777777),
                                  fontSize: 13)),
                        ),
                      ),

                    for (int i = 0; i < _steps.length; i++)
                      _stepRow(_steps[i], i, isDark, textColor),

                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _addStep,
                      icon: const Icon(Icons.add),
                      label: const Text('افزودن مرحله‌ی تأیید'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor:
                              isDark ? Colors.white : _primary,
                          side: BorderSide(
                              color: isDark
                                  ? Colors.white54
                                  : _primary.withOpacity(0.4)),
                          minimumSize: const Size(double.infinity, 44)),
                    ),
                  ],
                ),
              ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('بستن')),
      ],
    );
  }

  Widget _stepRow(
      ApprovalStepInfo s, int index, bool isDark, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D3552) : const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: _primary,
            child: Text('${index + 1}',
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_subjectName(s),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor)),
                Text(kApprovalTypeLabels[s.approvalType] ?? s.approvalType,
                    style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF777777))),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward, size: 18),
            tooltip: 'بالا',
            onPressed: index == 0 ? null : () => _move(s, true),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward, size: 18),
            tooltip: 'پایین',
            onPressed:
                index == _steps.length - 1 ? null : () => _move(s, false),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18),
            color: const Color(0xFFC0392B),
            tooltip: 'حذف',
            onPressed: () => _deleteStep(s),
          ),
        ],
      ),
    );
  }
}

class _AddStepDialog extends StatefulWidget {
  final int unitId;
  final List<RoleInfo> roles;
  final List<AppUser> users;
  const _AddStepDialog(
      {required this.unitId, required this.roles, required this.users});

  @override
  State<_AddStepDialog> createState() => _AddStepDialogState();
}

class _AddStepDialogState extends State<_AddStepDialog> {
  String _subjectType = 'role';
  int? _roleId;
  int? _userId;
  String _approvalType = 'or';
  String? _error;

  Future<void> _save() async {
    if (_subjectType == 'role' && _roleId == null) {
      setState(() => _error = 'یک نقش انتخاب کنید');
      return;
    }
    if (_subjectType == 'user' && _userId == null) {
      setState(() => _error = 'یک کاربر انتخاب کنید');
      return;
    }
    await AuthManager.instance.repository.addApprovalStep(
      unitId: widget.unitId,
      approvalType: _approvalType,
      subjectType: _subjectType,
      roleId: _subjectType == 'role' ? _roleId : null,
      userId: _subjectType == 'user' ? _userId : null,
    );
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('افزودن مرحله‌ی تأیید'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('تأییدکننده بر اساس:',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('نقش'),
                      value: 'role',
                      groupValue: _subjectType,
                      onChanged: (v) => setState(() => _subjectType = v!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('کاربر'),
                      value: 'user',
                      groupValue: _subjectType,
                      onChanged: (v) => setState(() => _subjectType = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_subjectType == 'role')
                DropdownButtonFormField<int>(
                  initialValue: _roleId,
                  decoration: const InputDecoration(
                      labelText: 'نقش', border: OutlineInputBorder()),
                  items: widget.roles
                      .map((r) => DropdownMenuItem(
                          value: r.id, child: Text(r.title)))
                      .toList(),
                  onChanged: (v) => setState(() => _roleId = v),
                )
              else
                Autocomplete<AppUser>(
                  displayStringForOption: (u) => u.fullName,
                  optionsBuilder: (textValue) {
                    final q = textValue.text.trim();
                    if (q.isEmpty) return widget.users;
                    return widget.users.where((u) =>
                        u.fullName.contains(q) ||
                        u.username.contains(q) ||
                        (u.email ?? '').contains(q));
                  },
                  onSelected: (u) => setState(() => _userId = u.id),
                  fieldViewBuilder:
                      (context, controller, focusNode, onSubmit) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: const InputDecoration(
                        labelText: 'جستجوی کاربر (نام یا نام کاربری)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topRight,
                      child: Material(
                        elevation: 4,
                        child: SizedBox(
                          width: 360,
                          height: options.length > 5
                              ? 250
                              : options.length * 50.0,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            itemBuilder: (context, i) {
                              final u = options.elementAt(i);
                              return ListTile(
                                dense: true,
                                title: Text(u.fullName),
                                subtitle: Text(u.username,
                                    style: const TextStyle(fontSize: 11)),
                                onTap: () => onSelected(u),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              if (_subjectType == 'user' && _userId != null) ...[
                const SizedBox(height: 6),
                Builder(builder: (context) {
                  final sel = widget.users.where((u) => u.id == _userId);
                  if (sel.isEmpty) return const SizedBox.shrink();
                  return Row(
                    children: [
                      const Icon(Icons.check_circle,
                          size: 16, color: Color(0xFF2E7D52)),
                      const SizedBox(width: 6),
                      Text('انتخاب شد: ${sel.first.fullName}',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF2E7D52))),
                    ],
                  );
                }),
              ],
              const SizedBox(height: 16),
              const Text('نوع تأیید:',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              ...kApprovalTypeLabels.entries.map((e) => RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(e.value, style: const TextStyle(fontSize: 13)),
                    value: e.key,
                    groupValue: _approvalType,
                    onChanged: (v) => setState(() => _approvalType = v!),
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
        ElevatedButton(onPressed: _save, child: const Text('افزودن')),
      ],
    );
  }
}