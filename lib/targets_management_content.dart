import 'package:flutter/material.dart';
import 'auth_manager.dart';
import 'data_repository.dart';
import 'settings_manager.dart';
import 'season_themes.dart';
import 'searchable_picker.dart';

class TargetsManagementContent extends StatefulWidget {
  const TargetsManagementContent({super.key});

  @override
  State<TargetsManagementContent> createState() =>
      _TargetsManagementContentState();
}

class _TargetsManagementContentState extends State<TargetsManagementContent> {
  List<YearInfo> _years = [];
  List<UnitInfo> _units = [];
  List<ActivityInfo> _allActivities = [];
  List<PeriodInfo> _periods = [];
  Set<int> _withTargetIds = {};

  int? _yearId;
  int? _unitId;
  ActivityInfo? _activity;
  int? _existingTargetId;

  String _search = '';
  String _filterMode = 'all';
  String _typeFilter = 'all';

  bool _loading = true;

  double _startValue = 0;
  String _distType = 'uniform';
  int? _distStartPeriodId;
  int? _distEndPeriodId;
  final Map<int, TextEditingController> _periodControllers = {};
  final Map<int, bool> _periodActive = {};
  final TextEditingController _startController = TextEditingController();

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  @override
  void initState() {
    super.initState();
    _loadBase();
  }

  Future<void> _loadBase() async {
    final repo = AuthManager.instance.repository;
    final years = await repo.getAllYears();
    final units = await repo.getAllUnits();
    final acts = await repo.getAllActivities();
    if (!mounted) return;

    int? presetYear;
    if (years.isNotEmpty) {
      final sorted = [...years]
        ..sort((a, b) => b.yearValue.compareTo(a.yearValue));
      presetYear = sorted.first.id;
    }

    setState(() {
      _years = years;
      _units = units;
      _allActivities = acts;
      _loading = false;
      _yearId = presetYear;
    });

    if (presetYear != null) {
      final ids = await repo.activityIdsWithTargetInYear(presetYear);
      if (!mounted) return;
      setState(() => _withTargetIds = ids);
    }
  }

  String _unitPath(int unitId) {
    final parts = <String>[];
    int? id = unitId;
    while (id != null) {
      final f = _units.where((u) => u.id == id);
      if (f.isEmpty) break;
      parts.insert(0, f.first.name);
      id = f.first.parentId;
    }
    return parts.join(' ‹ ');
  }

  Future<void> _onYearChanged(int? v) async {
    setState(() {
      _yearId = v;
      _activity = null;
      _periods = [];
    });
    if (v != null) {
      final ids = await AuthManager.instance.repository
          .activityIdsWithTargetInYear(v);
      if (!mounted) return;
      setState(() => _withTargetIds = ids);
    } else {
      setState(() => _withTargetIds = {});
    }
  }

  List<ActivityInfo> get _filteredActivities {
    var list = _allActivities;

    if (_unitId != null) {
      list = list.where((a) => a.unitId == _unitId).toList();
    }

    if (_search.trim().isNotEmpty) {
      final q = _search.trim();
      list = list
          .where((a) =>
              a.name.contains(q) ||
              (a.activityNumber ?? '').contains(q) ||
              _unitPath(a.unitId).contains(q))
          .toList();
    }

    if (_yearId != null && _filterMode != 'all') {
      if (_filterMode == 'with') {
        list = list.where((a) => _withTargetIds.contains(a.id)).toList();
      } else if (_filterMode == 'without') {
        list = list.where((a) => !_withTargetIds.contains(a.id)).toList();
      }
    }

    if (_typeFilter == 'kpi') {
      list = list.where((a) => a.isKpi).toList();
    } else if (_typeFilter == 'project') {
      list = list.where((a) => a.isProject).toList();
    }

    return list;
  }

  Future<void> _selectActivity(ActivityInfo a) async {
    if (_yearId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ابتدا سال را انتخاب کنید')));
      return;
    }
    setState(() {
      _activity = a;
      _unitId = a.unitId;
    });
    await _loadTargetForActivity();
  }

  Future<void> _loadTargetForActivity() async {
    if (_activity == null || _yearId == null) return;
    final repo = AuthManager.instance.repository;
    final periods = await repo.getPeriodsForYear(_yearId!);
    final target = await repo.getTarget(_activity!.id, _yearId!);
    _existingTargetId = target?.id;

    _periodControllers.clear();
    _periodActive.clear();
    final existingValues = <int, double>{};
    final existingActive = <int, bool>{};
    if (target != null) {
      for (final p in target.periods) {
        existingValues[p.periodId] = p.targetValue;
        existingActive[p.periodId] = p.isActive;
      }
    }

    for (final p in periods) {
      double val;
      if (_activity!.isKpi) {
        val = 100;
      } else if (target != null && existingValues.containsKey(p.id)) {
        val = existingValues[p.id]!;
      } else {
        val = 0;
      }
      _periodControllers[p.id] =
          TextEditingController(text: val.toStringAsFixed(2));
      _periodActive[p.id] = existingActive[p.id] ?? true;
    }

    if (!mounted) return;
    setState(() {
      _periods = periods;
      _startValue = target?.startValue ?? 0;
      _distType = target?.distributionType ?? 'uniform';
      _startController.text = _startValue.toStringAsFixed(2);
      if (periods.isNotEmpty) {
        _distStartPeriodId = periods.first.id;
        _distEndPeriodId = periods.last.id;
      }
    });
  }

  void _applyUniform() {
    if (_activity == null || _activity!.isKpi || _periods.isEmpty) return;
    final ordered = [..._periods]
      ..sort((a, b) => a.monthNumber.compareTo(b.monthNumber));

    final startId = _distStartPeriodId ?? ordered.first.id;
    final endId = _distEndPeriodId ?? ordered.last.id;
    final startIdx = ordered.indexWhere((p) => p.id == startId);
    final endIdx = ordered.indexWhere((p) => p.id == endId);
    if (startIdx < 0 || endIdx < 0 || endIdx < startIdx) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Color(0xFFC0392B),
          content: Text('دوره‌ی شروع و پایان نامعتبر است.')));
      return;
    }

    final spanCount = endIdx - startIdx + 1;
    final remaining = 100 - _startValue;
    final perPeriod = remaining / spanCount;
    double cumulative = _startValue;

    for (int i = 0; i < ordered.length; i++) {
      final p = ordered[i];
      if (i < startIdx) {
        _periodControllers[p.id]?.text = '0.00';
      } else if (i <= endIdx) {
        cumulative += perPeriod;
        _periodControllers[p.id]?.text =
            cumulative.clamp(0, 100).toStringAsFixed(2);
      } else {
        _periodControllers[p.id]?.text = '100.00';
      }
    }
    setState(() {});
  }

  Future<void> _deleteTarget() async {
    if (_existingTargetId == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف تارگت'),
        content: Text(
            'آیا از حذف تارگت فعالیت «${_activity?.name ?? ""}» در این سال مطمئن هستید؟ این فعالیت دیگر در ثبت پیشرفت و گزارش‌ها نمایش داده نمی‌شود.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('انصراف')),
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
    await AuthManager.instance.repository.deleteTarget(_existingTargetId!);
    final ids = await AuthManager.instance.repository
        .activityIdsWithTargetInYear(_yearId!);
    if (!mounted) return;
    setState(() {
      _existingTargetId = null;
      _activity = null;
      _withTargetIds = ids;
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تارگت حذف شد')));
  }


  Future<void> _save() async {
    if (_activity == null || _yearId == null) return;
    final periodValues = <int, double>{};
    final activeValues = <int, bool>{};
    for (final p in _periods) {
      periodValues[p.id] =
          double.tryParse(_periodControllers[p.id]?.text ?? '0') ?? 0;
      activeValues[p.id] = _periodActive[p.id] ?? true;
    }

    if (!_activity!.isKpi) {
      double prev = _startValue;
      final ordered = [..._periods]
        ..sort((a, b) => a.monthNumber.compareTo(b.monthNumber));
      for (final p in ordered) {
        final v = periodValues[p.id] ?? 0;
        if (v > 0 && v < prev) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: const Color(0xFFC0392B),
              content: Text(
                  'خطا: مقدار ${p.monthName} (${v.toStringAsFixed(1)}٪) از ماه قبل (${prev.toStringAsFixed(1)}٪) کمتر است. در پروژه هر ماه باید ≥ ماه قبل باشد.')));
          return;
        }
        if (v > 0) prev = v;
      }
    }

    await AuthManager.instance.repository.saveTarget(
      activityId: _activity!.id,
      yearId: _yearId!,
      startValue: _activity!.isKpi ? 0 : _startValue,
      distributionType: _activity!.isKpi ? 'kpi' : _distType,
      periodValues: periodValues,
      activeValues: activeValues,
    );
    final ids = await AuthManager.instance.repository
        .activityIdsWithTargetInYear(_yearId!);
    if (!mounted) return;
    setState(() => _withTargetIds = ids);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تارگت ذخیره شد ✓')));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1A2238);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('مدیریت تارگت',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w500, color: textColor)),
          const SizedBox(height: 4),
          Text('هدف هر فعالیت را در طول سال تعریف کنید',
              style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : const Color(0xFF777777))),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    width: 340,
                    child: _buildSelectorPanel(isDark, textColor)),
                const SizedBox(width: 16),
                Expanded(child: _buildEditorPanel(isDark, textColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorPanel(bool isDark, Color textColor) {
    final list = _filteredActivities;
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
          SearchablePicker(
            labelText: 'سال',
            dense: true,
            selectedId: _yearId,
            options: _years
                .map((y) => SearchableOption(id: y.id, label: y.title))
                .toList(),
            onChanged: _onYearChanged,
          ),
          const SizedBox(height: 10),
          SearchablePicker(
            labelText: 'واحد (اختیاری برای فیلتر)',
            dense: true,
            selectedId: _unitId,
            options: _units
                .map((u) => SearchableOption(
                    id: u.id, label: _unitPath(u.id), sublabel: u.name))
                .toList(),
            onChanged: (v) => setState(() => _unitId = v),
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(
              labelText: 'جستجوی فعالیت',
              prefixIcon: Icon(Icons.search, size: 18),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
          if (_yearId != null)
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'all', label: Text('همه')),
                ButtonSegment(value: 'with', label: Text('تارگت‌دار')),
                ButtonSegment(value: 'without', label: Text('بدون تارگت')),
              ],
              selected: {_filterMode},
              onSelectionChanged: (s) =>
                  setState(() => _filterMode = s.first),
              style: const ButtonStyle(
                  visualDensity: VisualDensity.compact),
            ),
          const SizedBox(height: 10),
          Text('${list.length} فعالیت',
              style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : const Color(0xFF777777))),
          const SizedBox(height: 6),
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Text('فعالیتی نیست',
                        style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF777777))))
                : ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 6),
                    itemBuilder: (context, i) =>
                        _activityListItem(list[i], isDark, textColor),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _activityListItem(ActivityInfo a, bool isDark, Color textColor) {
    final isSelected = _activity?.id == a.id;
    final hasTarget = _withTargetIds.contains(a.id);
    final typeColor =
        a.isProject ? const Color(0xFF0277BD) : const Color(0xFF2E7D52);
    return InkWell(
      onTap: () => _selectActivity(a),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? const Color(0xFF3A4468)
                  : _primary.withOpacity(0.12))
              : (isDark ? const Color(0xFF2D3552) : const Color(0xFFF7F8FA)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected
                  ? _primary
                  : (isDark
                      ? const Color(0xFF3A4468)
                      : const Color(0xFFE0E0E0))),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.15),
                  shape: BoxShape.circle),
              child: Text(a.isProject ? 'P' : 'K',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: typeColor)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      a.activityNumber != null && a.activityNumber!.isNotEmpty
                          ? '${a.activityNumber} - ${a.name}'
                          : a.name,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: textColor)),
                  Text(_unitPath(a.unitId),
                      style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF999999))),
                ],
              ),
            ),
            if (_yearId != null)
              Icon(
                hasTarget ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 16,
                color: hasTarget
                    ? const Color(0xFF2E7D52)
                    : (isDark ? Colors.white38 : const Color(0xFFCCCCCC)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditorPanel(bool isDark, Color textColor) {
    if (_activity == null || _yearId == null || _periods.isEmpty) {
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
              'یک سال و سپس یک فعالیت از لیست انتخاب کنید',
              style: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xFF777777))),
        ),
      );
    }

    final isKpi = _activity!.isKpi;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: (isKpi
                              ? const Color(0xFF2E7D52)
                              : const Color(0xFF0277BD))
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(isKpi ? 'KPI' : 'پروژه',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isKpi
                              ? const Color(0xFF2E7D52)
                              : const Color(0xFF0277BD))),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_activity!.name,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: textColor)),
                      Text(_unitPath(_activity!.unitId),
                          style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? const Color(0xFFE8B339)
                                  : _primary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isKpi)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                    'این فعالیت از نوع KPI است. هدف هر دوره به‌طور خودکار ۱۰۰٪ همان دوره است.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF1B5E20))),
              )
            else ...[
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _startController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          labelText: 'نقطه‌ی شروع (۰ تا ۹۹.۹۹)',
                          border: OutlineInputBorder(),
                          isDense: true),
                      onChanged: (v) => _startValue = double.tryParse(v) ?? 0,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'uniform', label: Text('یکنواخت')),
                        ButtonSegment(value: 'manual', label: Text('دستی')),
                      ],
                      selected: {_distType},
                      onSelectionChanged: (s) =>
                          setState(() => _distType = s.first),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_distType == 'uniform')
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('از:',
                            style: TextStyle(
                                fontSize: 12, color: textColor)),
                        const SizedBox(width: 4),
                        DropdownButton<int>(
                          value: _distStartPeriodId,
                          items: _periods
                              .map((p) => DropdownMenuItem(
                                  value: p.id,
                                  child: Text(p.monthName,
                                      style:
                                          const TextStyle(fontSize: 13))))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _distStartPeriodId = v),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('تا:',
                            style: TextStyle(
                                fontSize: 12, color: textColor)),
                        const SizedBox(width: 4),
                        DropdownButton<int>(
                          value: _distEndPeriodId,
                          items: _periods
                              .map((p) => DropdownMenuItem(
                                  value: p.id,
                                  child: Text(p.monthName,
                                      style:
                                          const TextStyle(fontSize: 13))))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _distEndPeriodId = v),
                        ),
                      ],
                    ),
                    OutlinedButton.icon(
                      onPressed: _applyUniform,
                      icon: const Icon(Icons.auto_fix_high, size: 18),
                      label: const Text('توزیع خودکار یکنواخت'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? Colors.white : _primary,
                          side: BorderSide(
                              color: isDark
                                  ? Colors.white54
                                  : _primary.withOpacity(0.4))),
                    ),
                  ],
                ),
            ],
            const SizedBox(height: 16),
            Text(
                isKpi
                    ? 'هدف دوره‌ها (هر کدام ۱۰۰):'
                    : 'هدف تجمعی هر دوره (تا رسیدن به ۱۰۰):',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textColor)),
            if (isKpi)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                    'ماه‌هایی که این KPI در آن‌ها انجام نمی‌شود را غیرفعال کنید (مثل آبیاری در زمستان).',
                    style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF999999))),
              ),
            const SizedBox(height: 8),
            ..._periods.map((p) {
              final active = _periodActive[p.id] ?? true;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text('${p.monthName}:',
                          style: TextStyle(
                              fontSize: 14,
                              color: active
                                  ? textColor
                                  : (isDark
                                      ? Colors.white38
                                      : const Color(0xFFAAAAAA)))),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _periodControllers[p.id],
                        enabled: !isKpi && active,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            isDense: true,
                            suffixText: '٪',
                            filled: !active,
                            fillColor: isDark
                                ? const Color(0xFF2D3552)
                                : const Color(0xFFF0F0F0)),
                      ),
                    ),
                    if (isKpi) ...[
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: () {
                          setState(() =>
                              _periodActive[p.id] = !active);
                        },
                        icon: Icon(
                            active
                                ? Icons.toggle_on
                                : Icons.toggle_off,
                            size: 22,
                            color: active
                                ? const Color(0xFF2E7D52)
                                : const Color(0xFF999999)),
                        label: Text(active ? 'فعال' : 'غیرفعال',
                            style: TextStyle(
                                fontSize: 12,
                                color: active
                                    ? const Color(0xFF2E7D52)
                                    : const Color(0xFF999999))),
                        style: TextButton.styleFrom(
                            minimumSize: const Size(90, 36)),
                      ),
                    ],
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('ذخیره تارگت'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14)),
                ),
                if (_existingTargetId != null) ...[
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _deleteTarget,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('حذف تارگت'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFC0392B),
                        side: const BorderSide(color: Color(0xFFC0392B)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14)),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}