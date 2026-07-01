import 'package:flutter/material.dart';
import 'auth_manager.dart';
import 'data_repository.dart';
import 'settings_manager.dart';
import 'season_themes.dart';
import 'searchable_picker.dart';

class ActivitiesManagementContent extends StatefulWidget {
  const ActivitiesManagementContent({super.key});

  @override
  State<ActivitiesManagementContent> createState() =>
      _ActivitiesManagementContentState();
}

class _ActivitiesManagementContentState
    extends State<ActivitiesManagementContent> {
  List<UnitInfo> _units = [];
  List<ActivityInfo> _activities = [];
  List<AppUser> _users = [];
  UnitInfo? _selectedUnit;
  bool _allUnitsSelected = false;
  bool _includeSubunits = false;
  String _typeFilter = 'all';  bool _loadingUnits = true;
  bool _loadingActivities = false;
  String _search = '';
  final Set<int> _collapsed = {};

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    setState(() => _loadingUnits = true);
    final repo = AuthManager.instance.repository;
    final units = await repo.getAllUnits();
    final users = await repo.getAllUsers();
    if (!mounted) return;
    setState(() {
      _units = units;
      _users = users;
      _loadingUnits = false;
    });
  }

  List<int> _descendantIds(int unitId) {
    final result = <int>[unitId];
    final queue = <int>[unitId];
    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      for (final u in _units.where((x) => x.parentId == current)) {
        result.add(u.id);
        queue.add(u.id);
      }
    }
    return result;
  }

  Future<void> _loadActivities() async {
    setState(() => _loadingActivities = true);
    final repo = AuthManager.instance.repository;
    final acts = <ActivityInfo>[];

    List<int> unitIds;
    if (_allUnitsSelected) {
      unitIds = _includeSubunits
          ? _units.map((u) => u.id).toList()
          : _units.where((u) => u.parentId == null).map((u) => u.id).toList();
    } else if (_selectedUnit != null) {
      unitIds = _includeSubunits
          ? _descendantIds(_selectedUnit!.id)
          : [_selectedUnit!.id];
    } else {
      unitIds = [];
    }

    for (final uid in unitIds) {
      acts.addAll(await repo.getActivitiesForUnit(uid));
    }

    if (!mounted) return;
    setState(() {
      _activities = acts;
      _loadingActivities = false;
    });
  }

  List<UnitInfo> _childrenOf(int? parentId) =>
      _units.where((u) => u.parentId == parentId).toList();

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

  String _pathNameById(int unitId) {
    final f = _units.where((u) => u.id == unitId);
    if (f.isEmpty) return '';
    return _pathName(f.first);
  }

  List<ActivityInfo> get _filteredActivities {
    var list = _activities;
    if (_typeFilter == 'kpi') {
      list = list.where((a) => a.isKpi).toList();
    } else if (_typeFilter == 'project') {
      list = list.where((a) => a.isProject).toList();
    }
    if (_search.trim().isEmpty) return list;
    final q = _search.trim();
    return list
        .where((a) =>
            a.name.contains(q) ||
            (a.activityNumber ?? '').contains(q) ||
            _pathNameById(a.unitId).contains(q))
        .toList();
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
          Text('مدیریت فعالیت‌ها',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: textColor)),
          const SizedBox(height: 4),
          Text('یک واحد را انتخاب کنید و فعالیت‌هایش را مدیریت کنید',
              style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : const Color(0xFF777777))),
          const SizedBox(height: 16),
          Expanded(
            child: _loadingUnits
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 280,
                        child: _buildUnitsTree(isDark, textColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: _buildActivitiesPanel(isDark, textColor)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitsTree(bool isDark, Color textColor) {
    final roots = _childrenOf(null);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _allUnitsSelected = true;
                _selectedUnit = null;
              });
              _loadActivities();
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: _allUnitsSelected ? _primary.withOpacity(0.15) : null,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_tree,
                      size: 18,
                      color: _allUnitsSelected
                          ? (isDark ? const Color(0xFFE8B339) : _primary)
                          : textColor),
                  const SizedBox(width: 8),
                  Text('واحدها (همه)',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _allUnitsSelected
                              ? (isDark ? const Color(0xFFE8B339) : _primary)
                              : textColor)),
                ],
              ),
            ),
          ),
          const Divider(height: 16),
          Expanded(
            child: roots.isEmpty
                ? Center(
                    child: Text('واحدی نیست',
                        style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF777777))))
                : ListView(
                    children: [
                      for (final r in roots)
                        ..._buildUnitNode(r, isDark, textColor),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildUnitNode(UnitInfo u, bool isDark, Color textColor) {
    final children = _childrenOf(u.id);
    final hasChildren = children.isNotEmpty;
    final isCollapsed = _collapsed.contains(u.id);
    final isSelected = !_allUnitsSelected && _selectedUnit?.id == u.id;
    final indent = (u.level - 1) * 16.0;

    final widgets = <Widget>[
      InkWell(
        onTap: () {
          setState(() {
            _selectedUnit = u;
            _allUnitsSelected = false;
          });
          _loadActivities();
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.only(
              right: indent + 4, top: 8, bottom: 8, left: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? const Color(0xFF3A4468)
                    : _primary.withOpacity(0.12))
                : null,
            borderRadius: BorderRadius.circular(6),
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
                      size: 18,
                      color: textColor),
                )
              else
                const SizedBox(width: 18),
              const SizedBox(width: 4),
              Icon(Icons.circle,
                  size: 8,
                  color: isSelected
                      ? (isDark ? const Color(0xFFE8B339) : _primary)
                      : Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(u.name,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected
                            ? (isDark ? const Color(0xFFE8B339) : _primary)
                            : textColor)),
              ),
            ],
          ),
        ),
      ),
    ];

    if (hasChildren && !isCollapsed) {
      for (final c in children) {
        widgets.addAll(_buildUnitNode(c, isDark, textColor));
      }
    }
    return widgets;
  }

  Widget _buildActivitiesPanel(bool isDark, Color textColor) {
    final nothingSelected = !_allUnitsSelected && _selectedUnit == null;
    if (nothingSelected) {
      return Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252D45) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color:
                  isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
        ),
        child: Center(
          child: Text(
              'برای دیدن فعالیت‌ها، یک واحد یا «واحدها (همه)» را انتخاب کنید',
              style: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xFF777777))),
        ),
      );
    }

    final title = _allUnitsSelected
        ? 'همه‌ی واحدها'
        : _pathName(_selectedUnit!);
    final list = _filteredActivities;

    return Container(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor)),
                    Text('${list.length} فعالیت',
                        style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF777777))),
                  ],
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _includeSubunits,
                    onChanged: (v) {
                      setState(() => _includeSubunits = v ?? false);
                      _loadActivities();
                    },
                  ),
                  Text('نمایش با زیرواحدها',
                      style: TextStyle(fontSize: 12, color: textColor)),
                  const SizedBox(width: 12),
                  if (!_allUnitsSelected)
                    ElevatedButton.icon(
                      onPressed: () => _openActivityDialog(),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('فعالیت جدید'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'جستجوی نام، شماره یا واحد...',
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              isDense: true,
              filled: true,
              fillColor: isDark ? const Color(0xFF2D3552) : Colors.white,
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('نوع:',
                  style: TextStyle(fontSize: 12, color: textColor)),
              const SizedBox(width: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'all', label: Text('همه')),
                  ButtonSegment(value: 'project', label: Text('پروژه (P)')),
                  ButtonSegment(value: 'kpi', label: Text('KPI (K)')),
                ],
                selected: {_typeFilter},
                onSelectionChanged: (s) =>
                    setState(() => _typeFilter = s.first),
                style: ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    textStyle: WidgetStateProperty.all(
                        const TextStyle(fontSize: 12))),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loadingActivities
                ? const Center(child: CircularProgressIndicator())
                : list.isEmpty
                    ? Center(
                        child: Text('فعالیتی برای نمایش نیست',
                            style: TextStyle(
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xFF777777))))
                    : ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) =>
                            _activityRow(list[i], isDark, textColor),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _activityRow(ActivityInfo a, bool isDark, Color textColor) {
    final typeColor =
        a.isProject ? const Color(0xFF0277BD) : const Color(0xFF2E7D52);
    final showUnitPath = _allUnitsSelected || _includeSubunits;
    final dim = !a.isActive;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D3552) : const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: typeColor.withOpacity(0.15),
                shape: BoxShape.circle),
            child: Text(a.isProject ? 'P' : 'K',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: typeColor)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                          a.activityNumber != null &&
                                  a.activityNumber!.isNotEmpty
                              ? '${a.activityNumber} - ${a.name}'
                              : a.name,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: dim
                                  ? (isDark
                                      ? Colors.white38
                                      : const Color(0xFFAAAAAA))
                                  : textColor)),
                    ),
                    if (dim) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color:
                                const Color(0xFF999999).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text('غیرفعال',
                            style: TextStyle(
                                fontSize: 10, color: Color(0xFF999999))),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                if (showUnitPath)
                  Text('واحد: ${_pathNameById(a.unitId)}',
                      style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFFE8B339)
                              : _primary)),
                Text(
                    'وزن: ${a.weight.toStringAsFixed(1)}'
                    '${a.ownerName != null ? "  •  مسئول: ${a.ownerName}" : ""}'
                    '${a.collaborators.isNotEmpty ? "  •  ${a.collaborators.length} واحد همکار" : ""}',
                    style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF777777))),
              ],
            ),
          ),
          IconButton(
            icon: Icon(a.isActive ? Icons.toggle_on : Icons.toggle_off,
                size: 22),
            color: a.isActive
                ? const Color(0xFF2E7D52)
                : const Color(0xFF999999),
            tooltip: a.isActive ? 'غیرفعال‌کردن' : 'فعال‌کردن',
            onPressed: () => _toggleActivityActive(a),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            color: const Color(0xFF0277BD),
            tooltip: 'ویرایش',
            onPressed: () => _openActivityDialog(existing: a),
          ),
          IconButton(
            icon: const Icon(Icons.delete, size: 18),
            color: const Color(0xFFC0392B),
            tooltip: 'حذف',
            onPressed: () => _deleteActivity(a),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleActivityActive(ActivityInfo a) async {
    await AuthManager.instance.repository
        .setActivityActive(a.id, !a.isActive);
    await _loadActivities();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(a.isActive
            ? 'فعالیت غیرفعال شد'
            : 'فعالیت فعال شد')));
  }

  Future<void> _openActivityDialog({ActivityInfo? existing}) async {
    final targetUnitId = existing?.unitId ?? _selectedUnit?.id;
    if (targetUnitId == null) return;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _ActivityDialog(
        unitId: targetUnitId,
        users: _users,
        units: _units.where((u) => u.id != targetUnitId).toList(),
        allUnits: _units,
        existingActivities: _activities,
        existing: existing,
      ),
    );
    if (result == true) await _loadActivities();
  }

  Future<void> _deleteActivity(ActivityInfo a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف فعالیت'),
        content: Text('فعالیت «${a.name}» حذف شود؟'),
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
    await AuthManager.instance.repository.deleteActivity(a.id);
    await _loadActivities();
  }
}

class _ActivityDialog extends StatefulWidget {
  final int unitId;
  final List<AppUser> users;
  final List<UnitInfo> units;
  final List<UnitInfo> allUnits;
  final List<ActivityInfo> existingActivities;
  final ActivityInfo? existing;
  const _ActivityDialog(
      {required this.unitId,
      required this.users,
      required this.units,
      required this.allUnits,
      required this.existingActivities,
      this.existing});

  @override
  State<_ActivityDialog> createState() => _ActivityDialogState();
}

class _ActivityDialogState extends State<_ActivityDialog> {
  late TextEditingController _number;
  late TextEditingController _name;
  late TextEditingController _weight;
  late TextEditingController _desc;
  String _type = 'project';
  int? _ownerId;
  late List<_CollabRow> _collabs;
  String? _error;

  bool get _isEdit => widget.existing != null;

  String _unitPath(int unitId) {
    final list = widget.allUnits;
    final parts = <String>[];
    int? id = unitId;
    while (id != null) {
      final found = list.where((u) => u.id == id);
      if (found.isEmpty) break;
      parts.insert(0, found.first.name);
      id = found.first.parentId;
    }
    return parts.join(' ‹ ');
  }

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _number = TextEditingController(text: e?.activityNumber ?? '');
    _name = TextEditingController(text: e?.name ?? '');
    _weight = TextEditingController(text: e?.weight.toStringAsFixed(1) ?? '');
    _desc = TextEditingController(text: e?.description ?? '');
    _type = e?.activityType ?? 'project';
    _ownerId = e?.ownerUserId;
    _collabs = (e?.collaborators ?? [])
        .map((c) => _CollabRow(unitId: c.unitId, weight: c.weight))
        .toList();
  }

  double get _collabSum =>
      _collabs.fold(0.0, (sum, c) => sum + (c.weight ?? 0));

  Future<void> _save() async {
    setState(() => _error = null);
    if (_name.text.trim().isEmpty) {
      setState(() => _error = 'نام فعالیت الزامی است');
      return;
    }

    final number = _number.text.trim();
    if (number.isNotEmpty) {
      final ownerUnitId = await AuthManager.instance.repository
          .activityNumberOwnerUnit(number, exceptId: widget.existing?.id);
      if (ownerUnitId != null) {
        setState(() => _error =
            'شماره‌ی «$number» قبلاً در واحد «${_unitPath(ownerUnitId)}» ثبت شده است');
        return;
      }
    }
    final weight = double.tryParse(_weight.text.trim()) ?? 0;

    if (_collabs.isNotEmpty) {
      for (final c in _collabs) {
        if (c.unitId == null) {
          setState(() => _error = 'برای همه‌ی همکاران، واحد انتخاب کنید');
          return;
        }
      }
      if ((_collabSum - 100).abs() > 0.01) {
        setState(() => _error =
            'مجموع وزن همکاران باید ۱۰۰ باشد (الان ${_collabSum.toStringAsFixed(1)})');
        return;
      }
    }

    final collaborators = _collabs
        .map((c) => CollaboratorInfo(
            unitId: c.unitId!, unitName: '', weight: c.weight ?? 0))
        .toList();

    final repo = AuthManager.instance.repository;
    try {
      if (_isEdit) {
        await repo.updateActivity(
          activityId: widget.existing!.id,
          activityNumber:
              _number.text.trim().isEmpty ? null : _number.text.trim(),
          name: _name.text.trim(),
          activityType: _type,
          weight: weight,
          ownerUserId: _ownerId,
          description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
          collaborators: collaborators,
        );
      } else {
        await repo.createActivity(
          unitId: widget.unitId,
          activityNumber:
              _number.text.trim().isEmpty ? null : _number.text.trim(),
          name: _name.text.trim(),
          activityType: _type,
          weight: weight,
          ownerUserId: _ownerId,
          description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
          collaborators: collaborators,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      setState(() => _error = 'خطا در ذخیره');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'ویرایش فعالیت' : 'فعالیت جدید'),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _number,
                      decoration: const InputDecoration(
                          labelText: 'شماره', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _name,
                      decoration: const InputDecoration(
                          labelText: 'نام فعالیت',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _type,
                      decoration: const InputDecoration(
                          labelText: 'نوع', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(
                            value: 'project', child: Text('پروژه')),
                        DropdownMenuItem(value: 'kpi', child: Text('KPI')),
                      ],
                      onChanged: (v) => setState(() => _type = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: _weight,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'وزن', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SearchablePicker(
                labelText: 'مسئول / مدیر (اختیاری)',
                selectedId: _ownerId,
                onChanged: (v) => setState(() => _ownerId = v),
                options: widget.users
                    .map((u) => SearchableOption(
                        id: u.id, label: u.fullName, sublabel: u.username))
                    .toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _desc,
                maxLines: 2,
                decoration: const InputDecoration(
                    labelText: 'توضیحات (اختیاری)',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Text('واحدهای همکار (مجموع وزن باید ۱۰۰ باشد):',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  Text('جمع: ${_collabSum.toStringAsFixed(1)}',
                      style: TextStyle(
                          fontSize: 12,
                          color: (_collabSum - 100).abs() < 0.01 || _collabs.isEmpty
                              ? const Color(0xFF2E7D52)
                              : const Color(0xFFC0392B))),
                ],
              ),
              const SizedBox(height: 8),
              ..._collabs.asMap().entries.map((entry) {
                final i = entry.key;
                final c = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchablePicker(
                          labelText: 'واحد همکار',
                          dense: true,
                          selectedId: c.unitId,
                          onChanged: (v) => setState(() => c.unitId = v),
                          options: widget.units
                              .map((u) => SearchableOption(
                                  id: u.id,
                                  label: _unitPath(u.id),
                                  sublabel: u.name))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: c.controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'وزن',
                              border: OutlineInputBorder(),
                              isDense: true),
                          onChanged: (v) =>
                              setState(() => c.weight = double.tryParse(v)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            size: 20, color: Color(0xFFC0392B)),
                        onPressed: () => setState(() => _collabs.removeAt(i)),
                      ),
                    ],
                  ),
                );
              }),
              TextButton.icon(
                onPressed: () => setState(() => _collabs.add(_CollabRow())),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('افزودن واحد همکار'),
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

class _CollabRow {
  int? unitId;
  double? weight;
  final TextEditingController controller;
  _CollabRow({this.unitId, this.weight})
      : controller = TextEditingController(
            text: weight != null ? weight.toString() : '');
}