import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'app_database.dart';
import 'data_repository.dart';
import 'jalali_helper.dart';

class DriftRepository implements DataRepository {
  AppDatabase? _db;

  AppDatabase get db {
    _db ??= AppDatabase();
    return _db!;
  }

  static String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  @override
  Future<void> initialize() async {
    await db.customStatement('PRAGMA foreign_keys = ON');
  }

  @override
  Future<bool> isDatabaseReady() async {
    try {
      final count = await db.select(db.roles).get();
      return count.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> createOrMigrate() async {
    await db.customStatement('PRAGMA foreign_keys = ON');
    final ready = await isDatabaseReady();
    if (!ready) {
      await db.resetDatabase();
    }
  }

  @override
  Future<void> resetDatabase() async {
    await db.resetDatabase();
  }

  @override
  Future<List<int>> backupDatabase() async {
    final users = await db.select(db.users).get();
    final roles = await db.select(db.roles).get();
    final userRoles = await db.select(db.userRoles).get();
    final settings = await db.select(db.appSettings).get();

    final Map<String, dynamic> dump = {
      'exportedAt': DateTime.now().toIso8601String(),
      'users': users
          .map((u) => {
                'id': u.id,
                'username': u.username,
                'fullName': u.fullName,
                'email': u.email,
                'authType': u.authType,
                'isActive': u.isActive,
              })
          .toList(),
      'roles': roles
          .map((r) => {
                'id': r.id,
                'code': r.code,
                'title': r.title,
                'level': r.level,
              })
          .toList(),
      'userRoles': userRoles
          .map((ur) => {'userId': ur.userId, 'roleId': ur.roleId})
          .toList(),
      'settings':
          settings.map((s) => {'key': s.key, 'value': s.value}).toList(),
    };

    final jsonText = const JsonEncoder.withIndent('  ').convert(dump);
    return utf8.encode(jsonText);
  }

  Future<List<MapEntry<int, String>>> _rolesForUser(int userId) async {
    final query = db.select(db.userRoles).join([
      innerJoin(db.roles, db.roles.id.equalsExp(db.userRoles.roleId)),
    ])
      ..where(db.userRoles.userId.equals(userId));
    final rows = await query.get();
    return rows
        .map((row) => MapEntry(
            row.readTable(db.roles).id, row.readTable(db.roles).code))
        .toList();
  }

  Future<AppUser> _toAppUser(User u) async {
    final roles = await _rolesForUser(u.id);
    return AppUser(
      id: u.id,
      username: u.username,
      fullName: u.fullName,
      email: u.email,
      roleCodes: roles.map((e) => e.value).toList(),
      roleIds: roles.map((e) => e.key).toList(),
      isActive: u.isActive,
    );
  }

  @override
  Future<List<AppUser>> getAllUsers() async {
    final all = await db.select(db.users).get();
    final result = <AppUser>[];
    for (final u in all) {
      result.add(await _toAppUser(u));
    }
    return result;
  }

  @override
  Future<List<RoleInfo>> getAllRoles() async {
    final all = await (db.select(db.roles)
          ..orderBy([(r) => OrderingTerm.desc(r.level)]))
        .get();
    return all
        .map((r) => RoleInfo(
            id: r.id, code: r.code, title: r.title, level: r.level))
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
    final userId = await db.into(db.users).insert(UsersCompanion.insert(
          username: username,
          fullName: fullName,
          email: Value(email),
          authType: Value(authType),
          passwordHash:
              Value(password != null ? hashPassword(password) : null),
        ));
    await db.batch((b) {
      b.insertAll(
        db.userRoles,
        roleIds.map((rid) =>
            UserRolesCompanion.insert(userId: userId, roleId: rid)),
      );
    });
    return userId;
  }

  @override
  Future<void> updateUser({
    required int userId,
    required String fullName,
    String? email,
    bool? isActive,
    List<int>? roleIds,
  }) async {
    await (db.update(db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        fullName: Value(fullName),
        email: Value(email),
        isActive: isActive != null ? Value(isActive) : const Value.absent(),
      ),
    );
    if (roleIds != null) {
      await (db.delete(db.userRoles)
            ..where((ur) => ur.userId.equals(userId)))
          .go();
      await db.batch((b) {
        b.insertAll(
          db.userRoles,
          roleIds.map((rid) =>
              UserRolesCompanion.insert(userId: userId, roleId: rid)),
        );
      });
    }
  }

  @override
  Future<void> deleteUser(int userId) async {
    await (db.delete(db.users)..where((u) => u.id.equals(userId))).go();
  }

  @override
  Future<void> setUserPassword(int userId, String newPassword) async {
    await (db.update(db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(passwordHash: Value(hashPassword(newPassword))),
    );
  }

  @override
  Future<AppUser?> getUserByUsername(String username) async {
    final query = db.select(db.users)
      ..where((u) => u.username.equals(username));
    final u = await query.getSingleOrNull();
    if (u == null) return null;
    return _toAppUser(u);
  }

  @override
  Future<AppUser?> authenticateLocal(String username, String password) async {
    final query = db.select(db.users)
      ..where((u) => u.username.equals(username));
    final u = await query.getSingleOrNull();
    if (u == null) return null;
    if (!u.isActive) return null;
    if (u.passwordHash == null) return null;
    if (u.passwordHash != hashPassword(password)) return null;
    return _toAppUser(u);
  }

  @override
  Future<void> recordLogin(int userId) async {
    await (db.update(db.users)..where((u) => u.id.equals(userId)))
        .write(UsersCompanion(lastLoginAt: Value(DateTime.now())));
  }

  @override
  Future<String?> getSetting(String key) async {
    final query = db.select(db.appSettings)
      ..where((s) => s.key.equals(key));
    final row = await query.getSingleOrNull();
    return row?.value;
  }

  @override
  Future<void> setSetting(String key, String value) async {
    final existing = await (db.select(db.appSettings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    if (existing != null) {
      await (db.update(db.appSettings)..where((s) => s.key.equals(key)))
          .write(AppSettingsCompanion(value: Value(value)));
    } else {
      await db.into(db.appSettings).insert(
            AppSettingsCompanion.insert(key: key, value: Value(value)),
          );
    }
  }

  @override
  Future<List<YearInfo>> getAllYears() async {
    final rows = await (db.select(db.years)
          ..orderBy([(y) => OrderingTerm.desc(y.yearValue)]))
        .get();
    return rows
        .map((y) => YearInfo(
              id: y.id,
              yearValue: y.yearValue,
              title: y.title,
              startJy: y.startJy,
              startJm: y.startJm,
              startJd: y.startJd,
              endJy: y.endJy,
              endJm: y.endJm,
              endJd: y.endJd,
            ))
        .toList();
  }

  @override
  Future<List<PeriodInfo>> getPeriodsForYear(int yearId) async {
    final rows = await (db.select(db.periods)
          ..where((p) => p.yearId.equals(yearId))
          ..orderBy([(p) => OrderingTerm.asc(p.monthNumber)]))
        .get();
    return rows
        .map((p) => PeriodInfo(
              id: p.id,
              yearId: p.yearId,
              monthNumber: p.monthNumber,
              monthName: p.monthName,
              title: p.title,
              status: p.status,
            ))
        .toList();
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
    final existing = await db.select(db.years).get();
    for (final y in existing) {
      if (y.yearValue == yearValue) {
        final periods = await getPeriodsForYear(y.id);
        final existingMonths = periods.map((p) => p.monthNumber).toSet();
        final overlap =
            monthNumbers.where((m) => existingMonths.contains(m)).toList();
        if (overlap.isNotEmpty) {
          final names = overlap.map((m) => monthName(m)).join('، ');
          return 'تداخل دوره: ماه‌های ($names) قبلاً برای سال $yearValue ثبت شده‌اند';
        }
      }
    }

    final yearId = await db.into(db.years).insert(YearsCompanion.insert(
          yearValue: yearValue,
          title: title,
          startJy: startJy,
          startJm: startJm,
          startJd: startJd,
          endJy: endJy,
          endJm: endJm,
          endJd: endJd,
        ));

    await db.batch((b) {
      b.insertAll(
        db.periods,
        monthNumbers.map((m) => PeriodsCompanion.insert(
              yearId: yearId,
              monthNumber: m,
              monthName: monthName(m),
              title: '${monthName(m)} $yearValue',
            )),
      );
    });

    return null;
  }

  @override
  Future<bool> deleteYear(int yearId) async {
    final periods = await getPeriodsForYear(yearId);
    final anyOpen = periods.any((p) => p.isOpen);
    if (anyOpen) return false;
    await (db.delete(db.years)..where((y) => y.id.equals(yearId))).go();
    return true;
  }

  @override
  Future<void> setPeriodStatus(int periodId, String status) async {
    await (db.update(db.periods)..where((p) => p.id.equals(periodId)))
        .write(PeriodsCompanion(status: Value(status)));
  }

  @override
  Future<bool> deletePeriod(int periodId) async {
    final period = await (db.select(db.periods)
          ..where((p) => p.id.equals(periodId)))
        .getSingleOrNull();
    if (period == null) return false;

    final all = await getPeriodsForYear(period.yearId);
    if (all.isEmpty) return false;
    final minMonth = all.map((p) => p.monthNumber).reduce((a, b) => a < b ? a : b);
    final maxMonth = all.map((p) => p.monthNumber).reduce((a, b) => a > b ? a : b);

    if (period.monthNumber != minMonth && period.monthNumber != maxMonth) {
      return false;
    }
    await (db.delete(db.periods)..where((p) => p.id.equals(periodId))).go();
    return true;
  }

  @override
  Future<int> periodCountForYear(int yearId) async {
    final periods = await getPeriodsForYear(yearId);
    return periods.length;
  }

  @override
  Future<List<UnitInfo>> getAllUnits() async {
    final rows = await (db.select(db.units)
          ..orderBy([
            (u) => OrderingTerm.asc(u.sortOrder),
            (u) => OrderingTerm.asc(u.id),
          ]))
        .get();
    return rows
        .map((u) => UnitInfo(
              id: u.id,
              parentId: u.parentId,
              name: u.name,
              description: u.description,
              level: u.level,
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
    return db.into(db.units).insert(UnitsCompanion.insert(
          parentId: Value(parentId),
          name: name,
          description: Value(description),
          level: Value(level),
        ));
  }

  @override
  Future<void> updateUnit({
    required int unitId,
    required String name,
    String? description,
  }) async {
    await (db.update(db.units)..where((u) => u.id.equals(unitId))).write(
      UnitsCompanion(name: Value(name), description: Value(description)),
    );
  }

  @override
  Future<bool> deleteUnit(int unitId) async {
    final children = await (db.select(db.units)
          ..where((u) => u.parentId.equals(unitId)))
        .get();
    if (children.isNotEmpty) return false;
    await (db.delete(db.units)..where((u) => u.id.equals(unitId))).go();
    return true;
  }

  @override
  Future<List<ApprovalStepInfo>> getApprovalSteps(int unitId) async {
    final rows = await (db.select(db.approvalSteps)
          ..where((s) => s.unitId.equals(unitId))
          ..orderBy([(s) => OrderingTerm.asc(s.stepOrder)]))
        .get();
    return rows.map(_toApprovalStepInfo).toList();
  }

  ApprovalStepInfo _toApprovalStepInfo(ApprovalStep s) {
    return ApprovalStepInfo(
      id: s.id,
      unitId: s.unitId,
      stepOrder: s.stepOrder,
      approvalType: s.approvalType,
      subjectType: s.subjectType,
      roleId: s.roleId,
      userId: s.userId,
      label: s.label,
    );
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
    final existing = await getApprovalSteps(unitId);
    final nextOrder = existing.isEmpty
        ? 0
        : existing.map((e) => e.stepOrder).reduce((a, b) => a > b ? a : b) + 1;
    await db.into(db.approvalSteps).insert(ApprovalStepsCompanion.insert(
          unitId: unitId,
          stepOrder: Value(nextOrder),
          approvalType: Value(approvalType),
          subjectType: Value(subjectType),
          roleId: Value(roleId),
          userId: Value(userId),
          label: Value(label),
        ));
  }

  @override
  Future<void> deleteApprovalStep(int stepId) async {
    await (db.delete(db.approvalSteps)..where((s) => s.id.equals(stepId)))
        .go();
  }

  @override
  Future<void> moveApprovalStep(int stepId, bool up) async {
    final step = await (db.select(db.approvalSteps)
          ..where((s) => s.id.equals(stepId)))
        .getSingleOrNull();
    if (step == null) return;
    final siblings = await getApprovalSteps(step.unitId);
    final idx = siblings.indexWhere((s) => s.id == stepId);
    if (idx < 0) return;
    final swapWith = up ? idx - 1 : idx + 1;
    if (swapWith < 0 || swapWith >= siblings.length) return;

    final a = siblings[idx];
    final b = siblings[swapWith];
    await (db.update(db.approvalSteps)..where((s) => s.id.equals(a.id)))
        .write(ApprovalStepsCompanion(stepOrder: Value(b.stepOrder)));
    await (db.update(db.approvalSteps)..where((s) => s.id.equals(b.id)))
        .write(ApprovalStepsCompanion(stepOrder: Value(a.stepOrder)));
  }

  @override
  Future<List<ApprovalStepInfo>> getParentApprovalSteps(int unitId) async {
    final combined = <ApprovalStepInfo>[];
    final unit = await (db.select(db.units)..where((u) => u.id.equals(unitId)))
        .getSingleOrNull();
    int? currentId = unit?.parentId;
    while (currentId != null) {
      final steps = await getApprovalSteps(currentId);
      combined.addAll(steps);
      final u = await (db.select(db.units)
            ..where((x) => x.id.equals(currentId!)))
          .getSingleOrNull();
      currentId = u?.parentId;
    }
    return combined;
  }

  @override
  Future<List<ApprovalStepInfo>> getEffectiveApprovalSteps(int unitId) async {
    final combined = <ApprovalStepInfo>[];
    int? currentId = unitId;
    while (currentId != null) {
      final steps = await getApprovalSteps(currentId);
      combined.addAll(steps);
      final unit = await (db.select(db.units)
            ..where((u) => u.id.equals(currentId!)))
          .getSingleOrNull();
      currentId = unit?.parentId;
    }
    return combined;
  }

  Future<List<CollaboratorInfo>> _collaboratorsFor(int activityId) async {
    final query = db.select(db.activityCollaborators).join([
      innerJoin(db.units,
          db.units.id.equalsExp(db.activityCollaborators.collaboratorUnitId)),
    ])
      ..where(db.activityCollaborators.activityId.equals(activityId));
    final rows = await query.get();
    return rows.map((row) {
      final c = row.readTable(db.activityCollaborators);
      final u = row.readTable(db.units);
      return CollaboratorInfo(
          unitId: u.id, unitName: u.name, weight: c.weight);
    }).toList();
  }

  @override
  Future<List<ActivityInfo>> getActivitiesForUnit(int unitId) async {
    final rows = await (db.select(db.activities)
          ..where((a) => a.unitId.equals(unitId))
          ..orderBy([(a) => OrderingTerm.asc(a.id)]))
        .get();
    final result = <ActivityInfo>[];
    for (final a in rows) {
      String? ownerName;
      if (a.ownerUserId != null) {
        final owner = await (db.select(db.users)
              ..where((u) => u.id.equals(a.ownerUserId!)))
            .getSingleOrNull();
        ownerName = owner?.fullName;
      }
      final collabs = await _collaboratorsFor(a.id);
      result.add(ActivityInfo(
        id: a.id,
        unitId: a.unitId,
        activityNumber: a.activityNumber,
        name: a.name,
        activityType: a.activityType,
        weight: a.weight,
        ownerUserId: a.ownerUserId,
        ownerName: ownerName,
        description: a.description,
        collaborators: collabs,
        isActive: a.isActive,
      ));
    }
    return result;
  }

  Future<void> _saveCollaborators(
      int activityId, List<CollaboratorInfo> collaborators) async {
    await (db.delete(db.activityCollaborators)
          ..where((c) => c.activityId.equals(activityId)))
        .go();
    if (collaborators.isNotEmpty) {
      await db.batch((b) {
        b.insertAll(
          db.activityCollaborators,
          collaborators.map((c) => ActivityCollaboratorsCompanion.insert(
                activityId: activityId,
                collaboratorUnitId: c.unitId,
                weight: Value(c.weight),
              )),
        );
      });
    }
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
    final id = await db.into(db.activities).insert(ActivitiesCompanion.insert(
          unitId: unitId,
          activityNumber: Value(activityNumber),
          name: name,
          activityType: Value(activityType),
          weight: Value(weight),
          ownerUserId: Value(ownerUserId),
          description: Value(description),
        ));
    await _saveCollaborators(id, collaborators);
    return id;
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
    await (db.update(db.activities)..where((a) => a.id.equals(activityId)))
        .write(ActivitiesCompanion(
      activityNumber: Value(activityNumber),
      name: Value(name),
      activityType: Value(activityType),
      weight: Value(weight),
      ownerUserId: Value(ownerUserId),
      description: Value(description),
    ));
    await _saveCollaborators(activityId, collaborators);
  }

  @override
  Future<void> deleteActivity(int activityId) async {
    await (db.delete(db.activities)..where((a) => a.id.equals(activityId)))
        .go();
  }

  @override
  Future<void> setActivityActive(int activityId, bool active) async {
    await (db.update(db.activities)..where((a) => a.id.equals(activityId)))
        .write(ActivitiesCompanion(isActive: Value(active)));
  }

  @override
  Future<bool> unitHasActivities(int unitId) async {
    final rows = await (db.select(db.activities)
          ..where((a) => a.unitId.equals(unitId))
          ..limit(1))
        .get();
    return rows.isNotEmpty;
  }

  @override
  Future<int?> activityNumberOwnerUnit(String number, {int? exceptId}) async {
    final rows = await (db.select(db.activities)
          ..where((a) => a.activityNumber.equals(number)))
        .get();
    for (final a in rows) {
      if (exceptId == null || a.id != exceptId) {
        return a.unitId;
      }
    }
    return null;
  }

  @override
  Future<TargetInfo?> getTarget(int activityId, int yearId) async {
    final t = await (db.select(db.targets)
          ..where((x) =>
              x.activityId.equals(activityId) & x.yearId.equals(yearId)))
        .getSingleOrNull();
    if (t == null) return null;

    final query = db.select(db.targetPeriods).join([
      innerJoin(db.periods,
          db.periods.id.equalsExp(db.targetPeriods.periodId)),
    ])
      ..where(db.targetPeriods.targetId.equals(t.id))
      ..orderBy([OrderingTerm.asc(db.periods.monthNumber)]);
    final rows = await query.get();
    final periods = rows.map((row) {
      final tp = row.readTable(db.targetPeriods);
      final p = row.readTable(db.periods);
      return TargetPeriodValue(
        periodId: p.id,
        monthNumber: p.monthNumber,
        monthName: p.monthName,
        targetValue: tp.targetValue,
        isActive: tp.isActive,
      );
    }).toList();

    return TargetInfo(
      id: t.id,
      activityId: t.activityId,
      yearId: t.yearId,
      startValue: t.startValue,
      distributionType: t.distributionType,
      periods: periods,
    );
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
    final existing = await (db.select(db.targets)
          ..where((x) =>
              x.activityId.equals(activityId) & x.yearId.equals(yearId)))
        .getSingleOrNull();

    int targetId;
    if (existing != null) {
      targetId = existing.id;
      await (db.update(db.targets)..where((x) => x.id.equals(targetId)))
          .write(TargetsCompanion(
        startValue: Value(startValue),
        distributionType: Value(distributionType),
      ));
      await (db.delete(db.targetPeriods)
            ..where((x) => x.targetId.equals(targetId)))
          .go();
    } else {
      targetId = await db.into(db.targets).insert(TargetsCompanion.insert(
            activityId: activityId,
            yearId: yearId,
            startValue: Value(startValue),
            distributionType: Value(distributionType),
          ));
    }

    await db.batch((b) {
      b.insertAll(
        db.targetPeriods,
        periodValues.entries.map((e) => TargetPeriodsCompanion.insert(
              targetId: targetId,
              periodId: e.key,
              targetValue: Value(e.value),
              isActive: Value(activeValues?[e.key] ?? true),
            )),
      );
    });
  }

  @override
  Future<void> deleteTarget(int targetId) async {
    await (db.delete(db.targets)..where((x) => x.id.equals(targetId))).go();
  }

  @override
  Future<Set<int>> activityIdsWithTargetInYear(int yearId) async {
    final rows = await (db.select(db.targets)
          ..where((t) => t.yearId.equals(yearId)))
        .get();
    return rows.map((t) => t.activityId).toSet();
  }

  @override
  Future<List<ActivityInfo>> getAllActivities() async {
    final units = await db.select(db.units).get();
    final result = <ActivityInfo>[];
    for (final u in units) {
      result.addAll(await getActivitiesForUnit(u.id));
    }
    return result;
  }

  @override
  Future<List<ActivityInfo>> getActivitiesOwnedBy(int userId) async {
    final rows = await (db.select(db.activities)
          ..where((a) => a.ownerUserId.equals(userId))
          ..orderBy([(a) => OrderingTerm.asc(a.id)]))
        .get();
    final result = <ActivityInfo>[];
    for (final a in rows) {
      final collabs = await _collaboratorsFor(a.id);
      result.add(ActivityInfo(
        id: a.id,
        unitId: a.unitId,
        activityNumber: a.activityNumber,
        name: a.name,
        activityType: a.activityType,
        weight: a.weight,
        ownerUserId: a.ownerUserId,
        description: a.description,
        collaborators: collabs,
        isActive: a.isActive,
      ));
    }
    return result;
  }

  @override
  Future<Map<int, ProgressEntryInfo>> getProgressForActivityYear(
      int activityId, int yearId) async {
    final periods = await getPeriodsForYear(yearId);
    final periodIds = periods.map((p) => p.id).toSet();
    final rows = await (db.select(db.progressEntries)
          ..where((e) => e.activityId.equals(activityId)))
        .get();
    final map = <int, ProgressEntryInfo>{};
    for (final e in rows) {
      if (!periodIds.contains(e.periodId)) continue;
      map[e.periodId] = ProgressEntryInfo(
        id: e.id,
        activityId: e.activityId,
        periodId: e.periodId,
        progressValue: e.progressValue,
        note: e.note,
        status: e.status,
      );
    }
    return map;
  }

  @override
  @override
  Future<void> saveProgress({
    required int activityId,
    required int periodId,
    required double progressValue,
    String? note,
    required int enteredByUserId,
    String? userName,
  }) async {
    final existing = await (db.select(db.progressEntries)
          ..where((e) =>
              e.activityId.equals(activityId) &
              e.periodId.equals(periodId)))
        .getSingleOrNull();
    int entryId;
    double? oldValue;
    if (existing != null) {
      entryId = existing.id;
      oldValue = existing.progressValue; // مقدار قبلی پیش از تغییر
      await (db.update(db.progressEntries)
            ..where((e) => e.id.equals(existing.id)))
          .write(ProgressEntriesCompanion(
        progressValue: Value(progressValue),
        note: Value(note),
        enteredByUserId: Value(enteredByUserId),
        updatedAt: Value(DateTime.now()),
      ));
    } else {
      entryId =
          await db.into(db.progressEntries).insert(ProgressEntriesCompanion.insert(
                activityId: activityId,
                periodId: periodId,
                progressValue: Value(progressValue),
                note: Value(note),
                enteredByUserId: Value(enteredByUserId),
              ));
    }
    // اگر مقدار واقعاً تغییر کرده، تاریخچه‌ی modify با مقدار قبلی و جدید ثبت شود
    final changed =
        oldValue == null || (oldValue - progressValue).abs() > 0.001;
    if (changed) {
      await _addHistory(entryId, 'modify',
          userId: enteredByUserId,
          userName: userName,
          oldValue: oldValue,
          newValue: progressValue,
          note: note);
    } else if (note != null && note.trim().isNotEmpty) {
      await _addHistory(entryId, 'comment',
          userId: enteredByUserId,
          userName: userName,
          newValue: progressValue,
          note: note.trim());
    }
  }

  @override
  Future<void> submitProgress(int activityId, int periodId,
      {int? userId, String? userName}) async {
    final entry = await (db.select(db.progressEntries)
          ..where((e) =>
              e.activityId.equals(activityId) & e.periodId.equals(periodId)))
        .getSingleOrNull();
    if (entry == null) return;
    if (entry.status == 'submitted' || entry.status == 'final') return;

    await (db.update(db.progressEntries)..where((e) => e.id.equals(entry.id)))
        .write(const ProgressEntriesCompanion(
            status: Value('submitted'), currentStepIndex: Value(0)));

    await _addHistory(entry.id, 'submit',
        userId: userId, userName: userName, newValue: entry.progressValue);
  }

  Future<void> _addHistory(
    int progressEntryId,
    String action, {
    int? userId,
    String? userName,
    double? oldValue,
    double? newValue,
    String? note,
  }) async {
    await db.into(db.progressHistory).insert(ProgressHistoryCompanion.insert(
          progressEntryId: progressEntryId,
          userId: Value(userId),
          userName: Value(userName),
          action: action,
          oldValue: Value(oldValue),
          newValue: Value(newValue),
          note: Value(note),
        ));
  }

  @override
  Future<List<PeriodInfo>> getOpenPeriods() async {
    final rows = await (db.select(db.periods)
          ..where((p) => p.status.equals('open'))
          ..orderBy([(p) => OrderingTerm.asc(p.monthNumber)]))
        .get();
    return rows
        .map((p) => PeriodInfo(
              id: p.id,
              yearId: p.yearId,
              monthNumber: p.monthNumber,
              monthName: p.monthName,
              title: p.title,
              status: p.status,
            ))
        .toList();
  }

  @override
  Future<int?> previousPeriodId(int periodId) async {
    final current = await (db.select(db.periods)
          ..where((p) => p.id.equals(periodId)))
        .getSingleOrNull();
    if (current == null) return null;
    final prev = await (db.select(db.periods)
          ..where((p) =>
              p.yearId.equals(current.yearId) &
              p.monthNumber.isSmallerThanValue(current.monthNumber))
          ..orderBy([(p) => OrderingTerm.desc(p.monthNumber)])
          ..limit(1))
        .getSingleOrNull();
    return prev?.id;
  }

  Future<bool> _userMatchesStep(ApprovalStepInfo step, int userId,
      List<String> userRoleCodes) async {
    if (step.subjectType == 'user') {
      return step.userId == userId;
    } else {
      if (step.roleId == null) return false;
      final role = await (db.select(db.roles)
            ..where((r) => r.id.equals(step.roleId!)))
          .getSingleOrNull();
      if (role == null) return false;
      return userRoleCodes.contains(role.code);
    }
  }

  Future<String> _stepHolderName(ApprovalStepInfo step) async {
    if (step.subjectType == 'user' && step.userId != null) {
      final u = await (db.select(db.users)
            ..where((x) => x.id.equals(step.userId!)))
          .getSingleOrNull();
      return u?.fullName ?? 'کاربر';
    } else if (step.roleId != null) {
      final r = await (db.select(db.roles)
            ..where((x) => x.id.equals(step.roleId!)))
          .getSingleOrNull();
      return r != null ? 'نقش: ${r.title}' : 'تأییدکننده';
    }
    return 'تأییدکننده';
  }

  @override
  Future<List<ApprovalQueueItem>> getApprovalQueueForPeriod(
      int periodId, int userId,
      {required bool onlyMyTurn,
      bool showAll = false,
      bool includeInactive = false}) async {
    final roleRows = await _rolesForUser(userId);
    final userRoleCodes = roleRows.map((e) => e.value).toList();

    final period = await (db.select(db.periods)
          ..where((p) => p.id.equals(periodId)))
        .getSingle();
    final yearId = period.yearId;

    final allActivities = await getAllActivities();
    final withTarget = await activityIdsWithTargetInYear(yearId);
    final result = <ApprovalQueueItem>[];

    for (final activity in allActivities) {
      if (!withTarget.contains(activity.id)) continue;
      if (!includeInactive &&
          !await isActivityActiveInPeriod(
              activity.id, periodId, activity.isKpi)) {
        continue;
      }
      final steps = await getEffectiveApprovalSteps(activity.unitId);

      bool userInChain = false;
      for (final s in steps) {
        if (await _userMatchesStep(s, userId, userRoleCodes)) {
          userInChain = true;
          break;
        }
      }
      final isOwner = activity.ownerUserId == userId;
      if (!showAll && !userInChain && !isOwner) continue;

      final entry = await (db.select(db.progressEntries)
            ..where((e) =>
                e.activityId.equals(activity.id) &
                e.periodId.equals(periodId)))
          .getSingleOrNull();

      final ownerName = activity.ownerUserId != null
          ? (await (db.select(db.users)
                  ..where((u) => u.id.equals(activity.ownerUserId!)))
                .getSingleOrNull())
              ?.fullName
          : null;

      double? targetThis;
      final target = await getTarget(activity.id, yearId);
      if (target != null) {
        final t = target.periods.where((p) => p.periodId == periodId);
        targetThis = t.isEmpty ? null : t.first.targetValue;
      }

      String status;
      int currentStepIndex;
      double progressValue;
      String? holderName;
      bool isMyTurn = false;
      int progressEntryId;

      if (entry == null || entry.status == 'draft') {
        status = 'pending_owner';
        currentStepIndex = 0;
        progressValue = entry?.progressValue ?? 0;
        holderName = 'در دست مسئول: ${ownerName ?? "نامشخص"}';
        progressEntryId = entry?.id ?? -1;
      } else if (entry.status == 'final') {
        status = 'final';
        currentStepIndex = entry.currentStepIndex;
        progressValue = entry.progressValue;
        holderName = null;
        progressEntryId = entry.id;
      } else {
        status = 'submitted';
        currentStepIndex = entry.currentStepIndex;
        progressValue = entry.progressValue;
        progressEntryId = entry.id;
        if (steps.isEmpty) {
          holderName = 'تأیید نهایی (بدون زنجیره)';
        } else if (currentStepIndex < steps.length) {
          final currentStep = steps[currentStepIndex];
          holderName = await _stepHolderName(currentStep);
          isMyTurn =
              await _userMatchesStep(currentStep, userId, userRoleCodes);
        }
      }

      if (onlyMyTurn && !isMyTurn) continue;

      result.add(ApprovalQueueItem(
        progressEntryId: progressEntryId,
        activityId: activity.id,
        activityName: activity.name,
        activityNumber: activity.activityNumber,
        unitId: activity.unitId,
        progressValue: progressValue,
        targetThis: targetThis,
        weight: activity.weight,
        status: status,
        currentStepIndex: currentStepIndex,
        currentHolderName: holderName,
        isMyTurn: isMyTurn,
      ));
    }

    return result;
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
    final entry = await (db.select(db.progressEntries)
          ..where((e) => e.id.equals(progressEntryId)))
        .getSingleOrNull();
    if (entry == null) return;

    final activity = await (db.select(db.activities)
          ..where((a) => a.id.equals(entry.activityId)))
        .getSingleOrNull();
    if (activity == null) return;

    final steps = await getEffectiveApprovalSteps(activity.unitId);

    final oldValue = entry.progressValue;
    final changed = (oldValue - newValue).abs() > 0.001;

    if (changed) {
      await _addHistory(progressEntryId, 'modify',
          userId: userId,
          userName: userName,
          oldValue: oldValue,
          newValue: newValue,
          note: note);
    }
    await _addHistory(progressEntryId, 'approve',
        userId: userId, userName: userName, note: note);

    final nextStep = stepIndex + 1;
    final isFinal = nextStep >= steps.length;

    await (db.update(db.progressEntries)
          ..where((e) => e.id.equals(progressEntryId)))
        .write(ProgressEntriesCompanion(
      progressValue: Value(newValue),
      currentStepIndex: Value(isFinal ? stepIndex : nextStep),
      status: Value(isFinal ? 'final' : 'submitted'),
      updatedAt: Value(DateTime.now()),
    ));

    if (isFinal) {
      await _addHistory(progressEntryId, 'final',
          userId: userId, userName: userName, newValue: newValue);
    }
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
    final entry = await (db.select(db.progressEntries)
          ..where((e) => e.id.equals(progressEntryId)))
        .getSingleOrNull();
    if (entry == null) return;

    if (toOwner || stepIndex <= 0) {
      await (db.update(db.progressEntries)
            ..where((e) => e.id.equals(progressEntryId)))
          .write(ProgressEntriesCompanion(
        status: const Value('draft'),
        currentStepIndex: const Value(0),
        updatedAt: Value(DateTime.now()),
      ));
      await _addHistory(progressEntryId, 'reject_owner',
          userId: userId, userName: userName, note: note);
    } else {
      await (db.update(db.progressEntries)
            ..where((e) => e.id.equals(progressEntryId)))
          .write(ProgressEntriesCompanion(
        status: const Value('submitted'),
        currentStepIndex: Value(stepIndex - 1),
        updatedAt: Value(DateTime.now()),
      ));
      await _addHistory(progressEntryId, 'reject_back',
          userId: userId, userName: userName, note: note);
    }
  }

  @override
  Future<void> reopenFinalProgress({
    required int progressEntryId,
    required int userId,
    required String userName,
    String? note,
  }) async {
    final entry = await (db.select(db.progressEntries)
          ..where((e) => e.id.equals(progressEntryId)))
        .getSingleOrNull();
    if (entry == null) return;
    if (entry.status != 'final') return;

    final activity = await (db.select(db.activities)
          ..where((a) => a.id.equals(entry.activityId)))
        .getSingleOrNull();
    if (activity == null) return;

    final steps = await getEffectiveApprovalSteps(activity.unitId);
    final lastStep = steps.isEmpty ? 0 : steps.length - 1;

    await (db.update(db.progressEntries)
          ..where((e) => e.id.equals(progressEntryId)))
        .write(ProgressEntriesCompanion(
      status: const Value('submitted'),
      currentStepIndex: Value(lastStep),
      updatedAt: Value(DateTime.now()),
    ));
    await _addHistory(progressEntryId, 'reopen',
        userId: userId, userName: userName, note: note);
  }

  @override
  Future<List<ProgressHistoryItem>> getProgressHistory(
      int progressEntryId) async {
    final rows = await (db.select(db.progressHistory)
          ..where((h) => h.progressEntryId.equals(progressEntryId))
          ..orderBy([(h) => OrderingTerm.asc(h.createdAt)]))
        .get();
    return rows
        .map((h) => ProgressHistoryItem(
              action: h.action,
              userName: h.userName,
              oldValue: h.oldValue,
              newValue: h.newValue,
              note: h.note,
              createdAt: h.createdAt,
            ))
        .toList();
  }

  @override
  Future<List<UnitInfo>> getAccessibleUnits(int userId) async {
    final roleRows = await _rolesForUser(userId);
    final codes = roleRows.map((e) => e.value).toList();
    final isAdmin = codes.contains('super_admin') ||
        codes.contains('admin') ||
        codes.contains('admin2');

    final allUnits = await getAllUnits();
    if (isAdmin) return allUnits;

    final all = await getAllActivities();
    final accessibleIds = <int>{};
    for (final a in all) {
      if (a.ownerUserId == userId) {
        accessibleIds.add(a.unitId);
        continue;
      }
      final steps = await getEffectiveApprovalSteps(a.unitId);
      for (final s in steps) {
        if (await _userMatchesStep(s, userId, codes)) {
          accessibleIds.add(a.unitId);
          break;
        }
      }
    }
    return allUnits.where((u) => accessibleIds.contains(u.id)).toList();
  }

  @override
  Future<bool> isActivityActiveInPeriod(
      int activityId, int periodId, bool isKpi) async {
    final act = await (db.select(db.activities)
          ..where((a) => a.id.equals(activityId)))
        .getSingleOrNull();
    if (act == null || !act.isActive) return false;

    final period = await (db.select(db.periods)
          ..where((p) => p.id.equals(periodId)))
        .getSingleOrNull();
    if (period == null) return false;
    final target = await getTarget(activityId, period.yearId);
    if (target == null) return false;

    final thisP =
        target.periods.where((p) => p.periodId == periodId).toList();
    if (thisP.isEmpty) return false;
    final tp = thisP.first;

    if (isKpi) {
      return tp.isActive;
    } else {
      if (!tp.isActive) return false;
      if (tp.targetValue <= 0) return false;

      // ماه‌های قبل را از نزدیک‌ترین به دورترین مرتب می‌کنیم
      final prevPeriods = target.periods
          .where((p) => p.monthNumber < tp.monthNumber)
          .toList()
        ..sort((a, b) => b.monthNumber.compareTo(a.monthNumber));

      // آخرین ماهی که پیشرفت واقعی ثبت شده را پیدا می‌کنیم.
      // پروژه فقط وقتی «تمام» است که در آن ماه هم تارگت >=۱۰۰ و هم پیشرفت >=۱۰۰ باشد.
      for (final pp in prevPeriods) {
        final entry = await (db.select(db.progressEntries)
              ..where((e) =>
                  e.activityId.equals(activityId) &
                  e.periodId.equals(pp.periodId)))
            .getSingleOrNull();
        if (entry != null) {
          if (entry.progressValue >= 100 && pp.targetValue >= 100) {
            return false; // پروژه واقعاً تمام شده
          }
          break; // آخرین پیشرفت واقعی همین بود؛ تمام نشده پس فعال است
        }
      }
      return true;
    }
  }

  @override
  Future<DashboardStats> getDashboardStats({
    required int periodId,
    int? ownerUserId,
    int? filterUnitId,
  }) async {
    final period = await (db.select(db.periods)
          ..where((p) => p.id.equals(periodId)))
        .getSingle();
    final yearId = period.yearId;

    List<ActivityInfo> activities;
    if (ownerUserId != null) {
      final all = await getAllActivities();
      final roleRows = await _rolesForUser(ownerUserId);
      final userRoleCodes = roleRows.map((e) => e.value).toList();
      final filtered = <ActivityInfo>[];
      for (final a in all) {
        if (a.ownerUserId == ownerUserId) {
          filtered.add(a);
          continue;
        }
        final steps = await getEffectiveApprovalSteps(a.unitId);
        bool inChain = false;
        for (final s in steps) {
          if (await _userMatchesStep(s, ownerUserId, userRoleCodes)) {
            inChain = true;
            break;
          }
        }
        if (inChain) filtered.add(a);
      }
      activities = filtered;
    } else {
      activities = await getAllActivities();
    }

    if (filterUnitId != null) {
      activities =
          activities.where((a) => a.unitId == filterUnitId).toList();
    }

    final withTarget = await activityIdsWithTargetInYear(yearId);
    activities =
        activities.where((a) => withTarget.contains(a.id)).toList();

    final activeFiltered = <ActivityInfo>[];
    for (final a in activities) {
      if (await isActivityActiveInPeriod(a.id, periodId, a.isKpi)) {
        activeFiltered.add(a);
      }
    }
    activities = activeFiltered;

    int draft = 0, submitted = 0, finalC = 0, notStarted = 0;
    double progressSum = 0;
    int progressCount = 0;

    final unitAgg = <int, List<double>>{};
    final unitTargetAgg = <int, List<double>>{};
    final unitNames = <int, String>{};
    final unitCounts = <int, int>{};
    final unitWeightedP = <int, double>{};
    final unitWeightedT = <int, double>{};
    final unitWeightSum = <int, double>{};
    final activityRows = <ActivityProgressRow>[];

    for (final a in activities) {
      final entry = await (db.select(db.progressEntries)
            ..where((e) =>
                e.activityId.equals(a.id) & e.periodId.equals(periodId)))
          .getSingleOrNull();

      String status;
      if (entry == null) {
        status = 'not_started';
        notStarted++;
      } else if (entry.status == 'draft') {
        status = 'draft';
        draft++;
      } else if (entry.status == 'submitted') {
        status = 'submitted';
        submitted++;
      } else {
        status = 'final';
        finalC++;
      }

      final pv = entry?.progressValue ?? 0;
      progressSum += pv;
      progressCount++;

      double targetThis = 0;
      final target = await getTarget(a.id, yearId);
      if (target != null) {
        final t = target.periods.where((p) => p.periodId == periodId);
        targetThis = t.isEmpty ? 0 : t.first.targetValue;
      } else if (a.isKpi) {
        targetThis = 100;
      }

      final w = a.weight;
      unitAgg.putIfAbsent(a.unitId, () => []).add(pv);
      unitTargetAgg.putIfAbsent(a.unitId, () => []).add(targetThis);
      unitWeightedP[a.unitId] = (unitWeightedP[a.unitId] ?? 0) + pv * w;
      unitWeightedT[a.unitId] = (unitWeightedT[a.unitId] ?? 0) + targetThis * w;
      unitWeightSum[a.unitId] = (unitWeightSum[a.unitId] ?? 0) + w;
      unitCounts[a.unitId] = (unitCounts[a.unitId] ?? 0) + 1;
      if (!unitNames.containsKey(a.unitId)) {
        final u = await (db.select(db.units)
              ..where((x) => x.id.equals(a.unitId)))
            .getSingleOrNull();
        unitNames[a.unitId] = u?.name ?? '—';
      }

      activityRows.add(ActivityProgressRow(
        activityId: a.id,
        activityName: a.name,
        activityNumber: a.activityNumber,
        unitId: a.unitId,
        unitName: unitNames[a.unitId] ?? '—',
        progress: pv,
        target: targetThis,
        weight: w,
        status: status,
      ));
    }

    final unitRows = <UnitProgressRow>[];
    for (final uid in unitAgg.keys) {
      final progs = unitAgg[uid]!;
      final targs = unitTargetAgg[uid]!;
      final avgP = progs.isEmpty
          ? 0.0
          : progs.reduce((a, b) => a + b) / progs.length;
      final avgT = targs.isEmpty
          ? 0.0
          : targs.reduce((a, b) => a + b) / targs.length;
      final wSum = unitWeightSum[uid] ?? 0;
      final wP = wSum == 0 ? avgP : (unitWeightedP[uid] ?? 0) / wSum;
      final wT = wSum == 0 ? avgT : (unitWeightedT[uid] ?? 0) / wSum;
      unitRows.add(UnitProgressRow(
        unitId: uid,
        unitName: unitNames[uid] ?? '—',
        activityCount: unitCounts[uid] ?? 0,
        avgProgress: avgP,
        avgTarget: avgT,
        weightedProgress: wP,
        weightedTarget: wT,
      ));
    }
    unitRows.sort((a, b) => b.avgProgress.compareTo(a.avgProgress));

    return DashboardStats(
      totalActivities: activities.length,
      draftCount: draft,
      submittedCount: submitted,
      finalCount: finalC,
      notStartedCount: notStarted,
      avgProgress: progressCount == 0 ? 0 : progressSum / progressCount,
      unitRows: unitRows,
      activityRows: activityRows,
    );
  }

  Future<String> _unitFullPath(int unitId) async {
    final parts = await _unitPathParts(unitId);
    return parts.join(' ‹ ');
  }

  Future<List<String>> _unitPathParts(int unitId) async {
    final parts = <String>[];
    int? id = unitId;
    int guard = 0;
    while (id != null && guard < 10) {
      final u = await (db.select(db.units)..where((x) => x.id.equals(id!)))
          .getSingleOrNull();
      if (u == null) break;
      parts.insert(0, u.name);
      id = u.parentId;
      guard++;
    }
    return parts;
  }

  @override
  Future<List<ReportRow>> getReportRows({
    required int yearId,
    int? periodId,
    int? ownerUserId,
    int? filterUnitId,
    bool includeInactive = false,
    String typeFilter = 'all',
  }) async {
    List<ActivityInfo> activities;
    if (ownerUserId != null) {
      final all = await getAllActivities();
      final roleRows = await _rolesForUser(ownerUserId);
      final codes = roleRows.map((e) => e.value).toList();
      final filtered = <ActivityInfo>[];
      for (final a in all) {
        if (a.ownerUserId == ownerUserId) {
          filtered.add(a);
          continue;
        }
        final steps = await getEffectiveApprovalSteps(a.unitId);
        for (final s in steps) {
          if (await _userMatchesStep(s, ownerUserId, codes)) {
            filtered.add(a);
            break;
          }
        }
      }
      activities = filtered;
    } else {
      activities = await getAllActivities();
    }

    if (filterUnitId != null) {
      activities =
          activities.where((a) => a.unitId == filterUnitId).toList();
    }
    if (typeFilter == 'kpi') {
      activities = activities.where((a) => a.isKpi).toList();
    } else if (typeFilter == 'project') {
      activities = activities.where((a) => a.isProject).toList();
    }

    final withTarget = await activityIdsWithTargetInYear(yearId);
    activities =
        activities.where((a) => withTarget.contains(a.id)).toList();

    final periods = await getPeriodsForYear(yearId);
    final result = <ReportRow>[];

    for (final a in activities) {
      final unitParts = await _unitPathParts(a.unitId);
      final unitRoot = unitParts.isNotEmpty ? unitParts[0] : '';
      final unitMid = unitParts.length > 1 ? unitParts[1] : '';
      final unitLeaf = unitParts.length > 2 ? unitParts[2] : '';
      final target = await getTarget(a.id, yearId);

      double targetVal = 0;
      double progressVal = 0;
      String status = 'not_started';
      bool active;

      if (periodId != null) {
        active = await isActivityActiveInPeriod(a.id, periodId, a.isKpi);
        if (!active && !includeInactive) continue;
        if (target != null) {
          final t = target.periods.where((p) => p.periodId == periodId);
          targetVal = t.isEmpty ? 0 : t.first.targetValue;
        }
        final entry = await (db.select(db.progressEntries)
              ..where((e) =>
                  e.activityId.equals(a.id) & e.periodId.equals(periodId)))
            .getSingleOrNull();
        progressVal = entry?.progressValue ?? 0;
        status = entry?.status ?? 'not_started';
      } else {
        // کل سال: فعال یعنی حداقل در یک ماه فعال باشد
        bool anyActiveMonth = false;
        if (a.isActive) {
          for (final p in periods) {
            if (await isActivityActiveInPeriod(a.id, p.id, a.isKpi)) {
              anyActiveMonth = true;
              break;
            }
          }
        }
        active = anyActiveMonth;
        if (!active && !includeInactive) continue;
        if (a.isProject) {
          // پروژه: آخرین تارگت و آخرین پیشرفت ثبت‌شده
          if (target != null && target.periods.isNotEmpty) {
            final sorted = [...target.periods]
              ..sort((x, y) => y.monthNumber.compareTo(x.monthNumber));
            targetVal = sorted.first.targetValue;
          }
          double lastProg = 0;
          String lastStatus = 'not_started';
          final ordered = [...periods]
            ..sort((x, y) => x.monthNumber.compareTo(y.monthNumber));
          for (final p in ordered) {
            final entry = await (db.select(db.progressEntries)
                  ..where((e) =>
                      e.activityId.equals(a.id) &
                      e.periodId.equals(p.id)))
                .getSingleOrNull();
            if (entry != null && entry.progressValue > 0) {
              lastProg = entry.progressValue;
              lastStatus = entry.status;
            }
          }
          progressVal = lastProg;
          status = lastStatus;
        } else {
          // KPI: میانگین ماه‌های فعال
          double sumP = 0;
          double sumT = 0;
          int cnt = 0;
          for (final p in periods) {
            final act =
                await isActivityActiveInPeriod(a.id, p.id, true);
            if (!act) continue;
            cnt++;
            sumT += 100;
            final entry = await (db.select(db.progressEntries)
                  ..where((e) =>
                      e.activityId.equals(a.id) &
                      e.periodId.equals(p.id)))
                .getSingleOrNull();
            sumP += entry?.progressValue ?? 0;
          }
          targetVal = cnt == 0 ? 0 : sumT / cnt;
          progressVal = cnt == 0 ? 0 : sumP / cnt;
          status = 'kpi';
        }
      }

      final achievement =
          targetVal == 0 ? 0.0 : (progressVal / targetVal * 100);

      result.add(ReportRow(
        activityNumber: a.activityNumber ?? '',
        activityName: a.name,
        unitRoot: unitRoot,
        unitMid: unitMid,
        unitLeaf: unitLeaf,
        type: a.isProject ? 'پروژه' : 'KPI',
        weight: a.weight,
        target: targetVal,
        progress: progressVal,
        achievement: achievement,
        status: status,
        isActive: active,
      ));
    }

    result.sort((a, b) => a.activityNumber.compareTo(b.activityNumber));
    return result;
  }
}