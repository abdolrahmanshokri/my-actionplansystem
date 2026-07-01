import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'auth_manager.dart';
import 'data_repository.dart';
import 'settings_manager.dart';
import 'season_themes.dart';

class ProgressEntryContent extends StatefulWidget {
  const ProgressEntryContent({super.key});

  @override
  State<ProgressEntryContent> createState() => _ProgressEntryContentState();
}

class _RowData {
  final ActivityInfo activity;
  final double? targetThis;
  final double? prevEntered;
  final ProgressEntryInfo? thisEntry;
  final TextEditingController controller;
  final TextEditingController noteController;
  final bool isActive;
  _RowData({
    required this.activity,
    this.targetThis,
    this.prevEntered,
    this.thisEntry,
    required this.controller,
    required this.noteController,
    this.isActive = true,
  });
}

class _ProgressEntryContentState extends State<ProgressEntryContent>
    with SingleTickerProviderStateMixin {
  List<PeriodInfo> _openPeriods = [];
  List<UnitInfo> _units = [];
  PeriodInfo? _period;
  List<_RowData> _rows = [];
  List<ApprovalQueueItem> _myTurnItems = [];
  List<ApprovalQueueItem> _allTurnItems = [];
  bool _showAllTurn = false;
  List<ApprovalQueueItem> _unitItems = [];
  bool _showAllUnit = false;
  bool _showInactiveUnit = false;
  int _inactiveUnitCount = 0;
  bool _showInactiveTurn = false;
  int _inactiveTurnCount = 0;
  bool _showAllMine = false;
  bool _showInactive = false;
  bool _showNoTarget = false;
  int _inactiveCount = 0;
  int _noTargetCount = 0;
  String _searchMy = '';
  String _searchTurn = '';
  String _searchUnit = '';
  bool _loading = true;
  bool _loadingRows = false;
  bool _loadingQueue = false;
  TabController? _tabController;

  Color get _primary => seasonColorsOf(SettingsManager.instance.season).primary;

  bool get _canReopen {
    final u = AuthManager.instance.currentUser;
    return (u?.isAdmin ?? false) || (u?.isAdmin2 ?? false);
  }

  List<ApprovalQueueItem> _filterQueue(
      List<ApprovalQueueItem> items, String q) {
    if (q.trim().isEmpty) return items;
    final query = q.trim();
    return items
        .where((it) =>
            it.activityName.contains(query) ||
            (it.activityNumber ?? '').contains(query) ||
            _unitPath(it.unitId).contains(query))
        .toList();
  }

  Widget _searchBox(String hint, ValueChanged<String> onChanged, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search, size: 18),
          border: const OutlineInputBorder(),
          isDense: true,
          filled: true,
          fillColor: isDark ? const Color(0xFF2D3552) : Colors.white,
        ),
        onChanged: onChanged,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBase();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadBase() async {
    final repo = AuthManager.instance.repository;
    final open = await repo.getOpenPeriods();
    final units = await repo.getAllUnits();
    if (!mounted) return;
    setState(() {
      _openPeriods = open;
      _units = units;
      _loading = false;
      if (open.length == 1) {
        _period = open.first;
      }
    });
    if (_period != null) await _loadRows();
    if (_period != null) await _loadQueues();
    _applyTabPriority();
  }

  Future<void> _loadQueues() async {
    if (_period == null) return;
    setState(() => _loadingQueue = true);
    final repo = AuthManager.instance.repository;
    final userId = AuthManager.instance.currentUser!.id;

    // تب «در انتظار تأیید من»
    final myTurn = await repo.getApprovalQueueForPeriod(_period!.id, userId,
        onlyMyTurn: true, includeInactive: _showInactiveTurn);
    final myTurnInactive = await repo.getApprovalQueueForPeriod(
        _period!.id, userId,
        onlyMyTurn: true, includeInactive: true);
    final inactiveTurn = myTurnInactive.length -
        (await repo.getApprovalQueueForPeriod(_period!.id, userId,
                onlyMyTurn: true, includeInactive: false))
            .length;

    // تب «فعالیت‌های واحد»
    final unitAll = await repo.getApprovalQueueForPeriod(_period!.id, userId,
        onlyMyTurn: false,
        showAll: _showAllUnit && _canReopen,
        includeInactive: _showInactiveUnit);
    final unitActiveOnly = await repo.getApprovalQueueForPeriod(
        _period!.id, userId,
        onlyMyTurn: false,
        showAll: _showAllUnit && _canReopen,
        includeInactive: false);
    final unitWithInactive = await repo.getApprovalQueueForPeriod(
        _period!.id, userId,
        onlyMyTurn: false,
        showAll: _showAllUnit && _canReopen,
        includeInactive: true);
    final inactiveUnit = unitWithInactive.length - unitActiveOnly.length;

    List<ApprovalQueueItem> allTurn = [];
    if (_canReopen && _showAllTurn) {
      final everything = await repo.getApprovalQueueForPeriod(
          _period!.id, userId,
          onlyMyTurn: false, showAll: true, includeInactive: _showInactiveTurn);
      allTurn =
          everything.where((it) => it.status == 'submitted').toList();
    }
    if (!mounted) return;
    setState(() {
      _myTurnItems = myTurn;
      _unitItems = unitAll;
      _allTurnItems = allTurn;
      _inactiveTurnCount = inactiveTurn < 0 ? 0 : inactiveTurn;
      _inactiveUnitCount = inactiveUnit < 0 ? 0 : inactiveUnit;
      _loadingQueue = false;
    });
  }

  void _applyTabPriority() {
    final myPending = _rows.isNotEmpty &&
        _rows.any((r) => !(r.thisEntry?.isLocked ?? false));
    int target;
    if (myPending) {
      target = 0;
    } else if (_myTurnItems.isNotEmpty) {
      target = 1;
    } else if (_unitItems.isNotEmpty) {
      target = 2;
    } else {
      target = 0;
    }
    _tabController?.animateTo(target);
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

  Future<void> _loadRows() async {
    if (_period == null) return;
    setState(() => _loadingRows = true);
    final repo = AuthManager.instance.repository;
    final userId = AuthManager.instance.currentUser!.id;

    final acts = (_showAllMine && _canReopen)
        ? await repo.getAllActivities()
        : await repo.getActivitiesOwnedBy(userId);
    final prevPid = await repo.previousPeriodId(_period!.id);
    final withTarget =
        await repo.activityIdsWithTargetInYear(_period!.yearId);

    final rows = <_RowData>[];
    int inactiveCount = 0;
    int noTargetCount = 0;
    for (final a in acts) {
      final hasTarget = withTarget.contains(a.id);
      if (!hasTarget) {
        noTargetCount++;
        if (!_showNoTarget) continue;
      }
      final active = hasTarget
          ? await repo.isActivityActiveInPeriod(a.id, _period!.id, a.isKpi)
          : false;
      if (hasTarget && !active) inactiveCount++;
      if (hasTarget && !active && !_showInactive) continue;

      final target = await repo.getTarget(a.id, _period!.yearId);
      double? targetThis;
      if (target != null) {
        final tThis = target.periods.where((p) => p.periodId == _period!.id);
        targetThis = tThis.isEmpty ? null : tThis.first.targetValue;
      }

      final progressMap =
          await repo.getProgressForActivityYear(a.id, _period!.yearId);
      final thisEntry = progressMap[_period!.id];
      final prevEntered =
          prevPid != null ? progressMap[prevPid]?.progressValue : null;

      rows.add(_RowData(
        activity: a,
        targetThis: targetThis,
        prevEntered: prevEntered,
        thisEntry: thisEntry,
        controller: TextEditingController(
            text: thisEntry != null
                ? thisEntry.progressValue.toStringAsFixed(1)
                : ''),
        noteController:
            TextEditingController(text: thisEntry?.note ?? ''),
        isActive: active,
      ));
    }
    _inactiveCount = inactiveCount;
    _noTargetCount = noTargetCount;

    if (!mounted) return;
    setState(() {
      _rows = rows;
      _loadingRows = false;
    });
  }

  Future<void> _saveAll({required bool submit}) async {
    if (_period == null) return;
    final repo = AuthManager.instance.repository;
    final userId = AuthManager.instance.currentUser!.id;

    final user = AuthManager.instance.currentUser!;
    for (final r in _rows) {
      if ((r.thisEntry?.isLocked ?? false) || !r.isActive) continue;
      final text = r.controller.text.trim();
      if (text.isEmpty) continue;
      final value = double.tryParse(text) ?? 0;
      final noteText = r.noteController.text.trim();
      await repo.saveProgress(
        activityId: r.activity.id,
        periodId: _period!.id,
        progressValue: value,
        note: noteText.isEmpty ? null : noteText,
        enteredByUserId: userId,
        userName: user.fullName,
      );
    }

    if (submit) {
      for (final r in _rows) {
        if ((r.thisEntry?.isLocked ?? false) || !r.isActive) continue;
        final text = r.controller.text.trim();
        if (text.isEmpty) continue;
        await repo.submitProgress(r.activity.id, _period!.id,
            userId: user.id, userName: user.fullName);
      }
    }

    await _loadRows();
    await _loadQueues();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(submit
            ? 'پیشرفت ثبت و برای تأیید ارسال شد ✓'
            : 'پیش‌نویس ذخیره شد ✓')));
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
          Text('ثبت پیشرفت اکشن‌پلان',
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w500, color: textColor)),
          const SizedBox(height: 12),
          if (_openPeriods.isEmpty)
            _noOpenPeriodBox(isDark, textColor)
          else ...[
            _periodSelector(isDark, textColor),
            const SizedBox(height: 12),
            TabBar(
              controller: _tabController,
              labelColor: isDark ? const Color(0xFFE8B339) : _primary,
              unselectedLabelColor:
                  isDark ? Colors.white60 : const Color(0xFF777777),
              indicatorColor: isDark ? const Color(0xFFE8B339) : _primary,
              tabs: [
                Tab(text: 'فعالیت‌های من (${_rows.length})'),
                Tab(text: 'در انتظار تأیید من (${_myTurnItems.length})'),
                Tab(text: 'فعالیت‌های واحد (${_unitItems.length})'),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMyActivitiesTab(isDark, textColor),
                  _buildMyTurnTab(isDark, textColor),
                  _buildUnitTab(isDark, textColor),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _noOpenPeriodBox(bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Color(0xFFBA7517)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
                'در حال حاضر هیچ دوره‌ای باز نیست. تا زمانی که مدیر دوره‌ای را باز نکند، امکان ثبت پیشرفت نیست.',
                style: TextStyle(fontSize: 14, color: Color(0xFF8A6D1B))),
          ),
        ],
      ),
    );
  }

  Widget _periodSelector(bool isDark, Color textColor) {
    if (_openPeriods.length == 1) {
      return Row(
        children: [
          Icon(Icons.event_available, size: 18, color: _primary),
          const SizedBox(width: 8),
          Text('دوره‌ی باز: ${_period!.title}',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor)),
        ],
      );
    }

    return Row(
      children: [
        Text('دوره‌ی باز: ',
            style: TextStyle(fontSize: 14, color: textColor)),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: _period?.id,
          hint: const Text('انتخاب دوره'),
          items: _openPeriods
              .map((p) =>
                  DropdownMenuItem(value: p.id, child: Text(p.title)))
              .toList(),
          onChanged: (v) async {
            setState(() => _period =
                _openPeriods.firstWhere((p) => p.id == v));
            await _loadRows();
            await _loadQueues();
            _applyTabPriority();
          },
        ),
      ],
    );
  }

  Widget _buildMyActivitiesTab(bool isDark, Color textColor) {
    if (_loadingRows) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_period == null) {
      return Center(
        child: Text('یک دوره انتخاب کنید',
            style: TextStyle(
                color: isDark ? Colors.white60 : const Color(0xFF777777))),
      );
    }
    if (_rows.isEmpty) {
      return Center(
        child: Text('فعالیتی به شما محول نشده است',
            style: TextStyle(
                color: isDark ? Colors.white60 : const Color(0xFF777777))),
      );
    }

    final anyEditable = _rows.any((r) => !(r.thisEntry?.isLocked ?? false));
    final allLocked = _rows.isNotEmpty && !anyEditable;

    final adminToggle = Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (_canReopen)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _showAllMine,
                onChanged: (v) async {
                  setState(() => _showAllMine = v ?? false);
                  await _loadRows();
                },
              ),
              Text('نمایش و ثبت برای همه‌ی فعالیت‌ها (فقط مدیران)',
                  style: TextStyle(fontSize: 12, color: textColor)),
              const SizedBox(width: 16),
            ],
          ),
        if (AuthManager.instance.canSeeInactiveToggle &&
            (_inactiveCount > 0 || _showInactive))
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _showInactive,
                onChanged: (v) async {
                  setState(() => _showInactive = v ?? false);
                  await _loadRows();
                },
              ),
              Text('نمایش فعالیت‌های غیرفعال ($_inactiveCount)',
                  style: TextStyle(fontSize: 12, color: textColor)),
              const SizedBox(width: 16),
            ],
          ),
        if (AuthManager.instance.canSeeNoTargetToggle &&
            (_noTargetCount > 0 || _showNoTarget))
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: _showNoTarget,
                onChanged: (v) async {
                  setState(() => _showNoTarget = v ?? false);
                  await _loadRows();
                },
              ),
              Text('نمایش فعالیت‌های بدون تارگت ($_noTargetCount)',
                  style: TextStyle(fontSize: 12, color: textColor)),
            ],
          ),
      ],
    );

    if (_rows.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          adminToggle,
          Expanded(
            child: Center(
              child: Text(
                  _showAllMine
                      ? 'فعالیتی در سیستم نیست'
                      : 'فعالیتی به شما محول نشده است',
                  style: TextStyle(
                      color: isDark
                          ? Colors.white60
                          : const Color(0xFF777777))),
            ),
          ),
        ],
      );
    }

    final filteredRows = _searchMy.trim().isEmpty
        ? _rows
        : _rows.where((r) {
            final q = _searchMy.trim();
            return r.activity.name.contains(q) ||
                (r.activity.activityNumber ?? '').contains(q) ||
                _unitPath(r.activity.unitId).contains(q);
          }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        adminToggle,
        _searchBox('جستجوی نام، شماره یا واحد...',
            (v) => setState(() => _searchMy = v), isDark),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2D3552) : const Color(0xFFEFF2F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(flex: 4, child: _hCell('فعالیت', textColor)),
              Expanded(flex: 1, child: _hCell('وزن', textColor)),
              Expanded(flex: 2, child: _hCell('تارگت این ماه', textColor)),
              Expanded(flex: 2, child: _hCell('ثبت ماه قبل', textColor)),
              Expanded(flex: 3, child: _hCell('درصد این ماه', textColor)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.separated(
            itemCount: filteredRows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, i) =>
                _rowWidget(filteredRows[i], isDark, textColor),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: !anyEditable ? null : () => _saveAll(submit: false),
              icon: const Icon(Icons.save, size: 18),
              label: const Text('ذخیره پیش‌نویس'),
              style: OutlinedButton.styleFrom(
                  foregroundColor: isDark ? Colors.white : _primary,
                  side: BorderSide(
                      color: isDark
                          ? Colors.white54
                          : _primary.withOpacity(0.4))),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: !anyEditable ? null : () => _saveAll(submit: true),
              icon: const Icon(Icons.send, size: 18),
              label: const Text('ثبت و ارسال برای تأیید'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _primary, foregroundColor: Colors.white),
            ),
            const SizedBox(width: 12),
            if (allLocked)
              const Text('همه‌ی فعالیت‌ها ارسال شده‌اند',
                  style: TextStyle(
                      fontSize: 12, color: Color(0xFFBA7517))),
          ],
        ),
      ],
    );
  }

  Widget _buildMyTurnTab(bool isDark, Color textColor) {
    if (_loadingQueue) {
      return const Center(child: CircularProgressIndicator());
    }
    final baseItems = _showAllTurn ? _allTurnItems : _myTurnItems;
    final items = _filterQueue(baseItems, _searchTurn);
    return Column(
      children: [
        if (_period != null &&
            (_inactiveTurnCount > 0 || _showInactiveTurn))
          Row(
            children: [
              Checkbox(
                value: _showInactiveTurn,
                onChanged: (v) {
                  setState(() => _showInactiveTurn = v ?? false);
                  _loadQueues();
                },
              ),
              Expanded(
                child: Text(
                    'نمایش غیرفعال‌های این دوره'
                    '${_inactiveTurnCount > 0 ? ' ($_inactiveTurnCount)' : ''}',
                    style: TextStyle(fontSize: 12, color: textColor)),
              ),
            ],
          ),
        if (_canReopen)
          Row(
            children: [
              Checkbox(
                value: _showAllTurn,
                onChanged: (v) async {
                  setState(() => _showAllTurn = v ?? false);
                  await _loadQueues();
                },
              ),
              Expanded(
                child: Text(
                    'نمایش و تأیید همه‌ی موارد در جریان (مدیران)',
                    style: TextStyle(fontSize: 12, color: textColor)),
              ),
            ],
          ),
        if (_searchTurn.trim().isNotEmpty || baseItems.isNotEmpty)
          _searchBox('جستجوی نام، شماره یا واحد...',
              (v) => setState(() => _searchTurn = v), isDark),
        if (items.isEmpty)
          Expanded(
            child: Center(
              child: Text('چیزی در انتظار تأیید شما نیست',
                  style: TextStyle(
                      color:
                          isDark ? Colors.white60 : const Color(0xFF777777))),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) =>
                  _queueCard(items[i], isDark, textColor, actionable: true),
            ),
          ),
      ],
    );
  }

  Widget _buildUnitTab(bool isDark, Color textColor) {
    if (_loadingQueue) {
      return const Center(child: CircularProgressIndicator());
    }
    final items = _filterQueue(_unitItems, _searchUnit);
    return Column(
      children: [
        if (_period != null &&
            (_inactiveUnitCount > 0 || _showInactiveUnit))
          Row(
            children: [
              Checkbox(
                value: _showInactiveUnit,
                onChanged: (v) {
                  setState(() => _showInactiveUnit = v ?? false);
                  _loadQueues();
                },
              ),
              Expanded(
                child: Text(
                    'نمایش غیرفعال‌های این دوره'
                    '${_inactiveUnitCount > 0 ? ' ($_inactiveUnitCount)' : ''}',
                    style: TextStyle(fontSize: 12, color: textColor)),
              ),
            ],
          ),
        if (_canReopen)
          Row(
            children: [
              Checkbox(
                value: _showAllUnit,
                onChanged: (v) {
                  setState(() => _showAllUnit = v ?? false);
                  _loadQueues();
                },
              ),
              Expanded(
                child: Text(
                    'نمایش همه‌ی فعالیت‌های سیستم (فقط برای مدیران)',
                    style: TextStyle(fontSize: 12, color: textColor)),
              ),
            ],
          ),
        if (_searchUnit.trim().isNotEmpty || _unitItems.isNotEmpty)
          _searchBox('جستجوی نام، شماره یا واحد...',
              (v) => setState(() => _searchUnit = v), isDark),
        if (items.isEmpty)
          Expanded(
            child: Center(
              child: Text('فعالیتی برای نمایش نیست',
                  style: TextStyle(
                      color:
                          isDark ? Colors.white60 : const Color(0xFF777777))),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) =>
                  _queueCard(items[i], isDark, textColor, actionable: false),
            ),
          ),
      ],
    );
  }

  Widget _queueCard(ApprovalQueueItem item, bool isDark, Color textColor,
      {required bool actionable}) {
    final isFinal = item.status == 'final';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(10),
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
                    Text(
                        item.activityNumber != null &&
                                item.activityNumber!.isNotEmpty
                            ? '${item.activityNumber} - ${item.activityName}'
                            : item.activityName,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                    Text(_unitPath(item.unitId),
                        style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? Colors.white54
                                : const Color(0xFF999999))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('درصد: ${item.progressValue.toStringAsFixed(1)}٪',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: textColor)),
                  Text(
                      'تارگت: ${item.targetThis != null ? "${item.targetThis!.toStringAsFixed(1)}٪" : "—"}  •  وزن: ${item.weight.toStringAsFixed(1)}',
                      style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? Colors.white54
                              : const Color(0xFF999999))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (isFinal)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6)),
                  child: const Text('تأیید نهایی ✓',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFF1B5E20))),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                      'در دست بررسی: ${item.currentHolderName ?? "—"}',
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFFBA7517))),
                ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showHistory(item),
                icon: const Icon(Icons.history, size: 16),
                label: const Text('گردش کار',
                    style: TextStyle(fontSize: 12)),
              ),
              if (actionable &&
                  (item.isMyTurn || (_showAllTurn && _canReopen)) &&
                  !isFinal) ...[
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showApproveDialog(item),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('بررسی و تأیید'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      visualDensity: VisualDensity.compact),
                ),
              ],
              if (isFinal && _canReopen) ...[
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _showReopenDialog(item),
                  icon: const Icon(Icons.lock_open, size: 16),
                  label: const Text('بازگرداندن'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFC0392B),
                      side: const BorderSide(color: Color(0xFFC0392B)),
                      visualDensity: VisualDensity.compact),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showApproveDialog(ApprovalQueueItem item) async {
    final controller = TextEditingController(
        text: item.progressValue.toStringAsFixed(1));
    final noteController = TextEditingController();
    final isFirstStep = item.currentStepIndex <= 0;

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('بررسی فعالیت'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.activityName,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                  'تارگت این ماه: ${item.targetThis != null ? "${item.targetThis!.toStringAsFixed(1)}٪" : "—"}',
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF777777))),
              const SizedBox(height: 12),
              const Text('می‌توانید عدد را تغییر دهید و سپس تأیید کنید:',
                  style: TextStyle(fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'درصد پیشرفت',
                    border: OutlineInputBorder(),
                    suffixText: '٪',
                    isDense: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                    labelText: 'توضیح / دلیل (اختیاری)',
                    border: OutlineInputBorder(),
                    isDense: true),
              ),
            ],
          ),
        ),
        actionsOverflowButtonSpacing: 8,
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop('cancel'),
              child: const Text('لغو')),
          TextButton.icon(
            onPressed: () => Navigator.of(ctx).pop('reject_owner'),
            icon: const Icon(Icons.keyboard_double_arrow_right, size: 16),
            label: const Text('برگشت به مسئول'),
            style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFC0392B)),
          ),
          if (!isFirstStep)
            TextButton.icon(
              onPressed: () => Navigator.of(ctx).pop('reject_back'),
              icon: const Icon(Icons.keyboard_arrow_right, size: 16),
              label: const Text('یک مرحله عقب'),
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFBA7517)),
            ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop('approve'),
            child: const Text('تأیید'),
          ),
        ],
      ),
    );

    if (result == null || result == 'cancel') return;

    final user = AuthManager.instance.currentUser!;
    final repo = AuthManager.instance.repository;
    final note =
        noteController.text.trim().isEmpty ? null : noteController.text.trim();

    if (result == 'approve') {
      final newValue =
          double.tryParse(controller.text.trim()) ?? item.progressValue;
      await repo.approveOrModify(
        progressEntryId: item.progressEntryId,
        stepIndex: item.currentStepIndex,
        newValue: newValue,
        userId: user.id,
        userName: user.fullName,
        note: note,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تأیید شد ✓')));
    } else if (result == 'reject_owner') {
      await repo.rejectProgress(
        progressEntryId: item.progressEntryId,
        stepIndex: item.currentStepIndex,
        toOwner: true,
        userId: user.id,
        userName: user.fullName,
        note: note,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('به مسئول پروژه برگشت داده شد')));
    } else if (result == 'reject_back') {
      await repo.rejectProgress(
        progressEntryId: item.progressEntryId,
        stepIndex: item.currentStepIndex,
        toOwner: false,
        userId: user.id,
        userName: user.fullName,
        note: note,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('به یک مرحله قبل برگشت داده شد')));
    }
    await _loadQueues();
  }

  Future<void> _showReopenDialog(ApprovalQueueItem item) async {
    final noteController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('بازگرداندن تأیید نهایی'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.activityName,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            const Text(
                'این فعالیت به آخرین مرحله‌ی زنجیره بازمی‌گردد تا دوباره بررسی شود.',
                style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                  labelText: 'دلیل (اختیاری)',
                  border: OutlineInputBorder(),
                  isDense: true),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('لغو')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC0392B),
                foregroundColor: Colors.white),
            child: const Text('بازگرداندن'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final user = AuthManager.instance.currentUser!;
    await AuthManager.instance.repository.reopenFinalProgress(
      progressEntryId: item.progressEntryId,
      userId: user.id,
      userName: user.fullName,
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
    );
    await _loadQueues();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('به حالت در حال بررسی بازگردانده شد')));
  }


  Future<void> _showHistory(ApprovalQueueItem item) async {
    final history = await AuthManager.instance.repository
        .getProgressHistory(item.progressEntryId);
    if (!mounted) return;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('گردش کار'),
        content: SizedBox(
          width: 400,
          child: history.isEmpty
              ? const Text('هنوز اقدامی ثبت نشده است')
              : SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: history.map((h) => _historyRow(h)).toList(),
                  ),
                ),
        ),
        actions: [
          if (history.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.copy, size: 18),
              label: const Text('کپی'),
              onPressed: () {
                final text = history
                    .map((h) =>
                        '${_historyLabel(h)} — ${_historyDateStr(h)}')
                    .join('\n');
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('گردش کار کپی شد'),
                    duration: Duration(seconds: 2)));
              },
            ),
          if (history.isNotEmpty)
            TextButton.icon(
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text('PDF'),
              onPressed: () => _exportHistoryPdf(item, history),
            ),
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('بستن')),
        ],
      ),
    );
  }

  String _historyLabel(ProgressHistoryItem h) {
    final name = h.userName ?? "کاربر";
    final newStr = h.newValue?.toStringAsFixed(1) ?? "-";
    if (h.action == 'modify') {
      // اگر مقدار قبلی نداریم یا صفر بوده → ثبت اولیه
      final hasOld = h.oldValue != null && h.oldValue! > 0;
      if (!hasOld) {
        return '$name مقدار اولیه را ثبت کرد: $newStr';
      }
      final oldStr = h.oldValue!.toStringAsFixed(1);
      final up = (h.newValue ?? 0) >= h.oldValue!;
      return '$name مقدار را ${up ? "افزایش" : "کاهش"} داد: $oldStr ← $newStr';
    } else if (h.action == 'approve') {
      return '$name تأیید کرد';
    } else if (h.action == 'final') {
      return 'تأیید نهایی توسط $name';
    } else if (h.action == 'submit') {
      return '${h.userName ?? "مسئول"} ثبت و ارسال کرد';
    } else if (h.action == 'reject_owner') {
      return '$name به مسئول پروژه برگشت داد';
    } else if (h.action == 'reject_back') {
      return '$name به یک مرحله قبل برگشت داد';
    } else if (h.action == 'reopen') {
      return '${h.userName ?? "ادمین"} تأیید نهایی را بازگرداند';
    } else if (h.action == 'comment') {
      return '$name یادداشت ثبت کرد';
    }
    return h.action;
  }

  void _exportHistoryPdf(
      ApprovalQueueItem item, List<ProgressHistoryItem> history) {
    final period = _period?.title ?? '';
    final sb = StringBuffer();
    sb.write('''
<!DOCTYPE html><html dir="rtl" lang="fa"><head><meta charset="utf-8">
<title>گردش کار فعالیت</title>
<style>
body{font-family:Tahoma,Arial,sans-serif;direction:rtl;padding:24px;color:#222}
h2{text-align:center;margin-bottom:4px}
.meta{text-align:center;color:#666;margin-bottom:20px;font-size:13px}
table{width:100%;border-collapse:collapse;font-size:13px}
th,td{border:1px solid #bbb;padding:8px 10px;text-align:right}
th{background:#1A2238;color:#fff;text-align:center}
tr:nth-child(even){background:#f4f6f9}
.date{color:#666;font-size:11px;white-space:nowrap}
@media print{button{display:none}}
</style></head><body>
<h2>گردش کار فعالیت</h2>
<div class="meta">
${item.activityNumber ?? ''} — ${item.activityName}<br>
دوره: $period
</div>
<table><thead><tr>
<th style="width:40px">#</th><th>شرح اقدام</th><th style="width:140px">تاریخ و زمان</th>
</tr></thead><tbody>
''');
    var i = 1;
    for (final h in history) {
      sb.write('<tr>'
          '<td style="text-align:center">${i++}</td>'
          '<td>${_historyLabel(h)}</td>'
          '<td class="date">${_historyDateStr(h)}</td>'
          '</tr>');
    }
    sb.write('''
</tbody></table>
<p style="text-align:center;margin-top:20px">
<button onclick="window.print()" style="padding:8px 24px;font-size:14px">چاپ / ذخیره PDF</button></p>
<script>window.onload=function(){setTimeout(function(){window.print();},400);};</script>
</body></html>
''');
    final blob = html.Blob([sb.toString()], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, '_blank');
  }

  String _historyDateStr(ProgressHistoryItem h) {
    final d = h.createdAt;
    return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  Widget _historyRow(ProgressHistoryItem h) {
    final label = _historyLabel(h);
    IconData icon;
    Color color;
    if (h.action == 'modify') {
      final hasOld = h.oldValue != null && h.oldValue! > 0;
      final up = (h.newValue ?? 0) >= (h.oldValue ?? 0);
      icon = !hasOld
          ? Icons.edit
          : (up ? Icons.arrow_upward : Icons.arrow_downward);
      color = !hasOld
          ? const Color(0xFF0277BD)
          : (up ? const Color(0xFF2E7D52) : const Color(0xFFC0392B));
    } else if (h.action == 'approve') {
      icon = Icons.check_circle;
      color = const Color(0xFF0277BD);
    } else if (h.action == 'final') {
      icon = Icons.verified;
      color = const Color(0xFF1B5E20);
    } else if (h.action == 'submit') {
      icon = Icons.send;
      color = const Color(0xFF0277BD);
    } else if (h.action == 'reject_owner') {
      icon = Icons.keyboard_double_arrow_right;
      color = const Color(0xFFC0392B);
    } else if (h.action == 'reject_back') {
      icon = Icons.keyboard_arrow_right;
      color = const Color(0xFFBA7517);
    } else if (h.action == 'reopen') {
      icon = Icons.lock_open;
      color = const Color(0xFFC0392B);
    } else if (h.action == 'comment') {
      icon = Icons.comment;
      color = const Color(0xFFBA7517);
    } else {
      icon = Icons.circle;
      color = Colors.grey;
    }
    final dateStr = _historyDateStr(h);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 13)),
                if (h.note != null && h.note!.isNotEmpty)
                  Text('دلیل: ${h.note}',
                      style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFBA7517),
                          fontStyle: FontStyle.italic)),
                Text(dateStr,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF999999))),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _hCell(String text, Color textColor) => Text(text,
      style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w600, color: textColor));

  Widget _rowWidget(_RowData r, bool isDark, Color textColor) {
    final a = r.activity;
    final typeColor =
        a.isProject ? const Color(0xFF0277BD) : const Color(0xFF2E7D52);
    final locked = (r.thisEntry?.isLocked ?? false) || !r.isActive;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF252D45) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: isDark ? const Color(0xFF3A4468) : const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                            color: typeColor, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                          a.activityNumber != null &&
                                  a.activityNumber!.isNotEmpty
                              ? '${a.activityNumber} - ${a.name}'
                              : a.name,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: textColor)),
                    ),
                    if (!r.isActive) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: const Color(0xFF999999).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4)),
                        child: const Text('غیرفعال',
                            style: TextStyle(
                                fontSize: 10, color: Color(0xFF999999))),
                      ),
                    ],
                  ],
                ),
                Text(_unitPath(a.unitId),
                    style: TextStyle(
                        fontSize: 10,
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF999999))),
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Text(a.weight.toStringAsFixed(1),
                  style: TextStyle(fontSize: 13, color: textColor))),
          Expanded(
            flex: 2,
            child: Text(
                a.isKpi
                    ? '100'
                    : (r.targetThis != null
                        ? '${r.targetThis!.toStringAsFixed(1)}٪'
                        : '—'),
                style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : const Color(0xFF555555))),
          ),
          Expanded(
            flex: 2,
            child: Text(
                r.prevEntered != null
                    ? '${r.prevEntered!.toStringAsFixed(1)}٪'
                    : '—',
                style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white54 : const Color(0xFF999999))),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              controller: r.controller,
              enabled: !locked,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                isDense: true,
                suffixText: '٪',
                filled: locked,
                fillColor: isDark
                    ? const Color(0xFF2D3552)
                    : const Color(0xFFF0F0F0),
              ),
            ),
          ),
          if (r.noteController.text.trim().isNotEmpty)
            Tooltip(
              message: r.noteController.text.trim(),
              child: const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.comment, size: 16, color: Color(0xFFBA7517)),
              ),
            ),
          IconButton(
            icon: Icon(Icons.edit_note,
                size: 20, color: locked ? Colors.grey : _primary),
            tooltip: locked ? 'ثبت‌شده' : 'ثبت با توضیح',
            onPressed: locked ? null : () => _showEntryDialog(r),
          ),
        ],
      ),
    );
  }

  Future<void> _showEntryDialog(_RowData r) async {
    final valueController =
        TextEditingController(text: r.controller.text);
    final noteController =
        TextEditingController(text: r.noteController.text);

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ثبت پیشرفت'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(r.activity.name,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                  'تارگت این ماه: ${r.activity.isKpi ? "100" : (r.targetThis != null ? "${r.targetThis!.toStringAsFixed(1)}٪" : "—")}',
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF777777))),
              const SizedBox(height: 12),
              TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'درصد پیشرفت',
                    border: OutlineInputBorder(),
                    suffixText: '٪',
                    isDense: true),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'توضیح / کامنت (اختیاری)',
                    border: OutlineInputBorder(),
                    isDense: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('لغو')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('ثبت'),
          ),
        ],
      ),
    );

    if (result == true) {
      setState(() {
        r.controller.text = valueController.text.trim();
        r.noteController.text = noteController.text.trim();
      });
    }
  }

}