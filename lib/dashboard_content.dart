import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'auth_manager.dart';
import 'data_repository.dart';
import 'settings_manager.dart';
import 'season_themes.dart';
import 'searchable_picker.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  List<YearInfo> _years = [];
  List<PeriodInfo> _periods = [];
  int? _yearId;
  int? _periodId;
  DashboardStats? _stats;
  bool _loading = true;
  bool _loadingStats = false;
  int _dashboardIndex = 0;
  String _viewMode = 'unit';
  int? _filterUnitId;
  List<UnitInfo> _units = [];
  bool _sortDesc = true;
  bool _weighted = false;

  final List<String> _dashboardNames = [
    'نمای کلی',
    'وضعیت تأیید',
    'پیشرفت دربرابر هدف',
    'رتبه‌بندی واحدها',
  ];

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  bool get _isManager {
    final u = AuthManager.instance.currentUser;
    return (u?.isAdmin ?? false) || (u?.isAdmin2 ?? false);
  }

  @override
  void initState() {
    super.initState();
    _loadBase();
  }

  Future<void> _loadBase() async {
    final repo = AuthManager.instance.repository;
    final years = await repo.getAllYears();
    final openPeriods = await repo.getOpenPeriods();
    final units = await repo.getAccessibleUnits(
        AuthManager.instance.currentUser!.id);
    if (!mounted) return;

    int? presetYear;
    int? presetPeriod;
    if (openPeriods.isNotEmpty) {
      presetPeriod = openPeriods.first.id;
      presetYear = openPeriods.first.yearId;
    }

    setState(() {
      _years = years;
      _loading = false;
      _yearId = presetYear;
      _periodId = presetPeriod;
      _units = units;
    });

    if (presetYear != null) {
      final periods = await repo.getPeriodsForYear(presetYear);
      if (!mounted) return;
      setState(() => _periods = periods);
    }
    if (presetPeriod != null) await _loadStats();
  }

  Future<void> _onYearChanged(int? v) async {
    setState(() {
      _yearId = v;
      _periodId = null;
      _periods = [];
      _stats = null;
    });
    if (v != null) {
      final periods =
          await AuthManager.instance.repository.getPeriodsForYear(v);
      if (!mounted) return;
      setState(() => _periods = periods);
    }
  }

  Future<void> _onPeriodChanged(int? v) async {
    setState(() => _periodId = v);
    if (v != null) await _loadStats();
  }

  Future<void> _loadStats() async {
    if (_periodId == null) return;
    setState(() => _loadingStats = true);
    final userId = AuthManager.instance.currentUser!.id;
    final stats = await AuthManager.instance.repository.getDashboardStats(
      periodId: _periodId!,
      ownerUserId: _isManager ? null : userId,
      filterUnitId: _filterUnitId,
    );
    if (!mounted) return;
    setState(() {
      _stats = stats;
      _loadingStats = false;
    });
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
          Row(
            children: [
              Text('داشبورد',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: textColor)),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF252D45) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isDark
                          ? const Color(0xFF3A4468)
                          : const Color(0xFFE0E0E0)),
                ),
                child: DropdownButton<int>(
                  value: _dashboardIndex,
                  underline: const SizedBox.shrink(),
                  borderRadius: BorderRadius.circular(8),
                  items: List.generate(
                      _dashboardNames.length,
                      (i) => DropdownMenuItem(
                          value: i, child: Text(_dashboardNames[i]))),
                  onChanged: (v) => setState(() => _dashboardIndex = v ?? 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
              _isManager
                  ? 'نمای کلی همه‌ی واحدها'
                  : 'نمای فعالیت‌های شما',
              style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white60 : const Color(0xFF777777))),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 200,
                child: SearchablePicker(
                  labelText: 'سال',
                  dense: true,
                  selectedId: _yearId,
                  options: _years
                      .map((y) => SearchableOption(id: y.id, label: y.title))
                      .toList(),
                  onChanged: _onYearChanged,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 200,
                child: SearchablePicker(
                  labelText: 'دوره',
                  dense: true,
                  selectedId: _periodId,
                  options: _periods
                      .map((p) => SearchableOption(id: p.id, label: p.title))
                      .toList(),
                  onChanged: _onPeriodChanged,
                ),
              ),
            ],
          ),
          if (_dashboardIndex == 2 || _dashboardIndex == 3) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _modeChip('unit', 'واحد‌محور', isDark, textColor),
                _modeChip('activity', 'فعالیت‌محور', isDark, textColor),
                const SizedBox(width: 8),
                _toggleChip(
                    _weighted ? 'میانگین وزنی' : 'میانگین نمایی',
                    Icons.balance,
                    isDark,
                    textColor, () {
                  setState(() => _weighted = !_weighted);
                }),
                _toggleChip(
                    _sortDesc ? 'نزولی' : 'صعودی',
                    _sortDesc ? Icons.arrow_downward : Icons.arrow_upward,
                    isDark,
                    textColor, () {
                  setState(() => _sortDesc = !_sortDesc);
                }),
                if (_units.isNotEmpty)
                  SizedBox(
                    width: 220,
                    child: SearchablePicker(
                      labelText: 'فیلتر واحد (اختیاری)',
                      dense: true,
                      selectedId: _filterUnitId,
                      options: _units
                          .map((u) =>
                              SearchableOption(id: u.id, label: u.name))
                          .toList(),
                      onChanged: (v) async {
                        setState(() => _filterUnitId = v);
                        await _loadStats();
                      },
                    ),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          if (_periodId == null)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text('سال و دوره را انتخاب کنید',
                    style: TextStyle(
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF777777))),
              ),
            )
          else if (_loadingStats)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_stats != null) ...[
            _buildSummaryCard(isDark, textColor),
            const SizedBox(height: 20),
            _buildDashboard(isDark, textColor),
          ],
        ],
      ),
    );
  }


  Widget _buildSummaryCard(bool isDark, Color textColor) {
    final rows = _stats!.unitRows;
    double prog;
    double targ;
    if (rows.isEmpty) {
      prog = 0;
      targ = 0;
    } else if (_weighted) {
      prog = rows.map((r) => r.weightedProgress).reduce((a, b) => a + b) /
          rows.length;
      targ = rows.map((r) => r.weightedTarget).reduce((a, b) => a + b) /
          rows.length;
    } else {
      prog = rows.map((r) => r.avgProgress).reduce((a, b) => a + b) /
          rows.length;
      targ = rows.map((r) => r.avgTarget).reduce((a, b) => a + b) /
          rows.length;
    }
    final gap = prog - targ;
    final ahead = gap >= 0;
    final achievement = targ == 0 ? 0.0 : (prog / targ * 100);
    final color = ahead ? const Color(0xFF2E7D52) : const Color(0xFFC0392B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.12), color.withOpacity(0.04)],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
                color: color.withOpacity(0.18), shape: BoxShape.circle),
            child: Icon(
                ahead ? Icons.trending_up : Icons.trending_down,
                color: color,
                size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    ahead
                        ? 'شما از تارگت جلو هستید'
                        : 'شما از تارگت عقب هستید',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor)),
                const SizedBox(height: 4),
                Text(
                    'فاصله تا تارگت: ${ahead ? "+" : ""}${gap.toStringAsFixed(1)}٪  •  درصد دستیابی: ${achievement.toStringAsFixed(0)}٪',
                    style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF555555))),
                const SizedBox(height: 2),
                Text(
                    '(مبنا: ${_weighted ? "میانگین وزنی" : "میانگین نمایی"})',
                    style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF999999))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('پیشرفت واقعی',
                  style: TextStyle(
                      fontSize: 11,
                      color:
                          isDark ? Colors.white54 : const Color(0xFF999999))),
              Text('${prog.toStringAsFixed(1)}٪',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color)),
              Text('هدف: ${targ.toStringAsFixed(1)}٪',
                  style: TextStyle(
                      fontSize: 12,
                      color:
                          isDark ? Colors.white60 : const Color(0xFF777777))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(bool isDark, Color textColor) {
    switch (_dashboardIndex) {
      case 1:
        return _dashApproval(isDark, textColor);
      case 2:
        return _dashProgressVsTarget(isDark, textColor);
      case 3:
        return _dashRanking(isDark, textColor);
      default:
        return _dashOverview(isDark, textColor);
    }
  }

  // ===== داشبورد ۱: نمای کلی =====
  Widget _dashOverview(bool isDark, Color textColor) {
    final s = _stats!;
    final cards = [
      _CardData('کل فعالیت‌ها', s.totalActivities.toString(),
          Icons.list_alt, const Color(0xFF0277BD)),
      _CardData('ثبت‌نشده', s.notStartedCount.toString(),
          Icons.radio_button_unchecked, const Color(0xFF999999)),
      _CardData('پیش‌نویس', s.draftCount.toString(),
          Icons.edit_note, const Color(0xFFBA7517)),
      _CardData('در جریان تأیید', s.submittedCount.toString(),
          Icons.hourglass_top, const Color(0xFFE8951B)),
      _CardData('تأیید نهایی', s.finalCount.toString(),
          Icons.verified, const Color(0xFF2E7D52)),
      _CardData('میانگین پیشرفت',
          '${s.avgProgress.toStringAsFixed(1)}٪', Icons.trending_up,
          _primary),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: cards.map((c) => _card(c, isDark, textColor)).toList(),
        ),
        const SizedBox(height: 24),
        _panel(
            'پیشرفت هر واحد (میانگین)',
            isDark,
            textColor,
            Column(children: s.unitRows.map((r) => _bar(r, isDark, textColor)).toList())),
      ],
    );
  }

  // ===== داشبورد ۲: وضعیت تأیید =====
  Widget _dashApproval(bool isDark, Color textColor) {
    final s = _stats!;
    final segments = [
      _Seg('ثبت‌نشده', s.notStartedCount, const Color(0xFF999999)),
      _Seg('پیش‌نویس', s.draftCount, const Color(0xFFBA7517)),
      _Seg('در جریان', s.submittedCount, const Color(0xFFE8951B)),
      _Seg('نهایی', s.finalCount, const Color(0xFF2E7D52)),
    ];
    final total = segments.fold<int>(0, (sum, x) => sum + x.value);
    return _panel(
      'وضعیت تأیید فعالیت‌ها',
      isDark,
      textColor,
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: _DonutPainter(segments, total,
                  isDark ? const Color(0xFF1A2238) : const Color(0xFFEFF2F6)),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(total.toString(),
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    Text('فعالیت',
                        style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white60
                                : const Color(0xFF777777))),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: segments.map((seg) {
                final pct = total == 0
                    ? 0.0
                    : (seg.value / total * 100);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                              color: seg.color,
                              borderRadius: BorderRadius.circular(3))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(seg.label,
                              style: TextStyle(
                                  fontSize: 14, color: textColor))),
                      Text('${seg.value}  (${pct.toStringAsFixed(0)}٪)',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: textColor)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ===== داشبورد ۳: پیشرفت دربرابر هدف =====
  Widget _dashProgressVsTarget(bool isDark, Color textColor) {
    final List<_GenericRow> rows = _viewMode == 'activity'
        ? _stats!.activityRows
            .map((a) => _GenericRow(
                a.activityNumber != null && a.activityNumber!.isNotEmpty
                    ? '${a.activityNumber} - ${a.activityName}'
                    : a.activityName,
                a.progress,
                a.target,
                a.unitName))
            .toList()
        : _stats!.unitRows
            .map((r) => _GenericRow(
                r.unitName,
                _weighted ? r.weightedProgress : r.avgProgress,
                _weighted ? r.weightedTarget : r.avgTarget,
                null))
            .toList();
    rows.sort((a, b) {
      final ga = a.progress - a.target;
      final gb = b.progress - b.target;
      return _sortDesc ? gb.compareTo(ga) : ga.compareTo(gb);
    });
    return _panel(
      _viewMode == 'activity'
          ? 'پیشرفت دربرابر هدف (فعالیت‌محور)'
          : 'پیشرفت دربرابر هدف (واحد‌محور)',
      isDark,
      textColor,
      rows.isEmpty
          ? Text('داده‌ای نیست',
              style: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xFF777777)))
          : Column(
              children: rows.map((r) {
                final gap = r.progress - r.target;
                final ahead = gap >= 0;
                final achievement =
                    r.target == 0 ? 0.0 : (r.progress / r.target * 100);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r.name,
                                  style: TextStyle(
                                      fontSize: 13, color: textColor)),
                              if (r.subtitle != null)
                                Text(r.subtitle!,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: isDark
                                            ? Colors.white54
                                            : const Color(0xFF999999))),
                            ],
                          )),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                                color: (ahead
                                        ? const Color(0xFF2E7D52)
                                        : const Color(0xFFC0392B))
                                    .withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                                '${ahead ? "+" : ""}${gap.toStringAsFixed(1)}٪  (دستیابی ${achievement.toStringAsFixed(0)}٪)',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: ahead
                                        ? const Color(0xFF2E7D52)
                                        : const Color(0xFFC0392B))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          SizedBox(
                              width: 50,
                              child: Text('واقعی',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: isDark
                                          ? Colors.white60
                                          : const Color(0xFF777777)))),
                          Expanded(
                              child: _miniBar(r.progress, _primary, isDark)),
                          const SizedBox(width: 8),
                          SizedBox(
                              width: 44,
                              child: Text('${r.progress.toStringAsFixed(0)}٪',
                                  style: TextStyle(
                                      fontSize: 11, color: textColor))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SizedBox(
                              width: 50,
                              child: Text('هدف',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: isDark
                                          ? Colors.white60
                                          : const Color(0xFF777777)))),
                          Expanded(
                              child: _miniBar(r.target,
                                  const Color(0xFF999999), isDark)),
                          const SizedBox(width: 8),
                          SizedBox(
                              width: 44,
                              child: Text('${r.target.toStringAsFixed(0)}٪',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: isDark
                                          ? Colors.white60
                                          : const Color(0xFF777777)))),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  // ===== داشبورد ۴: رتبه‌بندی =====
  Widget _dashRanking(bool isDark, Color textColor) {
    final List<_GenericRow> rows = _viewMode == 'activity'
        ? (_stats!.activityRows
            .map((a) => _GenericRow(
                a.activityNumber != null && a.activityNumber!.isNotEmpty
                    ? '${a.activityNumber} - ${a.activityName}'
                    : a.activityName,
                a.progress,
                a.target,
                a.unitName))
            .toList())
        : (_stats!.unitRows
            .map((r) => _GenericRow(
                r.unitName,
                _weighted ? r.weightedProgress : r.avgProgress,
                _weighted ? r.weightedTarget : r.avgTarget,
                null))
            .toList());
    rows.sort((a, b) {
      final ga = a.progress - a.target;
      final gb = b.progress - b.target;
      return _sortDesc ? gb.compareTo(ga) : ga.compareTo(gb);
    });
    return _panel(
      _viewMode == 'activity'
          ? 'رتبه‌بندی فعالیت‌ها'
          : 'رتبه‌بندی واحدها',
      isDark,
      textColor,
      rows.isEmpty
          ? Text('داده‌ای نیست',
              style: TextStyle(
                  color: isDark ? Colors.white60 : const Color(0xFF777777)))
          : Column(
              children: List.generate(rows.length, (i) {
                final r = rows[i];
                final isTop = i == 0;
                final isBottom = i == rows.length - 1 && rows.length > 1;
                Color rankColor;
                if (isTop) {
                  rankColor = const Color(0xFF2E7D52);
                } else if (isBottom) {
                  rankColor = const Color(0xFFC0392B);
                } else {
                  rankColor = _primary;
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: rankColor.withOpacity(0.15),
                            shape: BoxShape.circle),
                        child: Text('${i + 1}',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: rankColor)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isTop
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: textColor)),
                            if (r.subtitle != null)
                              Text(r.subtitle!,
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: isDark
                                          ? Colors.white54
                                          : const Color(0xFF999999))),
                          ],
                        ),
                      ),
                      if (isTop)
                        const Icon(Icons.emoji_events,
                            size: 16, color: Color(0xFFE8B339)),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 120,
                        child: _miniBar(r.progress, rankColor, isDark),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                          width: 44,
                          child: Text('${r.progress.toStringAsFixed(1)}٪',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: textColor))),
                    ],
                  ),
                );
              }),
            ),
    );
  }

  // ===== اجزای مشترک =====
  Widget _toggleChip(String label, IconData icon, bool isDark,
      Color textColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF252D45) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isDark
                  ? const Color(0xFF3A4468)
                  : const Color(0xFFD0D0D0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: _primary),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(fontSize: 12, color: textColor)),
          ],
        ),
      ),
    );
  }

  Widget _modeChip(String mode, String label, bool isDark, Color textColor) {
    final selected = _viewMode == mode;
    return InkWell(
      onTap: () => setState(() => _viewMode = mode),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? _primary
              : (isDark ? const Color(0xFF252D45) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected
                  ? _primary
                  : (isDark
                      ? const Color(0xFF3A4468)
                      : const Color(0xFFE0E0E0))),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                color: selected
                    ? Colors.white
                    : (isDark ? Colors.white70 : textColor))),
      ),
    );
  }

  Widget _miniBar(double value, Color color, bool isDark) {
    return Stack(
      children: [
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2238) : const Color(0xFFEFF2F6),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        FractionallySizedBox(
          widthFactor: (value / 100).clamp(0.0, 1.0),
          child: Container(
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bar(UnitProgressRow r, bool isDark, Color textColor) {
    final pct = (r.avgProgress / 100).clamp(0.0, 1.0);
    final targetPct = (r.avgTarget / 100).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(r.unitName,
                      style: TextStyle(fontSize: 13, color: textColor))),
              Text(
                  '${r.avgProgress.toStringAsFixed(1)}٪ / هدف ${r.avgTarget.toStringAsFixed(1)}٪',
                  style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? Colors.white60
                          : const Color(0xFF777777))),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 14,
                decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1A2238)
                        : const Color(0xFFEFF2F6),
                    borderRadius: BorderRadius.circular(7)),
              ),
              FractionallySizedBox(
                widthFactor: targetPct,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                      color: _primary.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(7)),
                ),
              ),
              FractionallySizedBox(
                widthFactor: pct,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                      color: _primary,
                      borderRadius: BorderRadius.circular(7)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _panel(String title, bool isDark, Color textColor, Widget child) {
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
          Text(title,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _card(_CardData c, bool isDark, Color textColor) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: c.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(c.icon, color: c.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.value,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                Text(c.label,
                    style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? Colors.white60
                            : const Color(0xFF777777))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  _CardData(this.label, this.value, this.icon, this.color);
}

class _GenericRow {
  final String name;
  final double progress;
  final double target;
  final String? subtitle;
  _GenericRow(this.name, this.progress, this.target, this.subtitle);
}

class _Seg {
  final String label;
  final int value;
  final Color color;
  _Seg(this.label, this.value, this.color);
}

class _DonutPainter extends CustomPainter {
  final List<_Seg> segments;
  final int total;
  final Color bgColor;
  _DonutPainter(this.segments, this.total, this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final strokeWidth = radius * 0.32;
    final rect = Rect.fromCircle(
        center: center, radius: radius - strokeWidth / 2);

    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    if (total == 0) return;
    double start = -math.pi / 2;
    for (final seg in segments) {
      if (seg.value == 0) continue;
      final sweep = (seg.value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.segments != segments || old.total != total;
}