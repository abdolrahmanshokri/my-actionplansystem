import 'package:flutter/material.dart';
import 'auth_manager.dart';
import 'data_repository.dart';
import 'settings_manager.dart';
import 'season_themes.dart';
import 'approval_chain_dialog.dart';

class UnitsManagementContent extends StatefulWidget {
  const UnitsManagementContent({super.key});

  @override
  State<UnitsManagementContent> createState() => _UnitsManagementContentState();
}

class _UnitsManagementContentState extends State<UnitsManagementContent> {
  List<UnitInfo> _units = [];
  bool _loading = true;
  final Set<int> _collapsed = {};

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final units = await AuthManager.instance.repository.getAllUnits();
    if (!mounted) return;
    setState(() {
      _units = units;
      _loading = false;
    });
  }

  List<UnitInfo> _childrenOf(int? parentId) {
    return _units.where((u) => u.parentId == parentId).toList();
  }

  String _pathName(UnitInfo u) {
    final parts = <String>[u.name];
    int? pid = u.parentId;
    while (pid != null) {
      final parent = _units.where((x) => x.id == pid);
      if (parent.isEmpty) break;
      parts.insert(0, parent.first.name);
      pid = parent.first.parentId;
    }
    return parts.join(' ‹ ');
  }

  Future<void> _openUnitDialog({UnitInfo? existing, UnitInfo? parent}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _UnitDialog(
        existing: existing,
        parent: parent,
        pathOfParent: parent != null ? _pathName(parent) : null,
      ),
    );
    if (result == true) await _load();
  }

  Future<void> _deleteUnit(UnitInfo u) async {
    final hasActivities =
        await AuthManager.instance.repository.unitHasActivities(u.id);
    if (!mounted) return;
    if (hasActivities) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xFFC0392B),
          content: Text(
              'این واحد فعالیت دارد. ابتدا فعالیت‌هایش را حذف یا به واحد دیگری منتقل کنید.')));
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف واحد'),
        content: Text('واحد «${u.name}» حذف شود؟'),
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
    final ok = await AuthManager.instance.repository.deleteUnit(u.id);
    if (!mounted) return;
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('این واحد زیرواحد دارد و ابتدا باید آن‌ها حذف شوند')));
    } else {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2238);

    final roots = _childrenOf(null);

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
                    Text('مدیریت واحدها و زیرواحدها',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                    const SizedBox(height: 4),
                    Text('${_units.length} واحد',
                        style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF777777))),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _openUnitDialog(),
                icon: const Icon(Icons.add),
                label: const Text('واحد اصلی جدید'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: _primary, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : roots.isEmpty
                    ? Center(
                        child: Text('هنوز واحدی تعریف نشده است',
                            style: TextStyle(
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xFF777777))))
                    : ListView(
                        children: [
                          for (final root in roots)
                            ..._buildUnitTree(root, isDark, textColor),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildUnitTree(UnitInfo u, bool isDark, Color textColor) {
    final children = _childrenOf(u.id);
    final hasChildren = children.isNotEmpty;
    final isCollapsed = _collapsed.contains(u.id);
    final widgets = <Widget>[_unitRow(u, hasChildren, isCollapsed, isDark, textColor)];

    if (hasChildren && !isCollapsed) {
      for (final child in children) {
        widgets.addAll(_buildUnitTree(child, isDark, textColor));
      }
    }
    return widgets;
  }

  Widget _unitRow(UnitInfo u, bool hasChildren, bool isCollapsed, bool isDark,
      Color textColor) {
    final indent = (u.level - 1) * 28.0;
    final canAddChild = u.level < 3;

    final levelColors = [
      _primary,
      const Color(0xFF0277BD),
      const Color(0xFF777777),
    ];
    final dotColor = levelColors[(u.level - 1).clamp(0, 2)];

    return Padding(
      padding: EdgeInsets.only(right: indent, bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252D45) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color:
                  isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            if (hasChildren)
              InkWell(
                onTap: () => setState(() {
                  if (isCollapsed) {
                    _collapsed.remove(u.id);
                  } else {
                    _collapsed.add(u.id);
                  }
                }),
                child: Icon(
                    isCollapsed
                        ? Icons.chevron_right
                        : Icons.keyboard_arrow_down,
                    size: 22,
                    color: textColor),
              )
            else
              const SizedBox(width: 22),
            const SizedBox(width: 4),
            Icon(Icons.circle, size: 10, color: dotColor),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(u.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: textColor)),
                  if (u.description != null && u.description!.isNotEmpty)
                    Text(u.description!,
                        style: TextStyle(
                            fontSize: 11,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF999999))),
                ],
              ),
            ),
            if (canAddChild)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: OutlinedButton.icon(
                  onPressed: () => _openUnitDialog(parent: u),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('زیرواحد', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark ? Colors.white : _primary,
                    side: BorderSide(
                        color: isDark
                            ? Colors.white54
                            : _primary.withOpacity(0.4)),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            IconButton(
              icon: const Icon(Icons.verified_user, size: 18),
              color: const Color(0xFF2E7D52),
              tooltip: 'زنجیره‌ی تأیید',
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => ApprovalChainDialog(
                    unit: u, unitPath: _pathName(u)),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 18),
              color: const Color(0xFF0277BD),
              tooltip: 'ویرایش',
              onPressed: () => _openUnitDialog(existing: u),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 18),
              color: const Color(0xFFC0392B),
              tooltip: 'حذف',
              onPressed: () => _deleteUnit(u),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitDialog extends StatefulWidget {
  final UnitInfo? existing;
  final UnitInfo? parent;
  final String? pathOfParent;
  const _UnitDialog({this.existing, this.parent, this.pathOfParent});

  @override
  State<_UnitDialog> createState() => _UnitDialogState();
}

class _UnitDialogState extends State<_UnitDialog> {
  late TextEditingController _name;
  late TextEditingController _desc;
  String? _error;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _desc = TextEditingController(text: widget.existing?.description ?? '');
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'نام واحد الزامی است');
      return;
    }
    final repo = AuthManager.instance.repository;
    try {
      if (_isEdit) {
        await repo.updateUnit(
          unitId: widget.existing!.id,
          name: _name.text.trim(),
          description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
        );
      } else {
        final level = widget.parent != null ? widget.parent!.level + 1 : 1;
        await repo.createUnit(
          parentId: widget.parent?.id,
          name: _name.text.trim(),
          description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
          level: level,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = 'خطا: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _isEdit
        ? 'ویرایش واحد'
        : (widget.parent != null ? 'زیرواحد جدید' : 'واحد اصلی جدید');

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.pathOfParent != null && !_isEdit) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('زیرمجموعه‌ی: ${widget.pathOfParent}',
                    style: const TextStyle(
                        fontSize: 12, color: Color(0xFF555555))),
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _name,
              decoration: const InputDecoration(
                  labelText: 'نام واحد', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _desc,
              maxLines: 2,
              decoration: const InputDecoration(
                  labelText: 'توضیحات (اختیاری)',
                  border: OutlineInputBorder()),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!,
                  style: const TextStyle(
                      color: Color(0xFFC0392B), fontSize: 13)),
            ],
          ],
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