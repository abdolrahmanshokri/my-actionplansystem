import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Roles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 1, max: 50)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  IntColumn get level => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {code},
      ];
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 1, max: 100)();
  TextColumn get fullName => text().withLength(min: 1, max: 200)();
  TextColumn get email => text().nullable()();
  TextColumn get authType => text().withDefault(const Constant('local'))();
  TextColumn get passwordHash => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {username},
      ];
}

class UserRoles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  IntColumn get roleId =>
      integer().references(Roles, #id, onDelete: KeyAction.cascade)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, roleId},
      ];
}

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().withLength(min: 1, max: 100)();
  TextColumn get value => text().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {key},
      ];
}

class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();
  TextColumn get token => text()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {token},
      ];
}

class Years extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get yearValue => integer()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  IntColumn get startJy => integer()();
  IntColumn get startJm => integer()();
  IntColumn get startJd => integer()();
  IntColumn get endJy => integer()();
  IntColumn get endJm => integer()();
  IntColumn get endJd => integer()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class Periods extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get yearId =>
      integer().references(Years, #id, onDelete: KeyAction.cascade)();
  IntColumn get monthNumber => integer()();
  TextColumn get monthName => text().withLength(min: 1, max: 50)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get status => text().withDefault(const Constant('closed'))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parentId => integer().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().nullable()();
  IntColumn get level => integer().withDefault(const Constant(1))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class ApprovalSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get unitId =>
      integer().references(Units, #id, onDelete: KeyAction.cascade)();
  IntColumn get stepOrder => integer().withDefault(const Constant(0))();
  TextColumn get approvalType => text().withDefault(const Constant('or'))();
  TextColumn get subjectType => text().withDefault(const Constant('role'))();
  IntColumn get roleId => integer().nullable()();
  IntColumn get userId => integer().nullable()();
  TextColumn get label => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class Activities extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get unitId =>
      integer().references(Units, #id, onDelete: KeyAction.cascade)();
  TextColumn get activityNumber => text().nullable()();
  TextColumn get name => text().withLength(min: 1, max: 300)();
  TextColumn get activityType => text().withDefault(const Constant('project'))();
  RealColumn get weight => real().withDefault(const Constant(0))();
  IntColumn get ownerUserId => integer().nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class ActivityCollaborators extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get activityId =>
      integer().references(Activities, #id, onDelete: KeyAction.cascade)();
  IntColumn get collaboratorUnitId =>
      integer().references(Units, #id, onDelete: KeyAction.cascade)();
  RealColumn get weight => real().withDefault(const Constant(0))();
}

class Targets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get activityId =>
      integer().references(Activities, #id, onDelete: KeyAction.cascade)();
  IntColumn get yearId =>
      integer().references(Years, #id, onDelete: KeyAction.cascade)();
  RealColumn get startValue => real().withDefault(const Constant(0))();
  TextColumn get distributionType =>
      text().withDefault(const Constant('uniform'))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {activityId, yearId},
      ];
}

class TargetPeriods extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get targetId =>
      integer().references(Targets, #id, onDelete: KeyAction.cascade)();
  IntColumn get periodId =>
      integer().references(Periods, #id, onDelete: KeyAction.cascade)();
  RealColumn get targetValue => real().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class ProgressEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get activityId =>
      integer().references(Activities, #id, onDelete: KeyAction.cascade)();
  IntColumn get periodId =>
      integer().references(Periods, #id, onDelete: KeyAction.cascade)();
  RealColumn get progressValue => real().withDefault(const Constant(0))();
  TextColumn get note => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  IntColumn get currentStepIndex => integer().withDefault(const Constant(0))();
  IntColumn get enteredByUserId => integer().nullable()();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {activityId, periodId},
      ];
}

class ProgressHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get progressEntryId =>
      integer().references(ProgressEntries, #id, onDelete: KeyAction.cascade)();
  IntColumn get userId => integer().nullable()();
  TextColumn get userName => text().nullable()();
  TextColumn get action => text()();
  RealColumn get oldValue => real().nullable()();
  RealColumn get newValue => real().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class AuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().nullable()();
  TextColumn get action => text()();
  TextColumn get details => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(
  tables: [
    Roles,
    Users,
    UserRoles,
    AppSettings,
    Sessions,
    Years,
    Periods,
    Units,
    ApprovalSteps,
    Activities,
    ActivityCollaborators,
    Targets,
    TargetPeriods,
    ProgressEntries,
    ProgressHistory,
    AuditLog
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedInitialData();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(years);
            await m.createTable(periods);
          }
          if (from < 3) {
            await m.createTable(units);
          }
          if (from < 4) {
            await m.createTable(approvalSteps);
          }
          if (from < 5) {
            await m.createTable(activities);
            await m.createTable(activityCollaborators);
          }
          if (from < 6) {
            await m.createTable(targets);
            await m.createTable(targetPeriods);
          }
          if (from < 7) {
            await m.createTable(progressEntries);
          }
          if (from < 8) {
            await m.addColumn(
                progressEntries, progressEntries.currentStepIndex);
            await m.createTable(progressHistory);
          }
          if (from < 9) {
            await m.addColumn(targetPeriods, targetPeriods.isActive);
          }
          if (from < 10) {
            await m.addColumn(activities, activities.isActive);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> _seedInitialData() async {
    await batch((b) {
      b.insertAll(roles, [
        RolesCompanion.insert(
            code: 'super_admin', title: 'سوپر ادمین', level: const Value(100)),
        RolesCompanion.insert(
            code: 'admin', title: 'ادمین ارشد', level: const Value(80)),
        RolesCompanion.insert(
            code: 'admin2',
            title: 'ادمین سطح ۲ اکشن‌پلن',
            level: const Value(50)),
        RolesCompanion.insert(
            code: 'action_user',
            title: 'کاربر اکشن‌پلن',
            level: const Value(10)),
      ]);
    });

    final superAdminRoleId = await (select(roles)
          ..where((r) => r.code.equals('super_admin')))
        .getSingle()
        .then((r) => r.id);
    final actionUserRoleId = await (select(roles)
          ..where((r) => r.code.equals('action_user')))
        .getSingle()
        .then((r) => r.id);

    final abId = await into(users).insert(UsersCompanion.insert(
      username: 'ab.shokri',
      fullName: 'عبدالرحمن شکری',
      email: const Value('ab.shokri@jpcomplex.com'),
    ));
    final yId = await into(users).insert(UsersCompanion.insert(
      username: 'y.nikakhtar',
      fullName: 'مهندس نیک‌اختر',
      email: const Value('y.nikakhtar@jpcomplex.com'),
    ));
    final mId = await into(users).insert(UsersCompanion.insert(
      username: 'm.amirsadat',
      fullName: 'محسن امیرسادات',
      email: const Value('m.amirsadat@jpcomplex.com'),
    ));
    final eId = await into(users).insert(UsersCompanion.insert(
      username: 'e.aradmehr',
      fullName: 'اسحاق آرادمهر',
      email: const Value('e.aradmehr@jpcomplex.com'),
    ));

    await batch((b) {
      b.insertAll(userRoles, [
        UserRolesCompanion.insert(userId: abId, roleId: superAdminRoleId),
        UserRolesCompanion.insert(userId: yId, roleId: actionUserRoleId),
        UserRolesCompanion.insert(userId: mId, roleId: actionUserRoleId),
        UserRolesCompanion.insert(userId: eId, roleId: actionUserRoleId),
      ]);
    });

    await batch((b) {
      b.insertAll(appSettings, [
        AppSettingsCompanion.insert(key: 'db_type', value: const Value('drift')),
        AppSettingsCompanion.insert(
            key: 'developer_mode', value: const Value('true')),
        AppSettingsCompanion.insert(
            key: 'sql_server_connection', value: const Value('')),
        AppSettingsCompanion.insert(key: 'ad_domain', value: const Value('')),
        AppSettingsCompanion.insert(key: 'ad_ou', value: const Value('')),
        AppSettingsCompanion.insert(key: 'sso_url', value: const Value('')),
      ]);
    });
  }

  Future<void> resetDatabase() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
    await _seedInitialData();
  }
}

QueryExecutor _open() {
  return driftDatabase(
    name: 'actionplan_db',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}