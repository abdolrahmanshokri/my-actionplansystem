import 'data_repository.dart';
import 'api_client.dart';

// پیاده‌سازی DataRepository که به سرور API وصل می‌شود.
// متدهای آماده به endpointهای سرور وصل‌اند؛ متدهای پیچیده‌ی
// (داشبورد، صف تأیید، گردش کار) فعلاً مقدار خنثی برمی‌گردانند
// تا اپ کرش نکند؛ در قدم بعد endpointهایشان اضافه می‌شود.
class ApiRepository implements DataRepository {
  final _api = ApiClient.instance;

  // ===== زیرساخت (در حالت API لازم نیست) =====
  @override
  Future<void> initialize() async {}
  @override
  Future<bool> isDatabaseReady() async => true;
  @override
  Future<void> createOrMigrate() async {}
  @override
  Future<void> resetDatabase() async {}
  @override
  Future<List<int>> backupDatabase() async => <int>[];

  // ===== کاربران و نقش‌ها =====
  @override
  Future<List<AppUser>> getAllUsers() async {
    final res = await _api.get('/api/Users') as List;
    return res.map((e) => _userFromJson(e)).toList();
  }

  @override
  Future<AppUser?> getUserByUsername(String username) async {
    final users = await getAllUsers();
    final m = users.where((u) => u.username == username);
    return m.isEmpty ? null : m.first;
  }

  @override
  Future<List<RoleInfo>> getAllRoles() async {
    final res = await _api.get('/api/Roles') as List;
    return res
        .map((e) => RoleInfo(
            id: e['id'] as int,
            code: e['code'] as String,
            title: e['title'] as String,
            level: 0))
        .toList();
  }

  @override
  Future<int> createUser({
    required String username,
    required String fullName,
    String? email,
    String authType = 'local',
    String? password,
    required List<int> roleIds,
  }) async {
    final roleCodes = await _roleCodesFromIds(roleIds);
    final res = await _api.post('/api/Users', body: {
      'username': username,
      'password': password ?? '1234',
      'fullName': fullName,
      'isActive': true,
      'roles': roleCodes,
    });
    return res['id'] as int;
  }

  @override
  Future<void> updateUser({
    required int userId,
    required String fullName,
    String? email,
    bool? isActive,
    List<int>? roleIds,
  }) async {
    final roleCodes = await _roleCodesFromIds(roleIds ?? []);
    await _api.put('/api/Users/$userId', body: {
      'fullName': fullName,
      'isActive': isActive ?? true,
      'roles': roleCodes,
    });
  }

  Future<List<String>> _roleCodesFromIds(List<int> ids) async {
    if (ids.isEmpty) return [];
    final roles = await getAllRoles();
    return roles
        .where((r) => ids.contains(r.id))
        .map((r) => r.code)
        .toList();
  }

  @override
  Future<void> deleteUser(int userId) async {
    await _api.delete('/api/Users/$userId');
  }

  @override
  Future<void> setUserPassword(int userId, String newPassword) async {
    await _api.put('/api/Users/$userId/password',
        body: {'newPassword': newPassword});
  }

  @override
  Future<AppUser?> authenticateLocal(String username, String password) async {
    // لاگین در AuthManager به‌صورت جدا انجام می‌شود
    return null;
  }

  @override
  Future<void> recordLogin(int userId) async {}

  // ===== تنظیمات =====
  @override
  Future<String?> getSetting(String key) async {
    try {
      final res = await _api.get('/api/Settings/$key');
      return res?['value'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> setSetting(String key, String value) async {
    await _api.put('/api/Settings/$key', body: {'value': value});
  }

  // ===== سال و دوره =====
  @override
  Future<List<YearInfo>> getAllYears() async {
    final res = await _api.get('/api/Years') as List;
    return res.map((e) => _yearFromJson(e)).toList();
  }

  @override
  Future<List<PeriodInfo>> getPeriodsForYear(int yearId) async {
    final res = await _api.get('/api/Years/$yearId/periods') as List;
    return res.map((e) => _periodFromJson(e)).toList();
  }

  @override
  Future<String?> createYearWithPeriods({
    required int yearValue,
    required String title,
    required int startJy,
    required int startJm,
    required int startJd,
    required int endJy,
    required int endJm,
    required int endJd,
    required List<int> monthNumbers,
  }) async {
    final res = await _api.post('/api/Years', body: {
      'yearValue': yearValue,
      'title': title,
      'startJy': startJy, 'startJm': startJm, 'startJd': startJd,
      'endJy': endJy, 'endJm': endJm, 'endJd': endJd,
      'isClosed': false,
    });
    final yearId = res['id'] as int;
    const monthNames = [
      'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
      'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'
    ];
    for (final m in monthNumbers) {
      final name = (m >= 1 && m <= 12) ? monthNames[m - 1] : 'ماه $m';
      await _api.post('/api/Years/$yearId/periods', body: {
        'monthNumber': m,
        'monthName': name,
        'title': '$name $yearValue',
        'isOpen': true,
      });
    }
    return null;
  }

  @override
  Future<bool> deleteYear(int yearId) async {
    await _api.delete('/api/Years/$yearId');
    return true;
  }

  @override
  Future<void> setPeriodStatus(int periodId, String status) async {
    final open = status == 'open';
    await _api.put('/api/Years/periods/$periodId/toggle?open=$open');
  }

  @override
  Future<bool> deletePeriod(int periodId) async {
    await _api.delete('/api/Years/periods/$periodId');
    return true;
  }

  @override
  Future<int> periodCountForYear(int yearId) async {
    final periods = await getPeriodsForYear(yearId);
    return periods.length;
  }

  // ===== واحدها =====
  @override
  Future<List<UnitInfo>> getAllUnits() async {
    final res = await _api.get('/api/Units') as List;
    final raw = res.map((e) => _unitFromJson(e)).toList();
    // محاسبه‌ی level از روی زنجیره‌ی والدین
    final byId = {for (final u in raw) u.id: u};
    int levelOf(UnitInfo u) {
      int lvl = 1;
      int? pid = u.parentId;
      int guard = 0;
      while (pid != null && guard < 20) {
        lvl++;
        pid = byId[pid]?.parentId;
        guard++;
      }
      return lvl;
    }

    return raw
        .map((u) => UnitInfo(
              id: u.id,
              parentId: u.parentId,
              name: u.name,
              description: u.description,
              level: levelOf(u),
              sortOrder: u.sortOrder,
            ))
        .toList();
  }

  @override
  Future<int> createUnit({
    int? parentId,
    required String name,
    String? description,
    required int level,
  }) async {
    final res = await _api.post('/api/Units', body: {
      'parentId': parentId,
      'name': name,
      'sortOrder': 0,
    });
    return res['id'] as int;
  }

  @override
  Future<void> updateUnit({
    required int unitId,
    required String name,
    String? description,
  }) async {
    // parentId و sortOrder واحد را حفظ می‌کنیم
    final all = await getAllUnits();
    final existing = all.where((u) => u.id == unitId);
    final parentId = existing.isEmpty ? null : existing.first.parentId;
    final sortOrder = existing.isEmpty ? 0 : existing.first.sortOrder;
    await _api.put('/api/Units/$unitId', body: {
      'parentId': parentId,
      'name': name,
      'sortOrder': sortOrder,
    });
  }

  @override
  Future<bool> deleteUnit(int unitId) async {
    try {
      await _api.delete('/api/Units/$unitId');
      return true;
    } catch (_) {
      return false;
    }
  }

  // ===== زنجیره‌ی تأیید =====
  @override
  Future<List<ApprovalStepInfo>> getApprovalSteps(int unitId) async {
    final res = await _api.get('/api/Units/$unitId/approval-steps') as List;
    return res.map((e) => _stepFromJson(e)).toList();
  }

  @override
  Future<void> addApprovalStep({
    required int unitId,
    required String approvalType,
    required String subjectType,
    int? roleId,
    int? userId,
    String? label,
  }) async {
    await _api.post('/api/Units/$unitId/approval-steps', body: {
      'approvalType': approvalType,
      'roleId': roleId,
      'userId': userId,
    });
  }

  @override
  Future<void> deleteApprovalStep(int stepId) async {
    await _api.delete('/api/Units/approval-steps/$stepId');
  }

  @override
  Future<void> moveApprovalStep(int stepId, bool up) async {
    // فعلاً سرور reorder ندارد؛ بعداً اضافه می‌شود
  }

  @override
  Future<List<ApprovalStepInfo>> getEffectiveApprovalSteps(int unitId) async {
    final res = await _api.get('/api/Units/$unitId/effective-steps') as List;
    return res.map((e) => _stepFromJson(e)).toList();
  }

  @override
  Future<List<ApprovalStepInfo>> getParentApprovalSteps(int unitId) async {
    // مراحل مؤثر منهای مراحل خود واحد
    final all = await getEffectiveApprovalSteps(unitId);
    return all.where((s) => s.unitId != unitId).toList();
  }

  // ===== فعالیت‌ها =====
  @override
  Future<List<ActivityInfo>> getAllActivities() async {
    final res = await _api.get('/api/Activities') as List;
    return res.map((e) => _activityFromJson(e)).toList();
  }

  @override
  Future<List<ActivityInfo>> getActivitiesForUnit(int unitId) async {
    final all = await getAllActivities();
    return all.where((a) => a.unitId == unitId).toList();
  }

  @override
  Future<List<ActivityInfo>> getActivitiesOwnedBy(int userId) async {
    final res = await _api.get('/api/Activities/owned-by/$userId') as List;
    return res.map((e) => _activityFromJson(e)).toList();
  }

  @override
  Future<int> createActivity({
    required int unitId,
    String? activityNumber,
    required String name,
    required String activityType,
    required double weight,
    int? ownerUserId,
    String? description,
    required List<CollaboratorInfo> collaborators,
  }) async {
    final res = await _api.post('/api/Activities', body: {
      'unitId': unitId,
      'activityNumber': activityNumber,
      'name': name,
      'activityType': activityType,
      'weight': weight,
      'ownerUserId': ownerUserId,
      'description': description,
      'isActive': true,
      'collaborators': collaborators
          .map((c) => {'unitId': c.unitId, 'weight': c.weight})
          .toList(),
    });
    return res['id'] as int;
  }

  @override
  Future<void> updateActivity({
    required int activityId,
    String? activityNumber,
    required String name,
    required String activityType,
    required double weight,
    int? ownerUserId,
    String? description,
    required List<CollaboratorInfo> collaborators,
  }) async {
    // unitId را از فعالیت موجود می‌خوانیم (قرارداد در update آن را نمی‌گیرد)
    final all = await getAllActivities();
    final existing = all.where((a) => a.id == activityId);
    final unitId = existing.isEmpty ? 0 : existing.first.unitId;
    await _api.put('/api/Activities/$activityId', body: {
      'unitId': unitId,
      'activityNumber': activityNumber,
      'name': name,
      'activityType': activityType,
      'weight': weight,
      'ownerUserId': ownerUserId,
      'description': description,
      'collaborators': collaborators
          .map((c) => {'unitId': c.unitId, 'weight': c.weight})
          .toList(),
    });
  }

  @override
  Future<void> deleteActivity(int activityId) async {
    await _api.delete('/api/Activities/$activityId');
  }

  @override
  Future<void> setActivityActive(int activityId, bool active) async {
    await _api.put('/api/Activities/$activityId/active?active=$active');
  }

  @override
  Future<bool> unitHasActivities(int unitId) async {
    final res = await _api.get('/api/Units/$unitId/has-activities');
    return res['hasActivities'] as bool;
  }

  @override
  Future<int?> activityNumberOwnerUnit(String number, {int? exceptId}) async {
    final all = await getAllActivities();
    final m = all.where(
        (a) => a.activityNumber == number && a.id != (exceptId ?? -1));
    return m.isEmpty ? null : m.first.unitId;
  }

  // ===== تارگت =====
  @override
  Future<TargetInfo?> getTarget(int activityId, int yearId) async {
    final res = await _api.get('/api/Targets/$activityId/$yearId');
    if (res == null) return null;
    return _targetFromJson(res);
  }

  @override
  Future<void> saveTarget({
    required int activityId,
    required int yearId,
    required double startValue,
    required String distributionType,
    required Map<int, double> periodValues,
    Map<int, bool>? activeValues,
  }) async {
    await _api.post('/api/Targets', body: {
      'activityId': activityId,
      'yearId': yearId,
      'startValue': startValue,
      'distributionType': distributionType,
      'periodValues':
          periodValues.map((k, v) => MapEntry(k.toString(), v)),
      'activeValues':
          activeValues?.map((k, v) => MapEntry(k.toString(), v)),
    });
  }

  @override
  Future<void> deleteTarget(int targetId) async {
    await _api.delete('/api/Targets/$targetId');
  }

  @override
  Future<Set<int>> activityIdsWithTargetInYear(int yearId) async {
    final res =
        await _api.get('/api/Targets/year/$yearId/activity-ids') as List;
    return res.map((e) => e as int).toSet();
  }

  // ===== پیشرفت =====
  @override
  Future<Map<int, ProgressEntryInfo>> getProgressForActivityYear(
      int activityId, int yearId) async {
    final res = await _api
        .get('/api/Progress/$activityId/year/$yearId') as List;
    final map = <int, ProgressEntryInfo>{};
    for (final e in res) {
      final info = _progressFromJson(e);
      map[info.periodId] = info;
    }
    return map;
  }

  @override
  Future<void> saveProgress({
    required int activityId,
    required int periodId,
    required double progressValue,
    String? note,
    required int enteredByUserId,
    String? userName,
  }) async {
    await _api.post('/api/Progress/save', body: {
      'activityId': activityId,
      'periodId': periodId,
      'progressValue': progressValue,
      'note': note,
    });
  }

  @override
  Future<void> submitProgress(int activityId, int periodId,
      {int? userId, String? userName}) async {
    await _api.post('/api/Progress/submit', body: {
      'activityId': activityId,
      'periodId': periodId,
      'progressValue': 0,
      'note': null,
    });
  }

  @override
  Future<List<PeriodInfo>> getOpenPeriods() async {
    final res = await _api.get('/api/Years/open-periods') as List;
    return res.map((e) => _periodFromJson(e)).toList();
  }

  @override
  Future<int?> previousPeriodId(int periodId) async {
    // پیدا کردن دوره‌ی قبلی از روی همان سال
    final years = await getAllYears();
    for (final y in years) {
      final periods = await getPeriodsForYear(y.id);
      final idx = periods.indexWhere((p) => p.id == periodId);
      if (idx > 0) return periods[idx - 1].id;
      if (idx == 0) return null;
    }
    return null;
  }

  @override
  Future<List<ProgressHistoryItem>> getProgressHistory(
      int progressEntryId) async {
    final res =
        await _api.get('/api/Progress/$progressEntryId/history') as List;
    return res
        .map((e) => ProgressHistoryItem(
            action: e['action'] as String,
            userName: e['userName'] as String?,
            oldValue: (e['oldValue'] as num?)?.toDouble(),
            newValue: (e['newValue'] as num?)?.toDouble(),
            note: e['note'] as String?,
            createdAt: DateTime.tryParse(e['createdAt'] as String? ?? '') ??
                DateTime.now()))
        .toList();
  }

  // ===== گزارش =====
  @override
  Future<List<ReportRow>> getReportRows({
    required int yearId,
    int? periodId,
    int? ownerUserId,
    int? filterUnitId,
    bool includeInactive = false,
    String typeFilter = 'all',
  }) async {
    var path = '/api/Reports?yearId=$yearId'
        '&includeInactive=$includeInactive&typeFilter=$typeFilter';
    if (periodId != null) path += '&periodId=$periodId';
    if (filterUnitId != null) path += '&filterUnitId=$filterUnitId';
    final res = await _api.get(path) as List;
    return res
        .map((e) => ReportRow(
            activityNumber: e['activityNumber'] as String? ?? '',
            activityName: e['activityName'] as String? ?? '',
            unitRoot: e['unitRoot'] as String? ?? '',
            unitMid: e['unitMid'] as String? ?? '',
            unitLeaf: e['unitLeaf'] as String? ?? '',
            type: e['type'] as String? ?? '',
            weight: (e['weight'] as num?)?.toDouble() ?? 0,
            target: (e['target'] as num?)?.toDouble() ?? 0,
            progress: (e['progress'] as num?)?.toDouble() ?? 0,
            achievement: (e['achievement'] as num?)?.toDouble() ?? 0,
            status: e['status'] as String? ?? '',
            isActive: e['isActive'] as bool? ?? true))
        .toList();
  }

  @override
  Future<bool> isActivityActiveInPeriod(
      int activityId, int periodId, bool isKpi) async {
    try {
      final res = await _api
          .get('/api/Progress/is-active/$activityId/$periodId?isKpi=$isKpi');
      return res['active'] as bool? ?? true;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<List<UnitInfo>> getAccessibleUnits(int userId) async {
    // فعلاً همه‌ی واحدها (تا endpoint اختصاصی اضافه شود)
    return getAllUnits();
  }

  // ===== متدهای پیچیده (endpoint هنوز آماده نیست — قدم بعد) =====
  @override
  Future<DashboardStats> getDashboardStats({
    required int periodId,
    int? ownerUserId,
    int? filterUnitId,
  }) async {
    var path = '/api/Dashboard/$periodId';
    final params = <String>[];
    if (ownerUserId != null) params.add('ownerUserId=$ownerUserId');
    if (filterUnitId != null) params.add('filterUnitId=$filterUnitId');
    if (params.isNotEmpty) path += '?${params.join('&')}';

    final res = await _api.get(path);
    if (res == null) {
      return const DashboardStats(
        totalActivities: 0, draftCount: 0, submittedCount: 0,
        finalCount: 0, notStartedCount: 0, avgProgress: 0,
        unitRows: [], activityRows: [],
      );
    }
    return DashboardStats(
      totalActivities: res['totalActivities'] as int? ?? 0,
      draftCount: res['draftCount'] as int? ?? 0,
      submittedCount: res['submittedCount'] as int? ?? 0,
      finalCount: res['finalCount'] as int? ?? 0,
      notStartedCount: res['notStartedCount'] as int? ?? 0,
      avgProgress: (res['avgProgress'] as num?)?.toDouble() ?? 0,
      unitRows: (res['unitRows'] as List?)
              ?.map((u) => UnitProgressRow(
                    unitId: u['unitId'] as int,
                    unitName: u['unitName'] as String? ?? '—',
                    activityCount: u['activityCount'] as int? ?? 0,
                    avgProgress: (u['avgProgress'] as num?)?.toDouble() ?? 0,
                    avgTarget: (u['avgTarget'] as num?)?.toDouble() ?? 0,
                    weightedProgress:
                        (u['weightedProgress'] as num?)?.toDouble() ?? 0,
                    weightedTarget:
                        (u['weightedTarget'] as num?)?.toDouble() ?? 0,
                  ))
              .toList() ??
          [],
      activityRows: (res['activityRows'] as List?)
              ?.map((a) => ActivityProgressRow(
                    activityId: a['activityId'] as int,
                    activityName: a['activityName'] as String? ?? '',
                    activityNumber: a['activityNumber'] as String?,
                    unitId: a['unitId'] as int,
                    unitName: a['unitName'] as String? ?? '—',
                    progress: (a['progress'] as num?)?.toDouble() ?? 0,
                    target: (a['target'] as num?)?.toDouble() ?? 0,
                    weight: (a['weight'] as num?)?.toDouble() ?? 0,
                    status: a['status'] as String? ?? 'not_started',
                  ))
              .toList() ??
          [],
    );
  }

  @override
  Future<List<ApprovalQueueItem>> getApprovalQueueForPeriod(
      int periodId, int userId,
      {required bool onlyMyTurn,
      bool showAll = false,
      bool includeInactive = false}) async {
    final res = await _api.get(
        '/api/Progress/approval-queue/$periodId'
        '?onlyMyTurn=$onlyMyTurn&showAll=$showAll'
        '&includeInactive=$includeInactive') as List;
    return res
        .map((e) => ApprovalQueueItem(
              progressEntryId: e['progressEntryId'] as int,
              activityId: e['activityId'] as int,
              activityName: e['activityName'] as String? ?? '',
              activityNumber: e['activityNumber'] as String?,
              unitId: e['unitId'] as int,
              progressValue: (e['progressValue'] as num?)?.toDouble() ?? 0,
              targetThis: (e['targetThis'] as num?)?.toDouble(),
              weight: (e['weight'] as num?)?.toDouble() ?? 0,
              status: e['status'] as String? ?? '',
              currentStepIndex: e['currentStepIndex'] as int? ?? 0,
              currentHolderName: e['currentHolderName'] as String?,
              isMyTurn: e['isMyTurn'] as bool? ?? false,
            ))
        .toList();
  }

  @override
  Future<void> approveOrModify({
    required int progressEntryId,
    required int stepIndex,
    required double newValue,
    required int userId,
    required String userName,
    String? note,
  }) async {
    await _api.post('/api/Progress/approve-modify', body: {
      'progressEntryId': progressEntryId,
      'stepIndex': stepIndex,
      'newValue': newValue,
      'note': note,
    });
  }

  @override
  Future<void> rejectProgress({
    required int progressEntryId,
    required int stepIndex,
    required bool toOwner,
    required int userId,
    required String userName,
    String? note,
  }) async {
    await _api.post('/api/Progress/reject-entry', body: {
      'progressEntryId': progressEntryId,
      'stepIndex': stepIndex,
      'toOwner': toOwner,
      'note': note,
    });
  }

  @override
  Future<void> reopenFinalProgress({
    required int progressEntryId,
    required int userId,
    required String userName,
    String? note,
  }) async {
    await _api.post('/api/Progress/reopen-entry', body: {
      'progressEntryId': progressEntryId,
      'note': note,
    });
  }

  // ===== توابع تبدیل JSON به مدل =====
  AppUser _userFromJson(dynamic e) => AppUser(
        id: e['id'] as int,
        username: e['username'] as String,
        fullName: e['fullName'] as String,
        roleCodes: (e['roles'] as List?)?.cast<String>() ?? [],
        isActive: e['isActive'] as bool? ?? true,
      );

  YearInfo _yearFromJson(dynamic e) => YearInfo(
        id: e['id'] as int,
        yearValue: e['yearValue'] as int,
        title: e['title'] as String,
        startJy: e['startJy'] as int,
        startJm: e['startJm'] as int,
        startJd: e['startJd'] as int,
        endJy: e['endJy'] as int,
        endJm: e['endJm'] as int,
        endJd: e['endJd'] as int,
      );

  PeriodInfo _periodFromJson(dynamic e) => PeriodInfo(
        id: e['id'] as int,
        yearId: e['yearId'] as int,
        monthNumber: e['monthNumber'] as int,
        monthName: e['monthName'] as String,
        title: e['title'] as String,
        status: (e['isOpen'] as bool? ?? true) ? 'open' : 'closed',
      );

  UnitInfo _unitFromJson(dynamic e) => UnitInfo(
        id: e['id'] as int,
        parentId: e['parentId'] as int?,
        name: e['name'] as String,
        level: 0,
        sortOrder: e['sortOrder'] as int? ?? 0,
      );

  ApprovalStepInfo _stepFromJson(dynamic e) => ApprovalStepInfo(
        id: e['id'] as int,
        unitId: e['unitId'] as int,
        stepOrder: e['stepOrder'] as int,
        approvalType: e['approvalType'] as String? ?? 'or',
        subjectType: (e['userId'] != null) ? 'user' : 'role',
        roleId: e['roleId'] as int?,
        userId: e['userId'] as int?,
      );

  ActivityInfo _activityFromJson(dynamic e) => ActivityInfo(
        id: e['id'] as int,
        unitId: e['unitId'] as int,
        activityNumber: e['activityNumber'] as String?,
        name: e['name'] as String,
        activityType: e['activityType'] as String,
        weight: (e['weight'] as num?)?.toDouble() ?? 0,
        ownerUserId: e['ownerUserId'] as int?,
        ownerName: e['ownerName'] as String?,
        description: e['description'] as String?,
        isActive: e['isActive'] as bool? ?? true,
        collaborators: (e['collaborators'] as List?)
                ?.map((c) => CollaboratorInfo(
                    unitId: c['unitId'] as int,
                    unitName: '',
                    weight: (c['weight'] as num?)?.toDouble() ?? 0))
                .toList() ??
            [],
      );

  TargetInfo _targetFromJson(dynamic e) => TargetInfo(
        id: e['id'] as int,
        activityId: e['activityId'] as int,
        yearId: e['yearId'] as int,
        startValue: (e['startValue'] as num?)?.toDouble() ?? 0,
        distributionType: e['distributionType'] as String? ?? 'uniform',
        periods: (e['periods'] as List?)
                ?.map((p) => TargetPeriodValue(
                    periodId: p['periodId'] as int,
                    monthNumber: p['monthNumber'] as int,
                    monthName: p['monthName'] as String,
                    targetValue: (p['targetValue'] as num?)?.toDouble() ?? 0,
                    isActive: p['isActive'] as bool? ?? true))
                .toList() ??
            [],
      );

  ProgressEntryInfo _progressFromJson(dynamic e) => ProgressEntryInfo(
        id: e['id'] as int?,
        activityId: e['activityId'] as int,
        periodId: e['periodId'] as int,
        progressValue: (e['progressValue'] as num?)?.toDouble() ?? 0,
        note: e['note'] as String?,
        status: e['status'] as String? ?? 'draft',
      );
}