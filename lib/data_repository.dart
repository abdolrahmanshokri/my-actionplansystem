class YearInfo {
  final int id;
  final int yearValue;
  final String title;
  final int startJy, startJm, startJd;
  final int endJy, endJm, endJd;
  const YearInfo({
    required this.id,
    required this.yearValue,
    required this.title,
    required this.startJy,
    required this.startJm,
    required this.startJd,
    required this.endJy,
    required this.endJm,
    required this.endJd,
  });
}

class PeriodInfo {
  final int id;
  final int yearId;
  final int monthNumber;
  final String monthName;
  final String title;
  final String status;
  const PeriodInfo({
    required this.id,
    required this.yearId,
    required this.monthNumber,
    required this.monthName,
    required this.title,
    required this.status,
  });
  bool get isOpen => status == 'open';
}

class ActivityProgressRow {
  final int activityId;
  final String activityName;
  final String? activityNumber;
  final int unitId;
  final String unitName;
  final double progress;
  final double target;
  final double weight;
  final String status;
  const ActivityProgressRow({
    required this.activityId,
    required this.activityName,
    this.activityNumber,
    required this.unitId,
    required this.unitName,
    required this.progress,
    required this.target,
    required this.weight,
    required this.status,
  });
}

class DashboardStats {
  final int totalActivities;
  final int draftCount;
  final int submittedCount;
  final int finalCount;
  final int notStartedCount;
  final double avgProgress;
  final List<UnitProgressRow> unitRows;
  final List<ActivityProgressRow> activityRows;
  const DashboardStats({
    required this.totalActivities,
    required this.draftCount,
    required this.submittedCount,
    required this.finalCount,
    required this.notStartedCount,
    required this.avgProgress,
    required this.unitRows,
    required this.activityRows,
  });
}

class UnitProgressRow {
  final int unitId;
  final String unitName;
  final int activityCount;
  final double avgProgress;
  final double avgTarget;
  final double weightedProgress;
  final double weightedTarget;
  const UnitProgressRow({
    required this.unitId,
    required this.unitName,
    required this.activityCount,
    required this.avgProgress,
    required this.avgTarget,
    required this.weightedProgress,
    required this.weightedTarget,
  });
}

class ReportRow {
  final String activityNumber;
  final String activityName;
  final String unitRoot;
  final String unitMid;
  final String unitLeaf;
  final String type;
  final double weight;
  final double target;
  final double progress;
  final double achievement;
  final String status;
  final bool isActive;
  const ReportRow({
    required this.activityNumber,
    required this.activityName,
    required this.unitRoot,
    required this.unitMid,
    required this.unitLeaf,
    required this.type,
    required this.weight,
    required this.target,
    required this.progress,
    required this.achievement,
    required this.status,
    required this.isActive,
  });
}

class ProgressHistoryItem {
  final String action;
  final String? userName;
  final double? oldValue;
  final double? newValue;
  final String? note;
  final DateTime createdAt;
  const ProgressHistoryItem({
    required this.action,
    this.userName,
    this.oldValue,
    this.newValue,
    this.note,
    required this.createdAt,
  });
}

class ApprovalQueueItem {
  final int progressEntryId;
  final int activityId;
  final String activityName;
  final String? activityNumber;
  final int unitId;
  final double progressValue;
  final double? targetThis;
  final double weight;
  final String status;
  final int currentStepIndex;
  final String? currentHolderName;
  final bool isMyTurn;
  const ApprovalQueueItem({
    required this.progressEntryId,
    required this.activityId,
    required this.activityName,
    this.activityNumber,
    required this.unitId,
    required this.progressValue,
    this.targetThis,
    required this.weight,
    required this.status,
    required this.currentStepIndex,
    this.currentHolderName,
    required this.isMyTurn,
  });
}

class ProgressEntryInfo {
  final int? id;
  final int activityId;
  final int periodId;
  final double progressValue;
  final String? note;
  final String status;
  const ProgressEntryInfo({
    this.id,
    required this.activityId,
    required this.periodId,
    required this.progressValue,
    this.note,
    this.status = 'draft',
  });
  bool get isDraft => status == 'draft';
  bool get isSubmitted => status == 'submitted';
  bool get isLocked => status != 'draft';
}

class TargetPeriodValue {
  final int periodId;
  final int monthNumber;
  final String monthName;
  final double targetValue;
  final bool isActive;
  const TargetPeriodValue({
    required this.periodId,
    required this.monthNumber,
    required this.monthName,
    required this.targetValue,
    this.isActive = true,
  });
}

class TargetInfo {
  final int id;
  final int activityId;
  final int yearId;
  final double startValue;
  final String distributionType;
  final List<TargetPeriodValue> periods;
  const TargetInfo({
    required this.id,
    required this.activityId,
    required this.yearId,
    required this.startValue,
    required this.distributionType,
    this.periods = const [],
  });
}

class CollaboratorInfo {
  final int unitId;
  final String unitName;
  final double weight;
  const CollaboratorInfo(
      {required this.unitId, required this.unitName, required this.weight});
}

class ActivityInfo {
  final int id;
  final int unitId;
  final String? activityNumber;
  final String name;
  final String activityType;
  final double weight;
  final int? ownerUserId;
  final String? ownerName;
  final String? description;
  final List<CollaboratorInfo> collaborators;
  final bool isActive;
  const ActivityInfo({
    required this.id,
    required this.unitId,
    this.activityNumber,
    required this.name,
    required this.activityType,
    required this.weight,
    this.ownerUserId,
    this.ownerName,
    this.description,
    this.collaborators = const [],
    this.isActive = true,
  });
  bool get isProject => activityType == 'project';
  bool get isKpi => activityType == 'kpi';
}

class ApprovalStepInfo {
  final int id;
  final int unitId;
  final int stepOrder;
  final String approvalType;
  final String subjectType;
  final int? roleId;
  final int? userId;
  final String? label;
  const ApprovalStepInfo({
    required this.id,
    required this.unitId,
    required this.stepOrder,
    required this.approvalType,
    required this.subjectType,
    this.roleId,
    this.userId,
    this.label,
  });
}

class UnitInfo {
  final int id;
  final int? parentId;
  final String name;
  final String? description;
  final int level;
  final int sortOrder;
  const UnitInfo({
    required this.id,
    this.parentId,
    required this.name,
    this.description,
    required this.level,
    required this.sortOrder,
  });
}

class RoleInfo {
  final int id;
  final String code;
  final String title;
  final int level;
  const RoleInfo(
      {required this.id,
      required this.code,
      required this.title,
      required this.level});
}

class AppUser {
  final int id;
  final String username;
  final String fullName;
  final String? email;
  final List<String> roleCodes;
  final List<int> roleIds;
  final bool isActive;

  const AppUser({
    required this.id,
    required this.username,
    required this.fullName,
    this.email,
    this.roleCodes = const [],
    this.roleIds = const [],
    this.isActive = true,
  });

  bool hasRole(String code) => roleCodes.contains(code);
  bool get isSuperAdmin => hasRole('super_admin');
  bool get isAdmin => hasRole('admin') || isSuperAdmin;
  bool get isAdmin2 => hasRole('admin2');
  bool get isActionUser => hasRole('action_user');
}

abstract class DataRepository {
  Future<void> initialize();

  Future<bool> isDatabaseReady();

  Future<void> createOrMigrate();

  Future<void> resetDatabase();

  Future<List<int>> backupDatabase();

  Future<List<AppUser>> getAllUsers();

  Future<AppUser?> getUserByUsername(String username);

  Future<List<RoleInfo>> getAllRoles();

  Future<int> createUser({
    required String username,
    required String fullName,
    String? email,
    String authType,
    String? password,
    required List<int> roleIds,
  });

  Future<void> updateUser({
    required int userId,
    required String fullName,
    String? email,
    bool? isActive,
    List<int>? roleIds,
  });

  Future<void> deleteUser(int userId);

  Future<void> setUserPassword(int userId, String newPassword);

  Future<AppUser?> authenticateLocal(String username, String password);

  Future<void> recordLogin(int userId);

  Future<String?> getSetting(String key);

  Future<void> setSetting(String key, String value);

  Future<List<YearInfo>> getAllYears();

  Future<List<PeriodInfo>> getPeriodsForYear(int yearId);

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
  });

  Future<bool> deleteYear(int yearId);

  Future<void> setPeriodStatus(int periodId, String status);

  Future<bool> deletePeriod(int periodId);

  Future<int> periodCountForYear(int yearId);

  Future<List<UnitInfo>> getAllUnits();

  Future<int> createUnit({
    int? parentId,
    required String name,
    String? description,
    required int level,
  });

  Future<void> updateUnit({
    required int unitId,
    required String name,
    String? description,
  });

  Future<bool> deleteUnit(int unitId);

  Future<List<ApprovalStepInfo>> getApprovalSteps(int unitId);

  Future<void> addApprovalStep({
    required int unitId,
    required String approvalType,
    required String subjectType,
    int? roleId,
    int? userId,
    String? label,
  });

  Future<void> deleteApprovalStep(int stepId);

  Future<void> moveApprovalStep(int stepId, bool up);

  Future<List<ApprovalStepInfo>> getEffectiveApprovalSteps(int unitId);

  Future<List<ApprovalStepInfo>> getParentApprovalSteps(int unitId);

  Future<List<ActivityInfo>> getActivitiesForUnit(int unitId);

  Future<int> createActivity({
    required int unitId,
    String? activityNumber,
    required String name,
    required String activityType,
    required double weight,
    int? ownerUserId,
    String? description,
    required List<CollaboratorInfo> collaborators,
  });

  Future<void> updateActivity({
    required int activityId,
    String? activityNumber,
    required String name,
    required String activityType,
    required double weight,
    int? ownerUserId,
    String? description,
    required List<CollaboratorInfo> collaborators,
  });

  Future<void> deleteActivity(int activityId);

  Future<void> setActivityActive(int activityId, bool active);

  Future<bool> unitHasActivities(int unitId);

  Future<int?> activityNumberOwnerUnit(String number, {int? exceptId});

  Future<TargetInfo?> getTarget(int activityId, int yearId);

  Future<void> saveTarget({
    required int activityId,
    required int yearId,
    required double startValue,
    required String distributionType,
    required Map<int, double> periodValues,
    Map<int, bool>? activeValues,
  });

  Future<void> deleteTarget(int targetId);

  Future<Set<int>> activityIdsWithTargetInYear(int yearId);

  Future<List<ActivityInfo>> getAllActivities();

  Future<List<ActivityInfo>> getActivitiesOwnedBy(int userId);

  Future<Map<int, ProgressEntryInfo>> getProgressForActivityYear(
      int activityId, int yearId);

  Future<void> saveProgress({
    required int activityId,
    required int periodId,
    required double progressValue,
    String? note,
    required int enteredByUserId,
    String? userName,
  });

  Future<void> submitProgress(int activityId, int periodId,
      {int? userId, String? userName});

  Future<List<PeriodInfo>> getOpenPeriods();

  Future<int?> previousPeriodId(int periodId);

  Future<List<ApprovalQueueItem>> getApprovalQueueForPeriod(
      int periodId, int userId,
      {required bool onlyMyTurn,
      bool showAll = false,
      bool includeInactive = false});

  Future<void> approveOrModify({
    required int progressEntryId,
    required int stepIndex,
    required double newValue,
    required int userId,
    required String userName,
    String? note,
  });

  Future<List<ProgressHistoryItem>> getProgressHistory(int progressEntryId);

  Future<void> rejectProgress({
    required int progressEntryId,
    required int stepIndex,
    required bool toOwner,
    required int userId,
    required String userName,
    String? note,
  });

  Future<void> reopenFinalProgress({
    required int progressEntryId,
    required int userId,
    required String userName,
    String? note,
  });

  Future<DashboardStats> getDashboardStats({
    required int periodId,
    int? ownerUserId,
    int? filterUnitId,
  });

  Future<List<UnitInfo>> getAccessibleUnits(int userId);

  Future<bool> isActivityActiveInPeriod(
      int activityId, int periodId, bool isKpi);

  Future<List<ReportRow>> getReportRows({
    required int yearId,
    int? periodId,
    int? ownerUserId,
    int? filterUnitId,
    bool includeInactive = false,
    String typeFilter = 'all',
  });
}