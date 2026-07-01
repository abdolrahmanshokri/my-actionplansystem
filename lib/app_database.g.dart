// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RolesTable extends Roles with TableInfo<$RolesTable, Role> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, title, level, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'roles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Role> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {code},
  ];
  @override
  Role map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Role(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
    );
  }

  @override
  $RolesTable createAlias(String alias) {
    return $RolesTable(attachedDatabase, alias);
  }
}

class Role extends DataClass implements Insertable<Role> {
  final int id;
  final String code;
  final String title;
  final int level;
  final String? description;
  const Role({
    required this.id,
    required this.code,
    required this.title,
    required this.level,
    this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['title'] = Variable<String>(title);
    map['level'] = Variable<int>(level);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    return map;
  }

  RolesCompanion toCompanion(bool nullToAbsent) {
    return RolesCompanion(
      id: Value(id),
      code: Value(code),
      title: Value(title),
      level: Value(level),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
    );
  }

  factory Role.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Role(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      title: serializer.fromJson<String>(json['title']),
      level: serializer.fromJson<int>(json['level']),
      description: serializer.fromJson<String?>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'title': serializer.toJson<String>(title),
      'level': serializer.toJson<int>(level),
      'description': serializer.toJson<String?>(description),
    };
  }

  Role copyWith({
    int? id,
    String? code,
    String? title,
    int? level,
    Value<String?> description = const Value.absent(),
  }) => Role(
    id: id ?? this.id,
    code: code ?? this.code,
    title: title ?? this.title,
    level: level ?? this.level,
    description: description.present ? description.value : this.description,
  );
  Role copyWithCompanion(RolesCompanion data) {
    return Role(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      title: data.title.present ? data.title.value : this.title,
      level: data.level.present ? data.level.value : this.level,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Role(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, title, level, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Role &&
          other.id == this.id &&
          other.code == this.code &&
          other.title == this.title &&
          other.level == this.level &&
          other.description == this.description);
}

class RolesCompanion extends UpdateCompanion<Role> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> title;
  final Value<int> level;
  final Value<String?> description;
  const RolesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.title = const Value.absent(),
    this.level = const Value.absent(),
    this.description = const Value.absent(),
  });
  RolesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String title,
    this.level = const Value.absent(),
    this.description = const Value.absent(),
  }) : code = Value(code),
       title = Value(title);
  static Insertable<Role> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? title,
    Expression<int>? level,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (title != null) 'title': title,
      if (level != null) 'level': level,
      if (description != null) 'description': description,
    });
  }

  RolesCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? title,
    Value<int>? level,
    Value<String?>? description,
  }) {
    return RolesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      level: level ?? this.level,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RolesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authTypeMeta = const VerificationMeta(
    'authType',
  );
  @override
  late final GeneratedColumn<String> authType = GeneratedColumn<String>(
    'auth_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastLoginAtMeta = const VerificationMeta(
    'lastLoginAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
    'last_login_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    fullName,
    email,
    authType,
    passwordHash,
    isActive,
    createdAt,
    lastLoginAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('auth_type')) {
      context.handle(
        _authTypeMeta,
        authType.isAcceptableOrUnknown(data['auth_type']!, _authTypeMeta),
      );
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
        _lastLoginAtMeta,
        lastLoginAt.isAcceptableOrUnknown(
          data['last_login_at']!,
          _lastLoginAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {username},
  ];
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      authType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auth_type'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastLoginAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_login_at'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String fullName;
  final String? email;
  final String authType;
  final String? passwordHash;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  const User({
    required this.id,
    required this.username,
    required this.fullName,
    this.email,
    required this.authType,
    this.passwordHash,
    required this.isActive,
    required this.createdAt,
    this.lastLoginAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['auth_type'] = Variable<String>(authType);
    if (!nullToAbsent || passwordHash != null) {
      map['password_hash'] = Variable<String>(passwordHash);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      fullName: Value(fullName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      authType: Value(authType),
      passwordHash: passwordHash == null && nullToAbsent
          ? const Value.absent()
          : Value(passwordHash),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String?>(json['email']),
      authType: serializer.fromJson<String>(json['authType']),
      passwordHash: serializer.fromJson<String?>(json['passwordHash']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String?>(email),
      'authType': serializer.toJson<String>(authType),
      'passwordHash': serializer.toJson<String?>(passwordHash),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? fullName,
    Value<String?> email = const Value.absent(),
    String? authType,
    Value<String?> passwordHash = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
    Value<DateTime?> lastLoginAt = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    fullName: fullName ?? this.fullName,
    email: email.present ? email.value : this.email,
    authType: authType ?? this.authType,
    passwordHash: passwordHash.present ? passwordHash.value : this.passwordHash,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      authType: data.authType.present ? data.authType.value : this.authType,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastLoginAt: data.lastLoginAt.present
          ? data.lastLoginAt.value
          : this.lastLoginAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('authType: $authType, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastLoginAt: $lastLoginAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    fullName,
    email,
    authType,
    passwordHash,
    isActive,
    createdAt,
    lastLoginAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.authType == this.authType &&
          other.passwordHash == this.passwordHash &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.lastLoginAt == this.lastLoginAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> fullName;
  final Value<String?> email;
  final Value<String> authType;
  final Value<String?> passwordHash;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastLoginAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.authType = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String fullName,
    this.email = const Value.absent(),
    this.authType = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
  }) : username = Value(username),
       fullName = Value(fullName);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? authType,
    Expression<String>? passwordHash,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastLoginAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (authType != null) 'auth_type': authType,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? fullName,
    Value<String?>? email,
    Value<String>? authType,
    Value<String?>? passwordHash,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastLoginAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      authType: authType ?? this.authType,
      passwordHash: passwordHash ?? this.passwordHash,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (authType.present) {
      map['auth_type'] = Variable<String>(authType.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('authType: $authType, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastLoginAt: $lastLoginAt')
          ..write(')'))
        .toString();
  }
}

class $UserRolesTable extends UserRoles
    with TableInfo<$UserRolesTable, UserRole> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserRolesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<int> roleId = GeneratedColumn<int>(
    'role_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES roles (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, roleId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_roles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserRole> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('role_id')) {
      context.handle(
        _roleIdMeta,
        roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_roleIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userId, roleId},
  ];
  @override
  UserRole map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRole(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      roleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}role_id'],
      )!,
    );
  }

  @override
  $UserRolesTable createAlias(String alias) {
    return $UserRolesTable(attachedDatabase, alias);
  }
}

class UserRole extends DataClass implements Insertable<UserRole> {
  final int id;
  final int userId;
  final int roleId;
  const UserRole({
    required this.id,
    required this.userId,
    required this.roleId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['role_id'] = Variable<int>(roleId);
    return map;
  }

  UserRolesCompanion toCompanion(bool nullToAbsent) {
    return UserRolesCompanion(
      id: Value(id),
      userId: Value(userId),
      roleId: Value(roleId),
    );
  }

  factory UserRole.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRole(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      roleId: serializer.fromJson<int>(json['roleId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'roleId': serializer.toJson<int>(roleId),
    };
  }

  UserRole copyWith({int? id, int? userId, int? roleId}) => UserRole(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    roleId: roleId ?? this.roleId,
  );
  UserRole copyWithCompanion(UserRolesCompanion data) {
    return UserRole(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRole(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('roleId: $roleId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, roleId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRole &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.roleId == this.roleId);
}

class UserRolesCompanion extends UpdateCompanion<UserRole> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> roleId;
  const UserRolesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.roleId = const Value.absent(),
  });
  UserRolesCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int roleId,
  }) : userId = Value(userId),
       roleId = Value(roleId);
  static Insertable<UserRole> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? roleId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (roleId != null) 'role_id': roleId,
    });
  }

  UserRolesCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? roleId,
  }) {
    return UserRolesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<int>(roleId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserRolesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('roleId: $roleId')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {key},
  ];
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String key;
  final String? value;
  const AppSetting({required this.id, required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  AppSetting copyWith({
    int? id,
    String? key,
    Value<String?> value = const Value.absent(),
  }) => AppSetting(
    id: id ?? this.id,
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> key;
  final Value<String?> value;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    this.value = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String?>? value,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $SessionsTable extends Sessions with TableInfo<$SessionsTable, Session> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    token,
    createdAt,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Session> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {token},
  ];
  @override
  Session map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Session(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $SessionsTable createAlias(String alias) {
    return $SessionsTable(attachedDatabase, alias);
  }
}

class Session extends DataClass implements Insertable<Session> {
  final int id;
  final int userId;
  final String token;
  final DateTime createdAt;
  final bool isActive;
  const Session({
    required this.id,
    required this.userId,
    required this.token,
    required this.createdAt,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['token'] = Variable<String>(token);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  SessionsCompanion toCompanion(bool nullToAbsent) {
    return SessionsCompanion(
      id: Value(id),
      userId: Value(userId),
      token: Value(token),
      createdAt: Value(createdAt),
      isActive: Value(isActive),
    );
  }

  factory Session.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Session(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      token: serializer.fromJson<String>(json['token']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'token': serializer.toJson<String>(token),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Session copyWith({
    int? id,
    int? userId,
    String? token,
    DateTime? createdAt,
    bool? isActive,
  }) => Session(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    token: token ?? this.token,
    createdAt: createdAt ?? this.createdAt,
    isActive: isActive ?? this.isActive,
  );
  Session copyWithCompanion(SessionsCompanion data) {
    return Session(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      token: data.token.present ? data.token.value : this.token,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Session(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, token, createdAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Session &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.token == this.token &&
          other.createdAt == this.createdAt &&
          other.isActive == this.isActive);
}

class SessionsCompanion extends UpdateCompanion<Session> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> token;
  final Value<DateTime> createdAt;
  final Value<bool> isActive;
  const SessionsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.token = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  SessionsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String token,
    this.createdAt = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : userId = Value(userId),
       token = Value(token);
  static Insertable<Session> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? token,
    Expression<DateTime>? createdAt,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (token != null) 'token': token,
      if (createdAt != null) 'created_at': createdAt,
      if (isActive != null) 'is_active': isActive,
    });
  }

  SessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? token,
    Value<DateTime>? createdAt,
    Value<bool>? isActive,
  }) {
    return SessionsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('token: $token, ')
          ..write('createdAt: $createdAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $YearsTable extends Years with TableInfo<$YearsTable, Year> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $YearsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _yearValueMeta = const VerificationMeta(
    'yearValue',
  );
  @override
  late final GeneratedColumn<int> yearValue = GeneratedColumn<int>(
    'year_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startJyMeta = const VerificationMeta(
    'startJy',
  );
  @override
  late final GeneratedColumn<int> startJy = GeneratedColumn<int>(
    'start_jy',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startJmMeta = const VerificationMeta(
    'startJm',
  );
  @override
  late final GeneratedColumn<int> startJm = GeneratedColumn<int>(
    'start_jm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startJdMeta = const VerificationMeta(
    'startJd',
  );
  @override
  late final GeneratedColumn<int> startJd = GeneratedColumn<int>(
    'start_jd',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endJyMeta = const VerificationMeta('endJy');
  @override
  late final GeneratedColumn<int> endJy = GeneratedColumn<int>(
    'end_jy',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endJmMeta = const VerificationMeta('endJm');
  @override
  late final GeneratedColumn<int> endJm = GeneratedColumn<int>(
    'end_jm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endJdMeta = const VerificationMeta('endJd');
  @override
  late final GeneratedColumn<int> endJd = GeneratedColumn<int>(
    'end_jd',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    yearValue,
    title,
    startJy,
    startJm,
    startJd,
    endJy,
    endJm,
    endJd,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'years';
  @override
  VerificationContext validateIntegrity(
    Insertable<Year> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('year_value')) {
      context.handle(
        _yearValueMeta,
        yearValue.isAcceptableOrUnknown(data['year_value']!, _yearValueMeta),
      );
    } else if (isInserting) {
      context.missing(_yearValueMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('start_jy')) {
      context.handle(
        _startJyMeta,
        startJy.isAcceptableOrUnknown(data['start_jy']!, _startJyMeta),
      );
    } else if (isInserting) {
      context.missing(_startJyMeta);
    }
    if (data.containsKey('start_jm')) {
      context.handle(
        _startJmMeta,
        startJm.isAcceptableOrUnknown(data['start_jm']!, _startJmMeta),
      );
    } else if (isInserting) {
      context.missing(_startJmMeta);
    }
    if (data.containsKey('start_jd')) {
      context.handle(
        _startJdMeta,
        startJd.isAcceptableOrUnknown(data['start_jd']!, _startJdMeta),
      );
    } else if (isInserting) {
      context.missing(_startJdMeta);
    }
    if (data.containsKey('end_jy')) {
      context.handle(
        _endJyMeta,
        endJy.isAcceptableOrUnknown(data['end_jy']!, _endJyMeta),
      );
    } else if (isInserting) {
      context.missing(_endJyMeta);
    }
    if (data.containsKey('end_jm')) {
      context.handle(
        _endJmMeta,
        endJm.isAcceptableOrUnknown(data['end_jm']!, _endJmMeta),
      );
    } else if (isInserting) {
      context.missing(_endJmMeta);
    }
    if (data.containsKey('end_jd')) {
      context.handle(
        _endJdMeta,
        endJd.isAcceptableOrUnknown(data['end_jd']!, _endJdMeta),
      );
    } else if (isInserting) {
      context.missing(_endJdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Year map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Year(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      yearValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_value'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      startJy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_jy'],
      )!,
      startJm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_jm'],
      )!,
      startJd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_jd'],
      )!,
      endJy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_jy'],
      )!,
      endJm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_jm'],
      )!,
      endJd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_jd'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $YearsTable createAlias(String alias) {
    return $YearsTable(attachedDatabase, alias);
  }
}

class Year extends DataClass implements Insertable<Year> {
  final int id;
  final int yearValue;
  final String title;
  final int startJy;
  final int startJm;
  final int startJd;
  final int endJy;
  final int endJm;
  final int endJd;
  final DateTime createdAt;
  const Year({
    required this.id,
    required this.yearValue,
    required this.title,
    required this.startJy,
    required this.startJm,
    required this.startJd,
    required this.endJy,
    required this.endJm,
    required this.endJd,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year_value'] = Variable<int>(yearValue);
    map['title'] = Variable<String>(title);
    map['start_jy'] = Variable<int>(startJy);
    map['start_jm'] = Variable<int>(startJm);
    map['start_jd'] = Variable<int>(startJd);
    map['end_jy'] = Variable<int>(endJy);
    map['end_jm'] = Variable<int>(endJm);
    map['end_jd'] = Variable<int>(endJd);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  YearsCompanion toCompanion(bool nullToAbsent) {
    return YearsCompanion(
      id: Value(id),
      yearValue: Value(yearValue),
      title: Value(title),
      startJy: Value(startJy),
      startJm: Value(startJm),
      startJd: Value(startJd),
      endJy: Value(endJy),
      endJm: Value(endJm),
      endJd: Value(endJd),
      createdAt: Value(createdAt),
    );
  }

  factory Year.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Year(
      id: serializer.fromJson<int>(json['id']),
      yearValue: serializer.fromJson<int>(json['yearValue']),
      title: serializer.fromJson<String>(json['title']),
      startJy: serializer.fromJson<int>(json['startJy']),
      startJm: serializer.fromJson<int>(json['startJm']),
      startJd: serializer.fromJson<int>(json['startJd']),
      endJy: serializer.fromJson<int>(json['endJy']),
      endJm: serializer.fromJson<int>(json['endJm']),
      endJd: serializer.fromJson<int>(json['endJd']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'yearValue': serializer.toJson<int>(yearValue),
      'title': serializer.toJson<String>(title),
      'startJy': serializer.toJson<int>(startJy),
      'startJm': serializer.toJson<int>(startJm),
      'startJd': serializer.toJson<int>(startJd),
      'endJy': serializer.toJson<int>(endJy),
      'endJm': serializer.toJson<int>(endJm),
      'endJd': serializer.toJson<int>(endJd),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Year copyWith({
    int? id,
    int? yearValue,
    String? title,
    int? startJy,
    int? startJm,
    int? startJd,
    int? endJy,
    int? endJm,
    int? endJd,
    DateTime? createdAt,
  }) => Year(
    id: id ?? this.id,
    yearValue: yearValue ?? this.yearValue,
    title: title ?? this.title,
    startJy: startJy ?? this.startJy,
    startJm: startJm ?? this.startJm,
    startJd: startJd ?? this.startJd,
    endJy: endJy ?? this.endJy,
    endJm: endJm ?? this.endJm,
    endJd: endJd ?? this.endJd,
    createdAt: createdAt ?? this.createdAt,
  );
  Year copyWithCompanion(YearsCompanion data) {
    return Year(
      id: data.id.present ? data.id.value : this.id,
      yearValue: data.yearValue.present ? data.yearValue.value : this.yearValue,
      title: data.title.present ? data.title.value : this.title,
      startJy: data.startJy.present ? data.startJy.value : this.startJy,
      startJm: data.startJm.present ? data.startJm.value : this.startJm,
      startJd: data.startJd.present ? data.startJd.value : this.startJd,
      endJy: data.endJy.present ? data.endJy.value : this.endJy,
      endJm: data.endJm.present ? data.endJm.value : this.endJm,
      endJd: data.endJd.present ? data.endJd.value : this.endJd,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Year(')
          ..write('id: $id, ')
          ..write('yearValue: $yearValue, ')
          ..write('title: $title, ')
          ..write('startJy: $startJy, ')
          ..write('startJm: $startJm, ')
          ..write('startJd: $startJd, ')
          ..write('endJy: $endJy, ')
          ..write('endJm: $endJm, ')
          ..write('endJd: $endJd, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    yearValue,
    title,
    startJy,
    startJm,
    startJd,
    endJy,
    endJm,
    endJd,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Year &&
          other.id == this.id &&
          other.yearValue == this.yearValue &&
          other.title == this.title &&
          other.startJy == this.startJy &&
          other.startJm == this.startJm &&
          other.startJd == this.startJd &&
          other.endJy == this.endJy &&
          other.endJm == this.endJm &&
          other.endJd == this.endJd &&
          other.createdAt == this.createdAt);
}

class YearsCompanion extends UpdateCompanion<Year> {
  final Value<int> id;
  final Value<int> yearValue;
  final Value<String> title;
  final Value<int> startJy;
  final Value<int> startJm;
  final Value<int> startJd;
  final Value<int> endJy;
  final Value<int> endJm;
  final Value<int> endJd;
  final Value<DateTime> createdAt;
  const YearsCompanion({
    this.id = const Value.absent(),
    this.yearValue = const Value.absent(),
    this.title = const Value.absent(),
    this.startJy = const Value.absent(),
    this.startJm = const Value.absent(),
    this.startJd = const Value.absent(),
    this.endJy = const Value.absent(),
    this.endJm = const Value.absent(),
    this.endJd = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  YearsCompanion.insert({
    this.id = const Value.absent(),
    required int yearValue,
    required String title,
    required int startJy,
    required int startJm,
    required int startJd,
    required int endJy,
    required int endJm,
    required int endJd,
    this.createdAt = const Value.absent(),
  }) : yearValue = Value(yearValue),
       title = Value(title),
       startJy = Value(startJy),
       startJm = Value(startJm),
       startJd = Value(startJd),
       endJy = Value(endJy),
       endJm = Value(endJm),
       endJd = Value(endJd);
  static Insertable<Year> custom({
    Expression<int>? id,
    Expression<int>? yearValue,
    Expression<String>? title,
    Expression<int>? startJy,
    Expression<int>? startJm,
    Expression<int>? startJd,
    Expression<int>? endJy,
    Expression<int>? endJm,
    Expression<int>? endJd,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (yearValue != null) 'year_value': yearValue,
      if (title != null) 'title': title,
      if (startJy != null) 'start_jy': startJy,
      if (startJm != null) 'start_jm': startJm,
      if (startJd != null) 'start_jd': startJd,
      if (endJy != null) 'end_jy': endJy,
      if (endJm != null) 'end_jm': endJm,
      if (endJd != null) 'end_jd': endJd,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  YearsCompanion copyWith({
    Value<int>? id,
    Value<int>? yearValue,
    Value<String>? title,
    Value<int>? startJy,
    Value<int>? startJm,
    Value<int>? startJd,
    Value<int>? endJy,
    Value<int>? endJm,
    Value<int>? endJd,
    Value<DateTime>? createdAt,
  }) {
    return YearsCompanion(
      id: id ?? this.id,
      yearValue: yearValue ?? this.yearValue,
      title: title ?? this.title,
      startJy: startJy ?? this.startJy,
      startJm: startJm ?? this.startJm,
      startJd: startJd ?? this.startJd,
      endJy: endJy ?? this.endJy,
      endJm: endJm ?? this.endJm,
      endJd: endJd ?? this.endJd,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (yearValue.present) {
      map['year_value'] = Variable<int>(yearValue.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (startJy.present) {
      map['start_jy'] = Variable<int>(startJy.value);
    }
    if (startJm.present) {
      map['start_jm'] = Variable<int>(startJm.value);
    }
    if (startJd.present) {
      map['start_jd'] = Variable<int>(startJd.value);
    }
    if (endJy.present) {
      map['end_jy'] = Variable<int>(endJy.value);
    }
    if (endJm.present) {
      map['end_jm'] = Variable<int>(endJm.value);
    }
    if (endJd.present) {
      map['end_jd'] = Variable<int>(endJd.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('YearsCompanion(')
          ..write('id: $id, ')
          ..write('yearValue: $yearValue, ')
          ..write('title: $title, ')
          ..write('startJy: $startJy, ')
          ..write('startJm: $startJm, ')
          ..write('startJd: $startJd, ')
          ..write('endJy: $endJy, ')
          ..write('endJm: $endJm, ')
          ..write('endJd: $endJd, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PeriodsTable extends Periods with TableInfo<$PeriodsTable, Period> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _yearIdMeta = const VerificationMeta('yearId');
  @override
  late final GeneratedColumn<int> yearId = GeneratedColumn<int>(
    'year_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES years (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _monthNumberMeta = const VerificationMeta(
    'monthNumber',
  );
  @override
  late final GeneratedColumn<int> monthNumber = GeneratedColumn<int>(
    'month_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthNameMeta = const VerificationMeta(
    'monthName',
  );
  @override
  late final GeneratedColumn<String> monthName = GeneratedColumn<String>(
    'month_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('closed'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    yearId,
    monthNumber,
    monthName,
    title,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Period> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('year_id')) {
      context.handle(
        _yearIdMeta,
        yearId.isAcceptableOrUnknown(data['year_id']!, _yearIdMeta),
      );
    } else if (isInserting) {
      context.missing(_yearIdMeta);
    }
    if (data.containsKey('month_number')) {
      context.handle(
        _monthNumberMeta,
        monthNumber.isAcceptableOrUnknown(
          data['month_number']!,
          _monthNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthNumberMeta);
    }
    if (data.containsKey('month_name')) {
      context.handle(
        _monthNameMeta,
        monthName.isAcceptableOrUnknown(data['month_name']!, _monthNameMeta),
      );
    } else if (isInserting) {
      context.missing(_monthNameMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Period map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Period(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      yearId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_id'],
      )!,
      monthNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month_number'],
      )!,
      monthName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month_name'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PeriodsTable createAlias(String alias) {
    return $PeriodsTable(attachedDatabase, alias);
  }
}

class Period extends DataClass implements Insertable<Period> {
  final int id;
  final int yearId;
  final int monthNumber;
  final String monthName;
  final String title;
  final String status;
  final DateTime createdAt;
  const Period({
    required this.id,
    required this.yearId,
    required this.monthNumber,
    required this.monthName,
    required this.title,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year_id'] = Variable<int>(yearId);
    map['month_number'] = Variable<int>(monthNumber);
    map['month_name'] = Variable<String>(monthName);
    map['title'] = Variable<String>(title);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PeriodsCompanion toCompanion(bool nullToAbsent) {
    return PeriodsCompanion(
      id: Value(id),
      yearId: Value(yearId),
      monthNumber: Value(monthNumber),
      monthName: Value(monthName),
      title: Value(title),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory Period.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Period(
      id: serializer.fromJson<int>(json['id']),
      yearId: serializer.fromJson<int>(json['yearId']),
      monthNumber: serializer.fromJson<int>(json['monthNumber']),
      monthName: serializer.fromJson<String>(json['monthName']),
      title: serializer.fromJson<String>(json['title']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'yearId': serializer.toJson<int>(yearId),
      'monthNumber': serializer.toJson<int>(monthNumber),
      'monthName': serializer.toJson<String>(monthName),
      'title': serializer.toJson<String>(title),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Period copyWith({
    int? id,
    int? yearId,
    int? monthNumber,
    String? monthName,
    String? title,
    String? status,
    DateTime? createdAt,
  }) => Period(
    id: id ?? this.id,
    yearId: yearId ?? this.yearId,
    monthNumber: monthNumber ?? this.monthNumber,
    monthName: monthName ?? this.monthName,
    title: title ?? this.title,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  Period copyWithCompanion(PeriodsCompanion data) {
    return Period(
      id: data.id.present ? data.id.value : this.id,
      yearId: data.yearId.present ? data.yearId.value : this.yearId,
      monthNumber: data.monthNumber.present
          ? data.monthNumber.value
          : this.monthNumber,
      monthName: data.monthName.present ? data.monthName.value : this.monthName,
      title: data.title.present ? data.title.value : this.title,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Period(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('monthNumber: $monthNumber, ')
          ..write('monthName: $monthName, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, yearId, monthNumber, monthName, title, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Period &&
          other.id == this.id &&
          other.yearId == this.yearId &&
          other.monthNumber == this.monthNumber &&
          other.monthName == this.monthName &&
          other.title == this.title &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class PeriodsCompanion extends UpdateCompanion<Period> {
  final Value<int> id;
  final Value<int> yearId;
  final Value<int> monthNumber;
  final Value<String> monthName;
  final Value<String> title;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const PeriodsCompanion({
    this.id = const Value.absent(),
    this.yearId = const Value.absent(),
    this.monthNumber = const Value.absent(),
    this.monthName = const Value.absent(),
    this.title = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PeriodsCompanion.insert({
    this.id = const Value.absent(),
    required int yearId,
    required int monthNumber,
    required String monthName,
    required String title,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : yearId = Value(yearId),
       monthNumber = Value(monthNumber),
       monthName = Value(monthName),
       title = Value(title);
  static Insertable<Period> custom({
    Expression<int>? id,
    Expression<int>? yearId,
    Expression<int>? monthNumber,
    Expression<String>? monthName,
    Expression<String>? title,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (yearId != null) 'year_id': yearId,
      if (monthNumber != null) 'month_number': monthNumber,
      if (monthName != null) 'month_name': monthName,
      if (title != null) 'title': title,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PeriodsCompanion copyWith({
    Value<int>? id,
    Value<int>? yearId,
    Value<int>? monthNumber,
    Value<String>? monthName,
    Value<String>? title,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return PeriodsCompanion(
      id: id ?? this.id,
      yearId: yearId ?? this.yearId,
      monthNumber: monthNumber ?? this.monthNumber,
      monthName: monthName ?? this.monthName,
      title: title ?? this.title,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (yearId.present) {
      map['year_id'] = Variable<int>(yearId.value);
    }
    if (monthNumber.present) {
      map['month_number'] = Variable<int>(monthNumber.value);
    }
    if (monthName.present) {
      map['month_name'] = Variable<String>(monthName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeriodsCompanion(')
          ..write('id: $id, ')
          ..write('yearId: $yearId, ')
          ..write('monthNumber: $monthNumber, ')
          ..write('monthName: $monthName, ')
          ..write('title: $title, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UnitsTable extends Units with TableInfo<$UnitsTable, Unit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentId,
    name,
    description,
    level,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'units';
  @override
  VerificationContext validateIntegrity(
    Insertable<Unit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Unit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Unit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UnitsTable createAlias(String alias) {
    return $UnitsTable(attachedDatabase, alias);
  }
}

class Unit extends DataClass implements Insertable<Unit> {
  final int id;
  final int? parentId;
  final String name;
  final String? description;
  final int level;
  final int sortOrder;
  final DateTime createdAt;
  const Unit({
    required this.id,
    this.parentId,
    required this.name,
    this.description,
    required this.level,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['level'] = Variable<int>(level);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UnitsCompanion toCompanion(bool nullToAbsent) {
    return UnitsCompanion(
      id: Value(id),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      level: Value(level),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory Unit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Unit(
      id: serializer.fromJson<int>(json['id']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      level: serializer.fromJson<int>(json['level']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentId': serializer.toJson<int?>(parentId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'level': serializer.toJson<int>(level),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Unit copyWith({
    int? id,
    Value<int?> parentId = const Value.absent(),
    String? name,
    Value<String?> description = const Value.absent(),
    int? level,
    int? sortOrder,
    DateTime? createdAt,
  }) => Unit(
    id: id ?? this.id,
    parentId: parentId.present ? parentId.value : this.parentId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    level: level ?? this.level,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  Unit copyWithCompanion(UnitsCompanion data) {
    return Unit(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      level: data.level.present ? data.level.value : this.level,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Unit(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, parentId, name, description, level, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Unit &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.name == this.name &&
          other.description == this.description &&
          other.level == this.level &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class UnitsCompanion extends UpdateCompanion<Unit> {
  final Value<int> id;
  final Value<int?> parentId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> level;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const UnitsCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.level = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UnitsCompanion.insert({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.level = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Unit> custom({
    Expression<int>? id,
    Expression<int>? parentId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? level,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (level != null) 'level': level,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UnitsCompanion copyWith({
    Value<int>? id,
    Value<int?>? parentId,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? level,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
  }) {
    return UnitsCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitsCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('level: $level, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ApprovalStepsTable extends ApprovalSteps
    with TableInfo<$ApprovalStepsTable, ApprovalStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApprovalStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stepOrderMeta = const VerificationMeta(
    'stepOrder',
  );
  @override
  late final GeneratedColumn<int> stepOrder = GeneratedColumn<int>(
    'step_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _approvalTypeMeta = const VerificationMeta(
    'approvalType',
  );
  @override
  late final GeneratedColumn<String> approvalType = GeneratedColumn<String>(
    'approval_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('or'),
  );
  static const VerificationMeta _subjectTypeMeta = const VerificationMeta(
    'subjectType',
  );
  @override
  late final GeneratedColumn<String> subjectType = GeneratedColumn<String>(
    'subject_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('role'),
  );
  static const VerificationMeta _roleIdMeta = const VerificationMeta('roleId');
  @override
  late final GeneratedColumn<int> roleId = GeneratedColumn<int>(
    'role_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    unitId,
    stepOrder,
    approvalType,
    subjectType,
    roleId,
    userId,
    label,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'approval_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<ApprovalStep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('step_order')) {
      context.handle(
        _stepOrderMeta,
        stepOrder.isAcceptableOrUnknown(data['step_order']!, _stepOrderMeta),
      );
    }
    if (data.containsKey('approval_type')) {
      context.handle(
        _approvalTypeMeta,
        approvalType.isAcceptableOrUnknown(
          data['approval_type']!,
          _approvalTypeMeta,
        ),
      );
    }
    if (data.containsKey('subject_type')) {
      context.handle(
        _subjectTypeMeta,
        subjectType.isAcceptableOrUnknown(
          data['subject_type']!,
          _subjectTypeMeta,
        ),
      );
    }
    if (data.containsKey('role_id')) {
      context.handle(
        _roleIdMeta,
        roleId.isAcceptableOrUnknown(data['role_id']!, _roleIdMeta),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ApprovalStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApprovalStep(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      stepOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_order'],
      )!,
      approvalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}approval_type'],
      )!,
      subjectType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject_type'],
      )!,
      roleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}role_id'],
      ),
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ApprovalStepsTable createAlias(String alias) {
    return $ApprovalStepsTable(attachedDatabase, alias);
  }
}

class ApprovalStep extends DataClass implements Insertable<ApprovalStep> {
  final int id;
  final int unitId;
  final int stepOrder;
  final String approvalType;
  final String subjectType;
  final int? roleId;
  final int? userId;
  final String? label;
  final DateTime createdAt;
  const ApprovalStep({
    required this.id,
    required this.unitId,
    required this.stepOrder,
    required this.approvalType,
    required this.subjectType,
    this.roleId,
    this.userId,
    this.label,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['unit_id'] = Variable<int>(unitId);
    map['step_order'] = Variable<int>(stepOrder);
    map['approval_type'] = Variable<String>(approvalType);
    map['subject_type'] = Variable<String>(subjectType);
    if (!nullToAbsent || roleId != null) {
      map['role_id'] = Variable<int>(roleId);
    }
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ApprovalStepsCompanion toCompanion(bool nullToAbsent) {
    return ApprovalStepsCompanion(
      id: Value(id),
      unitId: Value(unitId),
      stepOrder: Value(stepOrder),
      approvalType: Value(approvalType),
      subjectType: Value(subjectType),
      roleId: roleId == null && nullToAbsent
          ? const Value.absent()
          : Value(roleId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
      createdAt: Value(createdAt),
    );
  }

  factory ApprovalStep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApprovalStep(
      id: serializer.fromJson<int>(json['id']),
      unitId: serializer.fromJson<int>(json['unitId']),
      stepOrder: serializer.fromJson<int>(json['stepOrder']),
      approvalType: serializer.fromJson<String>(json['approvalType']),
      subjectType: serializer.fromJson<String>(json['subjectType']),
      roleId: serializer.fromJson<int?>(json['roleId']),
      userId: serializer.fromJson<int?>(json['userId']),
      label: serializer.fromJson<String?>(json['label']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'unitId': serializer.toJson<int>(unitId),
      'stepOrder': serializer.toJson<int>(stepOrder),
      'approvalType': serializer.toJson<String>(approvalType),
      'subjectType': serializer.toJson<String>(subjectType),
      'roleId': serializer.toJson<int?>(roleId),
      'userId': serializer.toJson<int?>(userId),
      'label': serializer.toJson<String?>(label),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ApprovalStep copyWith({
    int? id,
    int? unitId,
    int? stepOrder,
    String? approvalType,
    String? subjectType,
    Value<int?> roleId = const Value.absent(),
    Value<int?> userId = const Value.absent(),
    Value<String?> label = const Value.absent(),
    DateTime? createdAt,
  }) => ApprovalStep(
    id: id ?? this.id,
    unitId: unitId ?? this.unitId,
    stepOrder: stepOrder ?? this.stepOrder,
    approvalType: approvalType ?? this.approvalType,
    subjectType: subjectType ?? this.subjectType,
    roleId: roleId.present ? roleId.value : this.roleId,
    userId: userId.present ? userId.value : this.userId,
    label: label.present ? label.value : this.label,
    createdAt: createdAt ?? this.createdAt,
  );
  ApprovalStep copyWithCompanion(ApprovalStepsCompanion data) {
    return ApprovalStep(
      id: data.id.present ? data.id.value : this.id,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      stepOrder: data.stepOrder.present ? data.stepOrder.value : this.stepOrder,
      approvalType: data.approvalType.present
          ? data.approvalType.value
          : this.approvalType,
      subjectType: data.subjectType.present
          ? data.subjectType.value
          : this.subjectType,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      userId: data.userId.present ? data.userId.value : this.userId,
      label: data.label.present ? data.label.value : this.label,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApprovalStep(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('stepOrder: $stepOrder, ')
          ..write('approvalType: $approvalType, ')
          ..write('subjectType: $subjectType, ')
          ..write('roleId: $roleId, ')
          ..write('userId: $userId, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    unitId,
    stepOrder,
    approvalType,
    subjectType,
    roleId,
    userId,
    label,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApprovalStep &&
          other.id == this.id &&
          other.unitId == this.unitId &&
          other.stepOrder == this.stepOrder &&
          other.approvalType == this.approvalType &&
          other.subjectType == this.subjectType &&
          other.roleId == this.roleId &&
          other.userId == this.userId &&
          other.label == this.label &&
          other.createdAt == this.createdAt);
}

class ApprovalStepsCompanion extends UpdateCompanion<ApprovalStep> {
  final Value<int> id;
  final Value<int> unitId;
  final Value<int> stepOrder;
  final Value<String> approvalType;
  final Value<String> subjectType;
  final Value<int?> roleId;
  final Value<int?> userId;
  final Value<String?> label;
  final Value<DateTime> createdAt;
  const ApprovalStepsCompanion({
    this.id = const Value.absent(),
    this.unitId = const Value.absent(),
    this.stepOrder = const Value.absent(),
    this.approvalType = const Value.absent(),
    this.subjectType = const Value.absent(),
    this.roleId = const Value.absent(),
    this.userId = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ApprovalStepsCompanion.insert({
    this.id = const Value.absent(),
    required int unitId,
    this.stepOrder = const Value.absent(),
    this.approvalType = const Value.absent(),
    this.subjectType = const Value.absent(),
    this.roleId = const Value.absent(),
    this.userId = const Value.absent(),
    this.label = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : unitId = Value(unitId);
  static Insertable<ApprovalStep> custom({
    Expression<int>? id,
    Expression<int>? unitId,
    Expression<int>? stepOrder,
    Expression<String>? approvalType,
    Expression<String>? subjectType,
    Expression<int>? roleId,
    Expression<int>? userId,
    Expression<String>? label,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitId != null) 'unit_id': unitId,
      if (stepOrder != null) 'step_order': stepOrder,
      if (approvalType != null) 'approval_type': approvalType,
      if (subjectType != null) 'subject_type': subjectType,
      if (roleId != null) 'role_id': roleId,
      if (userId != null) 'user_id': userId,
      if (label != null) 'label': label,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ApprovalStepsCompanion copyWith({
    Value<int>? id,
    Value<int>? unitId,
    Value<int>? stepOrder,
    Value<String>? approvalType,
    Value<String>? subjectType,
    Value<int?>? roleId,
    Value<int?>? userId,
    Value<String?>? label,
    Value<DateTime>? createdAt,
  }) {
    return ApprovalStepsCompanion(
      id: id ?? this.id,
      unitId: unitId ?? this.unitId,
      stepOrder: stepOrder ?? this.stepOrder,
      approvalType: approvalType ?? this.approvalType,
      subjectType: subjectType ?? this.subjectType,
      roleId: roleId ?? this.roleId,
      userId: userId ?? this.userId,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (stepOrder.present) {
      map['step_order'] = Variable<int>(stepOrder.value);
    }
    if (approvalType.present) {
      map['approval_type'] = Variable<String>(approvalType.value);
    }
    if (subjectType.present) {
      map['subject_type'] = Variable<String>(subjectType.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<int>(roleId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApprovalStepsCompanion(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('stepOrder: $stepOrder, ')
          ..write('approvalType: $approvalType, ')
          ..write('subjectType: $subjectType, ')
          ..write('roleId: $roleId, ')
          ..write('userId: $userId, ')
          ..write('label: $label, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
    'unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _activityNumberMeta = const VerificationMeta(
    'activityNumber',
  );
  @override
  late final GeneratedColumn<String> activityNumber = GeneratedColumn<String>(
    'activity_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 300,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityTypeMeta = const VerificationMeta(
    'activityType',
  );
  @override
  late final GeneratedColumn<String> activityType = GeneratedColumn<String>(
    'activity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('project'),
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ownerUserIdMeta = const VerificationMeta(
    'ownerUserId',
  );
  @override
  late final GeneratedColumn<int> ownerUserId = GeneratedColumn<int>(
    'owner_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    unitId,
    activityNumber,
    name,
    activityType,
    weight,
    ownerUserId,
    description,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('unit_id')) {
      context.handle(
        _unitIdMeta,
        unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('activity_number')) {
      context.handle(
        _activityNumberMeta,
        activityNumber.isAcceptableOrUnknown(
          data['activity_number']!,
          _activityNumberMeta,
        ),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('activity_type')) {
      context.handle(
        _activityTypeMeta,
        activityType.isAcceptableOrUnknown(
          data['activity_type']!,
          _activityTypeMeta,
        ),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('owner_user_id')) {
      context.handle(
        _ownerUserIdMeta,
        ownerUserId.isAcceptableOrUnknown(
          data['owner_user_id']!,
          _ownerUserIdMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      unitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_id'],
      )!,
      activityNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_number'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      activityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_type'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      ownerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_user_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class Activity extends DataClass implements Insertable<Activity> {
  final int id;
  final int unitId;
  final String? activityNumber;
  final String name;
  final String activityType;
  final double weight;
  final int? ownerUserId;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  const Activity({
    required this.id,
    required this.unitId,
    this.activityNumber,
    required this.name,
    required this.activityType,
    required this.weight,
    this.ownerUserId,
    this.description,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['unit_id'] = Variable<int>(unitId);
    if (!nullToAbsent || activityNumber != null) {
      map['activity_number'] = Variable<String>(activityNumber);
    }
    map['name'] = Variable<String>(name);
    map['activity_type'] = Variable<String>(activityType);
    map['weight'] = Variable<double>(weight);
    if (!nullToAbsent || ownerUserId != null) {
      map['owner_user_id'] = Variable<int>(ownerUserId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      unitId: Value(unitId),
      activityNumber: activityNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(activityNumber),
      name: Value(name),
      activityType: Value(activityType),
      weight: Value(weight),
      ownerUserId: ownerUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerUserId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<int>(json['id']),
      unitId: serializer.fromJson<int>(json['unitId']),
      activityNumber: serializer.fromJson<String?>(json['activityNumber']),
      name: serializer.fromJson<String>(json['name']),
      activityType: serializer.fromJson<String>(json['activityType']),
      weight: serializer.fromJson<double>(json['weight']),
      ownerUserId: serializer.fromJson<int?>(json['ownerUserId']),
      description: serializer.fromJson<String?>(json['description']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'unitId': serializer.toJson<int>(unitId),
      'activityNumber': serializer.toJson<String?>(activityNumber),
      'name': serializer.toJson<String>(name),
      'activityType': serializer.toJson<String>(activityType),
      'weight': serializer.toJson<double>(weight),
      'ownerUserId': serializer.toJson<int?>(ownerUserId),
      'description': serializer.toJson<String?>(description),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Activity copyWith({
    int? id,
    int? unitId,
    Value<String?> activityNumber = const Value.absent(),
    String? name,
    String? activityType,
    double? weight,
    Value<int?> ownerUserId = const Value.absent(),
    Value<String?> description = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
  }) => Activity(
    id: id ?? this.id,
    unitId: unitId ?? this.unitId,
    activityNumber: activityNumber.present
        ? activityNumber.value
        : this.activityNumber,
    name: name ?? this.name,
    activityType: activityType ?? this.activityType,
    weight: weight ?? this.weight,
    ownerUserId: ownerUserId.present ? ownerUserId.value : this.ownerUserId,
    description: description.present ? description.value : this.description,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      id: data.id.present ? data.id.value : this.id,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      activityNumber: data.activityNumber.present
          ? data.activityNumber.value
          : this.activityNumber,
      name: data.name.present ? data.name.value : this.name,
      activityType: data.activityType.present
          ? data.activityType.value
          : this.activityType,
      weight: data.weight.present ? data.weight.value : this.weight,
      ownerUserId: data.ownerUserId.present
          ? data.ownerUserId.value
          : this.ownerUserId,
      description: data.description.present
          ? data.description.value
          : this.description,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('activityNumber: $activityNumber, ')
          ..write('name: $name, ')
          ..write('activityType: $activityType, ')
          ..write('weight: $weight, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    unitId,
    activityNumber,
    name,
    activityType,
    weight,
    ownerUserId,
    description,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.unitId == this.unitId &&
          other.activityNumber == this.activityNumber &&
          other.name == this.name &&
          other.activityType == this.activityType &&
          other.weight == this.weight &&
          other.ownerUserId == this.ownerUserId &&
          other.description == this.description &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int> id;
  final Value<int> unitId;
  final Value<String?> activityNumber;
  final Value<String> name;
  final Value<String> activityType;
  final Value<double> weight;
  final Value<int?> ownerUserId;
  final Value<String?> description;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.unitId = const Value.absent(),
    this.activityNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.activityType = const Value.absent(),
    this.weight = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required int unitId,
    this.activityNumber = const Value.absent(),
    required String name,
    this.activityType = const Value.absent(),
    this.weight = const Value.absent(),
    this.ownerUserId = const Value.absent(),
    this.description = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : unitId = Value(unitId),
       name = Value(name);
  static Insertable<Activity> custom({
    Expression<int>? id,
    Expression<int>? unitId,
    Expression<String>? activityNumber,
    Expression<String>? name,
    Expression<String>? activityType,
    Expression<double>? weight,
    Expression<int>? ownerUserId,
    Expression<String>? description,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitId != null) 'unit_id': unitId,
      if (activityNumber != null) 'activity_number': activityNumber,
      if (name != null) 'name': name,
      if (activityType != null) 'activity_type': activityType,
      if (weight != null) 'weight': weight,
      if (ownerUserId != null) 'owner_user_id': ownerUserId,
      if (description != null) 'description': description,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ActivitiesCompanion copyWith({
    Value<int>? id,
    Value<int>? unitId,
    Value<String?>? activityNumber,
    Value<String>? name,
    Value<String>? activityType,
    Value<double>? weight,
    Value<int?>? ownerUserId,
    Value<String?>? description,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      unitId: unitId ?? this.unitId,
      activityNumber: activityNumber ?? this.activityNumber,
      name: name ?? this.name,
      activityType: activityType ?? this.activityType,
      weight: weight ?? this.weight,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (activityNumber.present) {
      map['activity_number'] = Variable<String>(activityNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (activityType.present) {
      map['activity_type'] = Variable<String>(activityType.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (ownerUserId.present) {
      map['owner_user_id'] = Variable<int>(ownerUserId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('unitId: $unitId, ')
          ..write('activityNumber: $activityNumber, ')
          ..write('name: $name, ')
          ..write('activityType: $activityType, ')
          ..write('weight: $weight, ')
          ..write('ownerUserId: $ownerUserId, ')
          ..write('description: $description, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ActivityCollaboratorsTable extends ActivityCollaborators
    with TableInfo<$ActivityCollaboratorsTable, ActivityCollaborator> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityCollaboratorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<int> activityId = GeneratedColumn<int>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _collaboratorUnitIdMeta =
      const VerificationMeta('collaboratorUnitId');
  @override
  late final GeneratedColumn<int> collaboratorUnitId = GeneratedColumn<int>(
    'collaborator_unit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES units (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activityId,
    collaboratorUnitId,
    weight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_collaborators';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityCollaborator> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('collaborator_unit_id')) {
      context.handle(
        _collaboratorUnitIdMeta,
        collaboratorUnitId.isAcceptableOrUnknown(
          data['collaborator_unit_id']!,
          _collaboratorUnitIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collaboratorUnitIdMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityCollaborator map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityCollaborator(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_id'],
      )!,
      collaboratorUnitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collaborator_unit_id'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
    );
  }

  @override
  $ActivityCollaboratorsTable createAlias(String alias) {
    return $ActivityCollaboratorsTable(attachedDatabase, alias);
  }
}

class ActivityCollaborator extends DataClass
    implements Insertable<ActivityCollaborator> {
  final int id;
  final int activityId;
  final int collaboratorUnitId;
  final double weight;
  const ActivityCollaborator({
    required this.id,
    required this.activityId,
    required this.collaboratorUnitId,
    required this.weight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['activity_id'] = Variable<int>(activityId);
    map['collaborator_unit_id'] = Variable<int>(collaboratorUnitId);
    map['weight'] = Variable<double>(weight);
    return map;
  }

  ActivityCollaboratorsCompanion toCompanion(bool nullToAbsent) {
    return ActivityCollaboratorsCompanion(
      id: Value(id),
      activityId: Value(activityId),
      collaboratorUnitId: Value(collaboratorUnitId),
      weight: Value(weight),
    );
  }

  factory ActivityCollaborator.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityCollaborator(
      id: serializer.fromJson<int>(json['id']),
      activityId: serializer.fromJson<int>(json['activityId']),
      collaboratorUnitId: serializer.fromJson<int>(json['collaboratorUnitId']),
      weight: serializer.fromJson<double>(json['weight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activityId': serializer.toJson<int>(activityId),
      'collaboratorUnitId': serializer.toJson<int>(collaboratorUnitId),
      'weight': serializer.toJson<double>(weight),
    };
  }

  ActivityCollaborator copyWith({
    int? id,
    int? activityId,
    int? collaboratorUnitId,
    double? weight,
  }) => ActivityCollaborator(
    id: id ?? this.id,
    activityId: activityId ?? this.activityId,
    collaboratorUnitId: collaboratorUnitId ?? this.collaboratorUnitId,
    weight: weight ?? this.weight,
  );
  ActivityCollaborator copyWithCompanion(ActivityCollaboratorsCompanion data) {
    return ActivityCollaborator(
      id: data.id.present ? data.id.value : this.id,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      collaboratorUnitId: data.collaboratorUnitId.present
          ? data.collaboratorUnitId.value
          : this.collaboratorUnitId,
      weight: data.weight.present ? data.weight.value : this.weight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityCollaborator(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('collaboratorUnitId: $collaboratorUnitId, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, activityId, collaboratorUnitId, weight);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityCollaborator &&
          other.id == this.id &&
          other.activityId == this.activityId &&
          other.collaboratorUnitId == this.collaboratorUnitId &&
          other.weight == this.weight);
}

class ActivityCollaboratorsCompanion
    extends UpdateCompanion<ActivityCollaborator> {
  final Value<int> id;
  final Value<int> activityId;
  final Value<int> collaboratorUnitId;
  final Value<double> weight;
  const ActivityCollaboratorsCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.collaboratorUnitId = const Value.absent(),
    this.weight = const Value.absent(),
  });
  ActivityCollaboratorsCompanion.insert({
    this.id = const Value.absent(),
    required int activityId,
    required int collaboratorUnitId,
    this.weight = const Value.absent(),
  }) : activityId = Value(activityId),
       collaboratorUnitId = Value(collaboratorUnitId);
  static Insertable<ActivityCollaborator> custom({
    Expression<int>? id,
    Expression<int>? activityId,
    Expression<int>? collaboratorUnitId,
    Expression<double>? weight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (collaboratorUnitId != null)
        'collaborator_unit_id': collaboratorUnitId,
      if (weight != null) 'weight': weight,
    });
  }

  ActivityCollaboratorsCompanion copyWith({
    Value<int>? id,
    Value<int>? activityId,
    Value<int>? collaboratorUnitId,
    Value<double>? weight,
  }) {
    return ActivityCollaboratorsCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      collaboratorUnitId: collaboratorUnitId ?? this.collaboratorUnitId,
      weight: weight ?? this.weight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<int>(activityId.value);
    }
    if (collaboratorUnitId.present) {
      map['collaborator_unit_id'] = Variable<int>(collaboratorUnitId.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityCollaboratorsCompanion(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('collaboratorUnitId: $collaboratorUnitId, ')
          ..write('weight: $weight')
          ..write(')'))
        .toString();
  }
}

class $TargetsTable extends Targets with TableInfo<$TargetsTable, Target> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TargetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<int> activityId = GeneratedColumn<int>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _yearIdMeta = const VerificationMeta('yearId');
  @override
  late final GeneratedColumn<int> yearId = GeneratedColumn<int>(
    'year_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES years (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startValueMeta = const VerificationMeta(
    'startValue',
  );
  @override
  late final GeneratedColumn<double> startValue = GeneratedColumn<double>(
    'start_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _distributionTypeMeta = const VerificationMeta(
    'distributionType',
  );
  @override
  late final GeneratedColumn<String> distributionType = GeneratedColumn<String>(
    'distribution_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('uniform'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activityId,
    yearId,
    startValue,
    distributionType,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'targets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Target> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('year_id')) {
      context.handle(
        _yearIdMeta,
        yearId.isAcceptableOrUnknown(data['year_id']!, _yearIdMeta),
      );
    } else if (isInserting) {
      context.missing(_yearIdMeta);
    }
    if (data.containsKey('start_value')) {
      context.handle(
        _startValueMeta,
        startValue.isAcceptableOrUnknown(data['start_value']!, _startValueMeta),
      );
    }
    if (data.containsKey('distribution_type')) {
      context.handle(
        _distributionTypeMeta,
        distributionType.isAcceptableOrUnknown(
          data['distribution_type']!,
          _distributionTypeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {activityId, yearId},
  ];
  @override
  Target map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Target(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_id'],
      )!,
      yearId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year_id'],
      )!,
      startValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_value'],
      )!,
      distributionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}distribution_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TargetsTable createAlias(String alias) {
    return $TargetsTable(attachedDatabase, alias);
  }
}

class Target extends DataClass implements Insertable<Target> {
  final int id;
  final int activityId;
  final int yearId;
  final double startValue;
  final String distributionType;
  final DateTime createdAt;
  const Target({
    required this.id,
    required this.activityId,
    required this.yearId,
    required this.startValue,
    required this.distributionType,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['activity_id'] = Variable<int>(activityId);
    map['year_id'] = Variable<int>(yearId);
    map['start_value'] = Variable<double>(startValue);
    map['distribution_type'] = Variable<String>(distributionType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TargetsCompanion toCompanion(bool nullToAbsent) {
    return TargetsCompanion(
      id: Value(id),
      activityId: Value(activityId),
      yearId: Value(yearId),
      startValue: Value(startValue),
      distributionType: Value(distributionType),
      createdAt: Value(createdAt),
    );
  }

  factory Target.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Target(
      id: serializer.fromJson<int>(json['id']),
      activityId: serializer.fromJson<int>(json['activityId']),
      yearId: serializer.fromJson<int>(json['yearId']),
      startValue: serializer.fromJson<double>(json['startValue']),
      distributionType: serializer.fromJson<String>(json['distributionType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activityId': serializer.toJson<int>(activityId),
      'yearId': serializer.toJson<int>(yearId),
      'startValue': serializer.toJson<double>(startValue),
      'distributionType': serializer.toJson<String>(distributionType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Target copyWith({
    int? id,
    int? activityId,
    int? yearId,
    double? startValue,
    String? distributionType,
    DateTime? createdAt,
  }) => Target(
    id: id ?? this.id,
    activityId: activityId ?? this.activityId,
    yearId: yearId ?? this.yearId,
    startValue: startValue ?? this.startValue,
    distributionType: distributionType ?? this.distributionType,
    createdAt: createdAt ?? this.createdAt,
  );
  Target copyWithCompanion(TargetsCompanion data) {
    return Target(
      id: data.id.present ? data.id.value : this.id,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      yearId: data.yearId.present ? data.yearId.value : this.yearId,
      startValue: data.startValue.present
          ? data.startValue.value
          : this.startValue,
      distributionType: data.distributionType.present
          ? data.distributionType.value
          : this.distributionType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Target(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('yearId: $yearId, ')
          ..write('startValue: $startValue, ')
          ..write('distributionType: $distributionType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activityId,
    yearId,
    startValue,
    distributionType,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Target &&
          other.id == this.id &&
          other.activityId == this.activityId &&
          other.yearId == this.yearId &&
          other.startValue == this.startValue &&
          other.distributionType == this.distributionType &&
          other.createdAt == this.createdAt);
}

class TargetsCompanion extends UpdateCompanion<Target> {
  final Value<int> id;
  final Value<int> activityId;
  final Value<int> yearId;
  final Value<double> startValue;
  final Value<String> distributionType;
  final Value<DateTime> createdAt;
  const TargetsCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.yearId = const Value.absent(),
    this.startValue = const Value.absent(),
    this.distributionType = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TargetsCompanion.insert({
    this.id = const Value.absent(),
    required int activityId,
    required int yearId,
    this.startValue = const Value.absent(),
    this.distributionType = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : activityId = Value(activityId),
       yearId = Value(yearId);
  static Insertable<Target> custom({
    Expression<int>? id,
    Expression<int>? activityId,
    Expression<int>? yearId,
    Expression<double>? startValue,
    Expression<String>? distributionType,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (yearId != null) 'year_id': yearId,
      if (startValue != null) 'start_value': startValue,
      if (distributionType != null) 'distribution_type': distributionType,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TargetsCompanion copyWith({
    Value<int>? id,
    Value<int>? activityId,
    Value<int>? yearId,
    Value<double>? startValue,
    Value<String>? distributionType,
    Value<DateTime>? createdAt,
  }) {
    return TargetsCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      yearId: yearId ?? this.yearId,
      startValue: startValue ?? this.startValue,
      distributionType: distributionType ?? this.distributionType,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<int>(activityId.value);
    }
    if (yearId.present) {
      map['year_id'] = Variable<int>(yearId.value);
    }
    if (startValue.present) {
      map['start_value'] = Variable<double>(startValue.value);
    }
    if (distributionType.present) {
      map['distribution_type'] = Variable<String>(distributionType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TargetsCompanion(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('yearId: $yearId, ')
          ..write('startValue: $startValue, ')
          ..write('distributionType: $distributionType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TargetPeriodsTable extends TargetPeriods
    with TableInfo<$TargetPeriodsTable, TargetPeriod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TargetPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<int> targetId = GeneratedColumn<int>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES targets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodIdMeta = const VerificationMeta(
    'periodId',
  );
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
    'period_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES periods (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _targetValueMeta = const VerificationMeta(
    'targetValue',
  );
  @override
  late final GeneratedColumn<double> targetValue = GeneratedColumn<double>(
    'target_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetId,
    periodId,
    targetValue,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'target_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<TargetPeriod> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('period_id')) {
      context.handle(
        _periodIdMeta,
        periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    if (data.containsKey('target_value')) {
      context.handle(
        _targetValueMeta,
        targetValue.isAcceptableOrUnknown(
          data['target_value']!,
          _targetValueMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TargetPeriod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TargetPeriod(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_id'],
      )!,
      periodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_id'],
      )!,
      targetValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_value'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $TargetPeriodsTable createAlias(String alias) {
    return $TargetPeriodsTable(attachedDatabase, alias);
  }
}

class TargetPeriod extends DataClass implements Insertable<TargetPeriod> {
  final int id;
  final int targetId;
  final int periodId;
  final double targetValue;
  final bool isActive;
  const TargetPeriod({
    required this.id,
    required this.targetId,
    required this.periodId,
    required this.targetValue,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_id'] = Variable<int>(targetId);
    map['period_id'] = Variable<int>(periodId);
    map['target_value'] = Variable<double>(targetValue);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  TargetPeriodsCompanion toCompanion(bool nullToAbsent) {
    return TargetPeriodsCompanion(
      id: Value(id),
      targetId: Value(targetId),
      periodId: Value(periodId),
      targetValue: Value(targetValue),
      isActive: Value(isActive),
    );
  }

  factory TargetPeriod.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TargetPeriod(
      id: serializer.fromJson<int>(json['id']),
      targetId: serializer.fromJson<int>(json['targetId']),
      periodId: serializer.fromJson<int>(json['periodId']),
      targetValue: serializer.fromJson<double>(json['targetValue']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetId': serializer.toJson<int>(targetId),
      'periodId': serializer.toJson<int>(periodId),
      'targetValue': serializer.toJson<double>(targetValue),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  TargetPeriod copyWith({
    int? id,
    int? targetId,
    int? periodId,
    double? targetValue,
    bool? isActive,
  }) => TargetPeriod(
    id: id ?? this.id,
    targetId: targetId ?? this.targetId,
    periodId: periodId ?? this.periodId,
    targetValue: targetValue ?? this.targetValue,
    isActive: isActive ?? this.isActive,
  );
  TargetPeriod copyWithCompanion(TargetPeriodsCompanion data) {
    return TargetPeriod(
      id: data.id.present ? data.id.value : this.id,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      targetValue: data.targetValue.present
          ? data.targetValue.value
          : this.targetValue,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TargetPeriod(')
          ..write('id: $id, ')
          ..write('targetId: $targetId, ')
          ..write('periodId: $periodId, ')
          ..write('targetValue: $targetValue, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, targetId, periodId, targetValue, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TargetPeriod &&
          other.id == this.id &&
          other.targetId == this.targetId &&
          other.periodId == this.periodId &&
          other.targetValue == this.targetValue &&
          other.isActive == this.isActive);
}

class TargetPeriodsCompanion extends UpdateCompanion<TargetPeriod> {
  final Value<int> id;
  final Value<int> targetId;
  final Value<int> periodId;
  final Value<double> targetValue;
  final Value<bool> isActive;
  const TargetPeriodsCompanion({
    this.id = const Value.absent(),
    this.targetId = const Value.absent(),
    this.periodId = const Value.absent(),
    this.targetValue = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  TargetPeriodsCompanion.insert({
    this.id = const Value.absent(),
    required int targetId,
    required int periodId,
    this.targetValue = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : targetId = Value(targetId),
       periodId = Value(periodId);
  static Insertable<TargetPeriod> custom({
    Expression<int>? id,
    Expression<int>? targetId,
    Expression<int>? periodId,
    Expression<double>? targetValue,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetId != null) 'target_id': targetId,
      if (periodId != null) 'period_id': periodId,
      if (targetValue != null) 'target_value': targetValue,
      if (isActive != null) 'is_active': isActive,
    });
  }

  TargetPeriodsCompanion copyWith({
    Value<int>? id,
    Value<int>? targetId,
    Value<int>? periodId,
    Value<double>? targetValue,
    Value<bool>? isActive,
  }) {
    return TargetPeriodsCompanion(
      id: id ?? this.id,
      targetId: targetId ?? this.targetId,
      periodId: periodId ?? this.periodId,
      targetValue: targetValue ?? this.targetValue,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<int>(targetId.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (targetValue.present) {
      map['target_value'] = Variable<double>(targetValue.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TargetPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('targetId: $targetId, ')
          ..write('periodId: $periodId, ')
          ..write('targetValue: $targetValue, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ProgressEntriesTable extends ProgressEntries
    with TableInfo<$ProgressEntriesTable, ProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<int> activityId = GeneratedColumn<int>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _periodIdMeta = const VerificationMeta(
    'periodId',
  );
  @override
  late final GeneratedColumn<int> periodId = GeneratedColumn<int>(
    'period_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES periods (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _progressValueMeta = const VerificationMeta(
    'progressValue',
  );
  @override
  late final GeneratedColumn<double> progressValue = GeneratedColumn<double>(
    'progress_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  static const VerificationMeta _currentStepIndexMeta = const VerificationMeta(
    'currentStepIndex',
  );
  @override
  late final GeneratedColumn<int> currentStepIndex = GeneratedColumn<int>(
    'current_step_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _enteredByUserIdMeta = const VerificationMeta(
    'enteredByUserId',
  );
  @override
  late final GeneratedColumn<int> enteredByUserId = GeneratedColumn<int>(
    'entered_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activityId,
    periodId,
    progressValue,
    note,
    status,
    currentStepIndex,
    enteredByUserId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('period_id')) {
      context.handle(
        _periodIdMeta,
        periodId.isAcceptableOrUnknown(data['period_id']!, _periodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_periodIdMeta);
    }
    if (data.containsKey('progress_value')) {
      context.handle(
        _progressValueMeta,
        progressValue.isAcceptableOrUnknown(
          data['progress_value']!,
          _progressValueMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('current_step_index')) {
      context.handle(
        _currentStepIndexMeta,
        currentStepIndex.isAcceptableOrUnknown(
          data['current_step_index']!,
          _currentStepIndexMeta,
        ),
      );
    }
    if (data.containsKey('entered_by_user_id')) {
      context.handle(
        _enteredByUserIdMeta,
        enteredByUserId.isAcceptableOrUnknown(
          data['entered_by_user_id']!,
          _enteredByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {activityId, periodId},
  ];
  @override
  ProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_id'],
      )!,
      periodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_id'],
      )!,
      progressValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}progress_value'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      currentStepIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_step_index'],
      )!,
      enteredByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entered_by_user_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProgressEntriesTable createAlias(String alias) {
    return $ProgressEntriesTable(attachedDatabase, alias);
  }
}

class ProgressEntry extends DataClass implements Insertable<ProgressEntry> {
  final int id;
  final int activityId;
  final int periodId;
  final double progressValue;
  final String? note;
  final String status;
  final int currentStepIndex;
  final int? enteredByUserId;
  final DateTime updatedAt;
  const ProgressEntry({
    required this.id,
    required this.activityId,
    required this.periodId,
    required this.progressValue,
    this.note,
    required this.status,
    required this.currentStepIndex,
    this.enteredByUserId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['activity_id'] = Variable<int>(activityId);
    map['period_id'] = Variable<int>(periodId);
    map['progress_value'] = Variable<double>(progressValue);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['status'] = Variable<String>(status);
    map['current_step_index'] = Variable<int>(currentStepIndex);
    if (!nullToAbsent || enteredByUserId != null) {
      map['entered_by_user_id'] = Variable<int>(enteredByUserId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return ProgressEntriesCompanion(
      id: Value(id),
      activityId: Value(activityId),
      periodId: Value(periodId),
      progressValue: Value(progressValue),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      status: Value(status),
      currentStepIndex: Value(currentStepIndex),
      enteredByUserId: enteredByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(enteredByUserId),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressEntry(
      id: serializer.fromJson<int>(json['id']),
      activityId: serializer.fromJson<int>(json['activityId']),
      periodId: serializer.fromJson<int>(json['periodId']),
      progressValue: serializer.fromJson<double>(json['progressValue']),
      note: serializer.fromJson<String?>(json['note']),
      status: serializer.fromJson<String>(json['status']),
      currentStepIndex: serializer.fromJson<int>(json['currentStepIndex']),
      enteredByUserId: serializer.fromJson<int?>(json['enteredByUserId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activityId': serializer.toJson<int>(activityId),
      'periodId': serializer.toJson<int>(periodId),
      'progressValue': serializer.toJson<double>(progressValue),
      'note': serializer.toJson<String?>(note),
      'status': serializer.toJson<String>(status),
      'currentStepIndex': serializer.toJson<int>(currentStepIndex),
      'enteredByUserId': serializer.toJson<int?>(enteredByUserId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProgressEntry copyWith({
    int? id,
    int? activityId,
    int? periodId,
    double? progressValue,
    Value<String?> note = const Value.absent(),
    String? status,
    int? currentStepIndex,
    Value<int?> enteredByUserId = const Value.absent(),
    DateTime? updatedAt,
  }) => ProgressEntry(
    id: id ?? this.id,
    activityId: activityId ?? this.activityId,
    periodId: periodId ?? this.periodId,
    progressValue: progressValue ?? this.progressValue,
    note: note.present ? note.value : this.note,
    status: status ?? this.status,
    currentStepIndex: currentStepIndex ?? this.currentStepIndex,
    enteredByUserId: enteredByUserId.present
        ? enteredByUserId.value
        : this.enteredByUserId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProgressEntry copyWithCompanion(ProgressEntriesCompanion data) {
    return ProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      periodId: data.periodId.present ? data.periodId.value : this.periodId,
      progressValue: data.progressValue.present
          ? data.progressValue.value
          : this.progressValue,
      note: data.note.present ? data.note.value : this.note,
      status: data.status.present ? data.status.value : this.status,
      currentStepIndex: data.currentStepIndex.present
          ? data.currentStepIndex.value
          : this.currentStepIndex,
      enteredByUserId: data.enteredByUserId.present
          ? data.enteredByUserId.value
          : this.enteredByUserId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressEntry(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('periodId: $periodId, ')
          ..write('progressValue: $progressValue, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('currentStepIndex: $currentStepIndex, ')
          ..write('enteredByUserId: $enteredByUserId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activityId,
    periodId,
    progressValue,
    note,
    status,
    currentStepIndex,
    enteredByUserId,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressEntry &&
          other.id == this.id &&
          other.activityId == this.activityId &&
          other.periodId == this.periodId &&
          other.progressValue == this.progressValue &&
          other.note == this.note &&
          other.status == this.status &&
          other.currentStepIndex == this.currentStepIndex &&
          other.enteredByUserId == this.enteredByUserId &&
          other.updatedAt == this.updatedAt);
}

class ProgressEntriesCompanion extends UpdateCompanion<ProgressEntry> {
  final Value<int> id;
  final Value<int> activityId;
  final Value<int> periodId;
  final Value<double> progressValue;
  final Value<String?> note;
  final Value<String> status;
  final Value<int> currentStepIndex;
  final Value<int?> enteredByUserId;
  final Value<DateTime> updatedAt;
  const ProgressEntriesCompanion({
    this.id = const Value.absent(),
    this.activityId = const Value.absent(),
    this.periodId = const Value.absent(),
    this.progressValue = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.currentStepIndex = const Value.absent(),
    this.enteredByUserId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProgressEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int activityId,
    required int periodId,
    this.progressValue = const Value.absent(),
    this.note = const Value.absent(),
    this.status = const Value.absent(),
    this.currentStepIndex = const Value.absent(),
    this.enteredByUserId = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : activityId = Value(activityId),
       periodId = Value(periodId);
  static Insertable<ProgressEntry> custom({
    Expression<int>? id,
    Expression<int>? activityId,
    Expression<int>? periodId,
    Expression<double>? progressValue,
    Expression<String>? note,
    Expression<String>? status,
    Expression<int>? currentStepIndex,
    Expression<int>? enteredByUserId,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityId != null) 'activity_id': activityId,
      if (periodId != null) 'period_id': periodId,
      if (progressValue != null) 'progress_value': progressValue,
      if (note != null) 'note': note,
      if (status != null) 'status': status,
      if (currentStepIndex != null) 'current_step_index': currentStepIndex,
      if (enteredByUserId != null) 'entered_by_user_id': enteredByUserId,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProgressEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? activityId,
    Value<int>? periodId,
    Value<double>? progressValue,
    Value<String?>? note,
    Value<String>? status,
    Value<int>? currentStepIndex,
    Value<int?>? enteredByUserId,
    Value<DateTime>? updatedAt,
  }) {
    return ProgressEntriesCompanion(
      id: id ?? this.id,
      activityId: activityId ?? this.activityId,
      periodId: periodId ?? this.periodId,
      progressValue: progressValue ?? this.progressValue,
      note: note ?? this.note,
      status: status ?? this.status,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      enteredByUserId: enteredByUserId ?? this.enteredByUserId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<int>(activityId.value);
    }
    if (periodId.present) {
      map['period_id'] = Variable<int>(periodId.value);
    }
    if (progressValue.present) {
      map['progress_value'] = Variable<double>(progressValue.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (currentStepIndex.present) {
      map['current_step_index'] = Variable<int>(currentStepIndex.value);
    }
    if (enteredByUserId.present) {
      map['entered_by_user_id'] = Variable<int>(enteredByUserId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressEntriesCompanion(')
          ..write('id: $id, ')
          ..write('activityId: $activityId, ')
          ..write('periodId: $periodId, ')
          ..write('progressValue: $progressValue, ')
          ..write('note: $note, ')
          ..write('status: $status, ')
          ..write('currentStepIndex: $currentStepIndex, ')
          ..write('enteredByUserId: $enteredByUserId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProgressHistoryTable extends ProgressHistory
    with TableInfo<$ProgressHistoryTable, ProgressHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _progressEntryIdMeta = const VerificationMeta(
    'progressEntryId',
  );
  @override
  late final GeneratedColumn<int> progressEntryId = GeneratedColumn<int>(
    'progress_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES progress_entries (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _oldValueMeta = const VerificationMeta(
    'oldValue',
  );
  @override
  late final GeneratedColumn<double> oldValue = GeneratedColumn<double>(
    'old_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _newValueMeta = const VerificationMeta(
    'newValue',
  );
  @override
  late final GeneratedColumn<double> newValue = GeneratedColumn<double>(
    'new_value',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    progressEntryId,
    userId,
    userName,
    action,
    oldValue,
    newValue,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgressHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('progress_entry_id')) {
      context.handle(
        _progressEntryIdMeta,
        progressEntryId.isAcceptableOrUnknown(
          data['progress_entry_id']!,
          _progressEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_progressEntryIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('old_value')) {
      context.handle(
        _oldValueMeta,
        oldValue.isAcceptableOrUnknown(data['old_value']!, _oldValueMeta),
      );
    }
    if (data.containsKey('new_value')) {
      context.handle(
        _newValueMeta,
        newValue.isAcceptableOrUnknown(data['new_value']!, _newValueMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      progressEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress_entry_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      ),
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      oldValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}old_value'],
      ),
      newValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}new_value'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProgressHistoryTable createAlias(String alias) {
    return $ProgressHistoryTable(attachedDatabase, alias);
  }
}

class ProgressHistoryData extends DataClass
    implements Insertable<ProgressHistoryData> {
  final int id;
  final int progressEntryId;
  final int? userId;
  final String? userName;
  final String action;
  final double? oldValue;
  final double? newValue;
  final String? note;
  final DateTime createdAt;
  const ProgressHistoryData({
    required this.id,
    required this.progressEntryId,
    this.userId,
    this.userName,
    required this.action,
    this.oldValue,
    this.newValue,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['progress_entry_id'] = Variable<int>(progressEntryId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    if (!nullToAbsent || userName != null) {
      map['user_name'] = Variable<String>(userName);
    }
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || oldValue != null) {
      map['old_value'] = Variable<double>(oldValue);
    }
    if (!nullToAbsent || newValue != null) {
      map['new_value'] = Variable<double>(newValue);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProgressHistoryCompanion toCompanion(bool nullToAbsent) {
    return ProgressHistoryCompanion(
      id: Value(id),
      progressEntryId: Value(progressEntryId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      userName: userName == null && nullToAbsent
          ? const Value.absent()
          : Value(userName),
      action: Value(action),
      oldValue: oldValue == null && nullToAbsent
          ? const Value.absent()
          : Value(oldValue),
      newValue: newValue == null && nullToAbsent
          ? const Value.absent()
          : Value(newValue),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory ProgressHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressHistoryData(
      id: serializer.fromJson<int>(json['id']),
      progressEntryId: serializer.fromJson<int>(json['progressEntryId']),
      userId: serializer.fromJson<int?>(json['userId']),
      userName: serializer.fromJson<String?>(json['userName']),
      action: serializer.fromJson<String>(json['action']),
      oldValue: serializer.fromJson<double?>(json['oldValue']),
      newValue: serializer.fromJson<double?>(json['newValue']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'progressEntryId': serializer.toJson<int>(progressEntryId),
      'userId': serializer.toJson<int?>(userId),
      'userName': serializer.toJson<String?>(userName),
      'action': serializer.toJson<String>(action),
      'oldValue': serializer.toJson<double?>(oldValue),
      'newValue': serializer.toJson<double?>(newValue),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProgressHistoryData copyWith({
    int? id,
    int? progressEntryId,
    Value<int?> userId = const Value.absent(),
    Value<String?> userName = const Value.absent(),
    String? action,
    Value<double?> oldValue = const Value.absent(),
    Value<double?> newValue = const Value.absent(),
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => ProgressHistoryData(
    id: id ?? this.id,
    progressEntryId: progressEntryId ?? this.progressEntryId,
    userId: userId.present ? userId.value : this.userId,
    userName: userName.present ? userName.value : this.userName,
    action: action ?? this.action,
    oldValue: oldValue.present ? oldValue.value : this.oldValue,
    newValue: newValue.present ? newValue.value : this.newValue,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  ProgressHistoryData copyWithCompanion(ProgressHistoryCompanion data) {
    return ProgressHistoryData(
      id: data.id.present ? data.id.value : this.id,
      progressEntryId: data.progressEntryId.present
          ? data.progressEntryId.value
          : this.progressEntryId,
      userId: data.userId.present ? data.userId.value : this.userId,
      userName: data.userName.present ? data.userName.value : this.userName,
      action: data.action.present ? data.action.value : this.action,
      oldValue: data.oldValue.present ? data.oldValue.value : this.oldValue,
      newValue: data.newValue.present ? data.newValue.value : this.newValue,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressHistoryData(')
          ..write('id: $id, ')
          ..write('progressEntryId: $progressEntryId, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('action: $action, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    progressEntryId,
    userId,
    userName,
    action,
    oldValue,
    newValue,
    note,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressHistoryData &&
          other.id == this.id &&
          other.progressEntryId == this.progressEntryId &&
          other.userId == this.userId &&
          other.userName == this.userName &&
          other.action == this.action &&
          other.oldValue == this.oldValue &&
          other.newValue == this.newValue &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class ProgressHistoryCompanion extends UpdateCompanion<ProgressHistoryData> {
  final Value<int> id;
  final Value<int> progressEntryId;
  final Value<int?> userId;
  final Value<String?> userName;
  final Value<String> action;
  final Value<double?> oldValue;
  final Value<double?> newValue;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const ProgressHistoryCompanion({
    this.id = const Value.absent(),
    this.progressEntryId = const Value.absent(),
    this.userId = const Value.absent(),
    this.userName = const Value.absent(),
    this.action = const Value.absent(),
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProgressHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int progressEntryId,
    this.userId = const Value.absent(),
    this.userName = const Value.absent(),
    required String action,
    this.oldValue = const Value.absent(),
    this.newValue = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : progressEntryId = Value(progressEntryId),
       action = Value(action);
  static Insertable<ProgressHistoryData> custom({
    Expression<int>? id,
    Expression<int>? progressEntryId,
    Expression<int>? userId,
    Expression<String>? userName,
    Expression<String>? action,
    Expression<double>? oldValue,
    Expression<double>? newValue,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (progressEntryId != null) 'progress_entry_id': progressEntryId,
      if (userId != null) 'user_id': userId,
      if (userName != null) 'user_name': userName,
      if (action != null) 'action': action,
      if (oldValue != null) 'old_value': oldValue,
      if (newValue != null) 'new_value': newValue,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProgressHistoryCompanion copyWith({
    Value<int>? id,
    Value<int>? progressEntryId,
    Value<int?>? userId,
    Value<String?>? userName,
    Value<String>? action,
    Value<double?>? oldValue,
    Value<double?>? newValue,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return ProgressHistoryCompanion(
      id: id ?? this.id,
      progressEntryId: progressEntryId ?? this.progressEntryId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      action: action ?? this.action,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (progressEntryId.present) {
      map['progress_entry_id'] = Variable<int>(progressEntryId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (oldValue.present) {
      map['old_value'] = Variable<double>(oldValue.value);
    }
    if (newValue.present) {
      map['new_value'] = Variable<double>(newValue.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressHistoryCompanion(')
          ..write('id: $id, ')
          ..write('progressEntryId: $progressEntryId, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('action: $action, ')
          ..write('oldValue: $oldValue, ')
          ..write('newValue: $newValue, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AuditLogTable extends AuditLog
    with TableInfo<$AuditLogTable, AuditLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuditLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    action,
    details,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audit_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuditLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuditLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuditLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuditLogTable createAlias(String alias) {
    return $AuditLogTable(attachedDatabase, alias);
  }
}

class AuditLogData extends DataClass implements Insertable<AuditLogData> {
  final int id;
  final int? userId;
  final String action;
  final String? details;
  final DateTime createdAt;
  const AuditLogData({
    required this.id,
    this.userId,
    required this.action,
    this.details,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuditLogCompanion toCompanion(bool nullToAbsent) {
    return AuditLogCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      action: Value(action),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      createdAt: Value(createdAt),
    );
  }

  factory AuditLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuditLogData(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      details: serializer.fromJson<String?>(json['details']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int?>(userId),
      'action': serializer.toJson<String>(action),
      'details': serializer.toJson<String?>(details),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuditLogData copyWith({
    int? id,
    Value<int?> userId = const Value.absent(),
    String? action,
    Value<String?> details = const Value.absent(),
    DateTime? createdAt,
  }) => AuditLogData(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    action: action ?? this.action,
    details: details.present ? details.value : this.details,
    createdAt: createdAt ?? this.createdAt,
  );
  AuditLogData copyWithCompanion(AuditLogCompanion data) {
    return AuditLogData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      details: data.details.present ? data.details.value : this.details,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, action, details, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuditLogData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.details == this.details &&
          other.createdAt == this.createdAt);
}

class AuditLogCompanion extends UpdateCompanion<AuditLogData> {
  final Value<int> id;
  final Value<int?> userId;
  final Value<String> action;
  final Value<String?> details;
  final Value<DateTime> createdAt;
  const AuditLogCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AuditLogCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required String action,
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : action = Value(action);
  static Insertable<AuditLogData> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? action,
    Expression<String>? details,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (details != null) 'details': details,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AuditLogCompanion copyWith({
    Value<int>? id,
    Value<int?>? userId,
    Value<String>? action,
    Value<String?>? details,
    Value<DateTime>? createdAt,
  }) {
    return AuditLogCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuditLogCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RolesTable roles = $RolesTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $UserRolesTable userRoles = $UserRolesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $SessionsTable sessions = $SessionsTable(this);
  late final $YearsTable years = $YearsTable(this);
  late final $PeriodsTable periods = $PeriodsTable(this);
  late final $UnitsTable units = $UnitsTable(this);
  late final $ApprovalStepsTable approvalSteps = $ApprovalStepsTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $ActivityCollaboratorsTable activityCollaborators =
      $ActivityCollaboratorsTable(this);
  late final $TargetsTable targets = $TargetsTable(this);
  late final $TargetPeriodsTable targetPeriods = $TargetPeriodsTable(this);
  late final $ProgressEntriesTable progressEntries = $ProgressEntriesTable(
    this,
  );
  late final $ProgressHistoryTable progressHistory = $ProgressHistoryTable(
    this,
  );
  late final $AuditLogTable auditLog = $AuditLogTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    roles,
    users,
    userRoles,
    appSettings,
    sessions,
    years,
    periods,
    units,
    approvalSteps,
    activities,
    activityCollaborators,
    targets,
    targetPeriods,
    progressEntries,
    progressHistory,
    auditLog,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('user_roles', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'roles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('user_roles', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'users',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'years',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('periods', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'units',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('approval_steps', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'units',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activities', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activity_collaborators', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'units',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('activity_collaborators', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('targets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'years',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('targets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'targets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('target_periods', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'periods',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('target_periods', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'activities',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('progress_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'periods',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('progress_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'progress_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('progress_history', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$RolesTableCreateCompanionBuilder =
    RolesCompanion Function({
      Value<int> id,
      required String code,
      required String title,
      Value<int> level,
      Value<String?> description,
    });
typedef $$RolesTableUpdateCompanionBuilder =
    RolesCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> title,
      Value<int> level,
      Value<String?> description,
    });

final class $$RolesTableReferences
    extends BaseReferences<_$AppDatabase, $RolesTable, Role> {
  $$RolesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserRolesTable, List<UserRole>>
  _userRolesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userRoles,
    aliasName: 'roles__id__user_roles__role_id',
  );

  $$UserRolesTableProcessedTableManager get userRolesRefs {
    final manager = $$UserRolesTableTableManager(
      $_db,
      $_db.userRoles,
    ).filter((f) => f.roleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userRolesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RolesTableFilterComposer extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userRolesRefs(
    Expression<bool> Function($$UserRolesTableFilterComposer f) f,
  ) {
    final $$UserRolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userRoles,
      getReferencedColumn: (t) => t.roleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserRolesTableFilterComposer(
            $db: $db,
            $table: $db.userRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RolesTableOrderingComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RolesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RolesTable> {
  $$RolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  Expression<T> userRolesRefs<T extends Object>(
    Expression<T> Function($$UserRolesTableAnnotationComposer a) f,
  ) {
    final $$UserRolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userRoles,
      getReferencedColumn: (t) => t.roleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserRolesTableAnnotationComposer(
            $db: $db,
            $table: $db.userRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RolesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RolesTable,
          Role,
          $$RolesTableFilterComposer,
          $$RolesTableOrderingComposer,
          $$RolesTableAnnotationComposer,
          $$RolesTableCreateCompanionBuilder,
          $$RolesTableUpdateCompanionBuilder,
          (Role, $$RolesTableReferences),
          Role,
          PrefetchHooks Function({bool userRolesRefs})
        > {
  $$RolesTableTableManager(_$AppDatabase db, $RolesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => RolesCompanion(
                id: id,
                code: code,
                title: title,
                level: level,
                description: description,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String title,
                Value<int> level = const Value.absent(),
                Value<String?> description = const Value.absent(),
              }) => RolesCompanion.insert(
                id: id,
                code: code,
                title: title,
                level: level,
                description: description,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$RolesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({userRolesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (userRolesRefs) db.userRoles],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (userRolesRefs)
                    await $_getPrefetchedData<Role, $RolesTable, UserRole>(
                      currentTable: table,
                      referencedTable: $$RolesTableReferences
                          ._userRolesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$RolesTableReferences(db, table, p0).userRolesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.roleId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$RolesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RolesTable,
      Role,
      $$RolesTableFilterComposer,
      $$RolesTableOrderingComposer,
      $$RolesTableAnnotationComposer,
      $$RolesTableCreateCompanionBuilder,
      $$RolesTableUpdateCompanionBuilder,
      (Role, $$RolesTableReferences),
      Role,
      PrefetchHooks Function({bool userRolesRefs})
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String username,
      required String fullName,
      Value<String?> email,
      Value<String> authType,
      Value<String?> passwordHash,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime?> lastLoginAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> fullName,
      Value<String?> email,
      Value<String> authType,
      Value<String?> passwordHash,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime?> lastLoginAt,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$UserRolesTable, List<UserRole>>
  _userRolesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userRoles,
    aliasName: 'users__id__user_roles__user_id',
  );

  $$UserRolesTableProcessedTableManager get userRolesRefs {
    final manager = $$UserRolesTableTableManager(
      $_db,
      $_db.userRoles,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_userRolesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SessionsTable, List<Session>> _sessionsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sessions,
    aliasName: 'users__id__sessions__user_id',
  );

  $$SessionsTableProcessedTableManager get sessionsRefs {
    final manager = $$SessionsTableTableManager(
      $_db,
      $_db.sessions,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_sessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authType => $composableBuilder(
    column: $table.authType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userRolesRefs(
    Expression<bool> Function($$UserRolesTableFilterComposer f) f,
  ) {
    final $$UserRolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userRoles,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserRolesTableFilterComposer(
            $db: $db,
            $table: $db.userRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sessionsRefs(
    Expression<bool> Function($$SessionsTableFilterComposer f) f,
  ) {
    final $$SessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableFilterComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authType => $composableBuilder(
    column: $table.authType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get authType =>
      $composableBuilder(column: $table.authType, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => column,
  );

  Expression<T> userRolesRefs<T extends Object>(
    Expression<T> Function($$UserRolesTableAnnotationComposer a) f,
  ) {
    final $$UserRolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userRoles,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserRolesTableAnnotationComposer(
            $db: $db,
            $table: $db.userRoles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sessionsRefs<T extends Object>(
    Expression<T> Function($$SessionsTableAnnotationComposer a) f,
  ) {
    final $$SessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sessions,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.sessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool userRolesRefs, bool sessionsRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> authType = const Value.absent(),
                Value<String?> passwordHash = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastLoginAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                fullName: fullName,
                email: email,
                authType: authType,
                passwordHash: passwordHash,
                isActive: isActive,
                createdAt: createdAt,
                lastLoginAt: lastLoginAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required String fullName,
                Value<String?> email = const Value.absent(),
                Value<String> authType = const Value.absent(),
                Value<String?> passwordHash = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastLoginAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                fullName: fullName,
                email: email,
                authType: authType,
                passwordHash: passwordHash,
                isActive: isActive,
                createdAt: createdAt,
                lastLoginAt: lastLoginAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({userRolesRefs = false, sessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (userRolesRefs) db.userRoles,
                    if (sessionsRefs) db.sessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (userRolesRefs)
                        await $_getPrefetchedData<User, $UsersTable, UserRole>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._userRolesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).userRolesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sessionsRefs)
                        await $_getPrefetchedData<User, $UsersTable, Session>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._sessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).sessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool userRolesRefs, bool sessionsRefs})
    >;
typedef $$UserRolesTableCreateCompanionBuilder =
    UserRolesCompanion Function({
      Value<int> id,
      required int userId,
      required int roleId,
    });
typedef $$UserRolesTableUpdateCompanionBuilder =
    UserRolesCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int> roleId,
    });

final class $$UserRolesTableReferences
    extends BaseReferences<_$AppDatabase, $UserRolesTable, UserRole> {
  $$UserRolesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('user_roles__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RolesTable _roleIdTable(_$AppDatabase db) =>
      db.roles.createAlias('user_roles__role_id__roles__id');

  $$RolesTableProcessedTableManager get roleId {
    final $_column = $_itemColumn<int>('role_id')!;

    final manager = $$RolesTableTableManager(
      $_db,
      $_db.roles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_roleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserRolesTableFilterComposer
    extends Composer<_$AppDatabase, $UserRolesTable> {
  $$UserRolesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RolesTableFilterComposer get roleId {
    final $$RolesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableFilterComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserRolesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserRolesTable> {
  $$UserRolesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RolesTableOrderingComposer get roleId {
    final $$RolesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableOrderingComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserRolesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserRolesTable> {
  $$UserRolesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RolesTableAnnotationComposer get roleId {
    final $$RolesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.roleId,
      referencedTable: $db.roles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RolesTableAnnotationComposer(
            $db: $db,
            $table: $db.roles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserRolesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserRolesTable,
          UserRole,
          $$UserRolesTableFilterComposer,
          $$UserRolesTableOrderingComposer,
          $$UserRolesTableAnnotationComposer,
          $$UserRolesTableCreateCompanionBuilder,
          $$UserRolesTableUpdateCompanionBuilder,
          (UserRole, $$UserRolesTableReferences),
          UserRole,
          PrefetchHooks Function({bool userId, bool roleId})
        > {
  $$UserRolesTableTableManager(_$AppDatabase db, $UserRolesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserRolesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserRolesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserRolesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> roleId = const Value.absent(),
              }) => UserRolesCompanion(id: id, userId: userId, roleId: roleId),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int roleId,
              }) => UserRolesCompanion.insert(
                id: id,
                userId: userId,
                roleId: roleId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserRolesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, roleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$UserRolesTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$UserRolesTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (roleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.roleId,
                                referencedTable: $$UserRolesTableReferences
                                    ._roleIdTable(db),
                                referencedColumn: $$UserRolesTableReferences
                                    ._roleIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserRolesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserRolesTable,
      UserRole,
      $$UserRolesTableFilterComposer,
      $$UserRolesTableOrderingComposer,
      $$UserRolesTableAnnotationComposer,
      $$UserRolesTableCreateCompanionBuilder,
      $$UserRolesTableUpdateCompanionBuilder,
      (UserRole, $$UserRolesTableReferences),
      UserRole,
      PrefetchHooks Function({bool userId, bool roleId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      required String key,
      Value<String?> value,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String?> value,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
              }) => AppSettingsCompanion(id: id, key: key, value: value),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                Value<String?> value = const Value.absent(),
              }) => AppSettingsCompanion.insert(id: id, key: key, value: value),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$SessionsTableCreateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      required int userId,
      required String token,
      Value<DateTime> createdAt,
      Value<bool> isActive,
    });
typedef $$SessionsTableUpdateCompanionBuilder =
    SessionsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> token,
      Value<DateTime> createdAt,
      Value<bool> isActive,
    });

final class $$SessionsTableReferences
    extends BaseReferences<_$AppDatabase, $SessionsTable, Session> {
  $$SessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('sessions__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionsTable> {
  $$SessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionsTable,
          Session,
          $$SessionsTableFilterComposer,
          $$SessionsTableOrderingComposer,
          $$SessionsTableAnnotationComposer,
          $$SessionsTableCreateCompanionBuilder,
          $$SessionsTableUpdateCompanionBuilder,
          (Session, $$SessionsTableReferences),
          Session,
          PrefetchHooks Function({bool userId})
        > {
  $$SessionsTableTableManager(_$AppDatabase db, $SessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => SessionsCompanion(
                id: id,
                userId: userId,
                token: token,
                createdAt: createdAt,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String token,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => SessionsCompanion.insert(
                id: id,
                userId: userId,
                token: token,
                createdAt: createdAt,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.userId,
                                referencedTable: $$SessionsTableReferences
                                    ._userIdTable(db),
                                referencedColumn: $$SessionsTableReferences
                                    ._userIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionsTable,
      Session,
      $$SessionsTableFilterComposer,
      $$SessionsTableOrderingComposer,
      $$SessionsTableAnnotationComposer,
      $$SessionsTableCreateCompanionBuilder,
      $$SessionsTableUpdateCompanionBuilder,
      (Session, $$SessionsTableReferences),
      Session,
      PrefetchHooks Function({bool userId})
    >;
typedef $$YearsTableCreateCompanionBuilder =
    YearsCompanion Function({
      Value<int> id,
      required int yearValue,
      required String title,
      required int startJy,
      required int startJm,
      required int startJd,
      required int endJy,
      required int endJm,
      required int endJd,
      Value<DateTime> createdAt,
    });
typedef $$YearsTableUpdateCompanionBuilder =
    YearsCompanion Function({
      Value<int> id,
      Value<int> yearValue,
      Value<String> title,
      Value<int> startJy,
      Value<int> startJm,
      Value<int> startJd,
      Value<int> endJy,
      Value<int> endJm,
      Value<int> endJd,
      Value<DateTime> createdAt,
    });

final class $$YearsTableReferences
    extends BaseReferences<_$AppDatabase, $YearsTable, Year> {
  $$YearsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PeriodsTable, List<Period>> _periodsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.periods,
    aliasName: 'years__id__periods__year_id',
  );

  $$PeriodsTableProcessedTableManager get periodsRefs {
    final manager = $$PeriodsTableTableManager(
      $_db,
      $_db.periods,
    ).filter((f) => f.yearId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_periodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TargetsTable, List<Target>> _targetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.targets,
    aliasName: 'years__id__targets__year_id',
  );

  $$TargetsTableProcessedTableManager get targetsRefs {
    final manager = $$TargetsTableTableManager(
      $_db,
      $_db.targets,
    ).filter((f) => f.yearId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_targetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$YearsTableFilterComposer extends Composer<_$AppDatabase, $YearsTable> {
  $$YearsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yearValue => $composableBuilder(
    column: $table.yearValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startJy => $composableBuilder(
    column: $table.startJy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startJm => $composableBuilder(
    column: $table.startJm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startJd => $composableBuilder(
    column: $table.startJd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endJy => $composableBuilder(
    column: $table.endJy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endJm => $composableBuilder(
    column: $table.endJm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endJd => $composableBuilder(
    column: $table.endJd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> periodsRefs(
    Expression<bool> Function($$PeriodsTableFilterComposer f) f,
  ) {
    final $$PeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.yearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableFilterComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> targetsRefs(
    Expression<bool> Function($$TargetsTableFilterComposer f) f,
  ) {
    final $$TargetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targets,
      getReferencedColumn: (t) => t.yearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetsTableFilterComposer(
            $db: $db,
            $table: $db.targets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$YearsTableOrderingComposer
    extends Composer<_$AppDatabase, $YearsTable> {
  $$YearsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yearValue => $composableBuilder(
    column: $table.yearValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startJy => $composableBuilder(
    column: $table.startJy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startJm => $composableBuilder(
    column: $table.startJm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startJd => $composableBuilder(
    column: $table.startJd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endJy => $composableBuilder(
    column: $table.endJy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endJm => $composableBuilder(
    column: $table.endJm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endJd => $composableBuilder(
    column: $table.endJd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$YearsTableAnnotationComposer
    extends Composer<_$AppDatabase, $YearsTable> {
  $$YearsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get yearValue =>
      $composableBuilder(column: $table.yearValue, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get startJy =>
      $composableBuilder(column: $table.startJy, builder: (column) => column);

  GeneratedColumn<int> get startJm =>
      $composableBuilder(column: $table.startJm, builder: (column) => column);

  GeneratedColumn<int> get startJd =>
      $composableBuilder(column: $table.startJd, builder: (column) => column);

  GeneratedColumn<int> get endJy =>
      $composableBuilder(column: $table.endJy, builder: (column) => column);

  GeneratedColumn<int> get endJm =>
      $composableBuilder(column: $table.endJm, builder: (column) => column);

  GeneratedColumn<int> get endJd =>
      $composableBuilder(column: $table.endJd, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> periodsRefs<T extends Object>(
    Expression<T> Function($$PeriodsTableAnnotationComposer a) f,
  ) {
    final $$PeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.yearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> targetsRefs<T extends Object>(
    Expression<T> Function($$TargetsTableAnnotationComposer a) f,
  ) {
    final $$TargetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targets,
      getReferencedColumn: (t) => t.yearId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetsTableAnnotationComposer(
            $db: $db,
            $table: $db.targets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$YearsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $YearsTable,
          Year,
          $$YearsTableFilterComposer,
          $$YearsTableOrderingComposer,
          $$YearsTableAnnotationComposer,
          $$YearsTableCreateCompanionBuilder,
          $$YearsTableUpdateCompanionBuilder,
          (Year, $$YearsTableReferences),
          Year,
          PrefetchHooks Function({bool periodsRefs, bool targetsRefs})
        > {
  $$YearsTableTableManager(_$AppDatabase db, $YearsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$YearsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$YearsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$YearsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> yearValue = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> startJy = const Value.absent(),
                Value<int> startJm = const Value.absent(),
                Value<int> startJd = const Value.absent(),
                Value<int> endJy = const Value.absent(),
                Value<int> endJm = const Value.absent(),
                Value<int> endJd = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => YearsCompanion(
                id: id,
                yearValue: yearValue,
                title: title,
                startJy: startJy,
                startJm: startJm,
                startJd: startJd,
                endJy: endJy,
                endJm: endJm,
                endJd: endJd,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int yearValue,
                required String title,
                required int startJy,
                required int startJm,
                required int startJd,
                required int endJy,
                required int endJm,
                required int endJd,
                Value<DateTime> createdAt = const Value.absent(),
              }) => YearsCompanion.insert(
                id: id,
                yearValue: yearValue,
                title: title,
                startJy: startJy,
                startJm: startJm,
                startJd: startJd,
                endJy: endJy,
                endJm: endJm,
                endJd: endJd,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$YearsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({periodsRefs = false, targetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (periodsRefs) db.periods,
                if (targetsRefs) db.targets,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (periodsRefs)
                    await $_getPrefetchedData<Year, $YearsTable, Period>(
                      currentTable: table,
                      referencedTable: $$YearsTableReferences._periodsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$YearsTableReferences(db, table, p0).periodsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.yearId == item.id),
                      typedResults: items,
                    ),
                  if (targetsRefs)
                    await $_getPrefetchedData<Year, $YearsTable, Target>(
                      currentTable: table,
                      referencedTable: $$YearsTableReferences._targetsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$YearsTableReferences(db, table, p0).targetsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.yearId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$YearsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $YearsTable,
      Year,
      $$YearsTableFilterComposer,
      $$YearsTableOrderingComposer,
      $$YearsTableAnnotationComposer,
      $$YearsTableCreateCompanionBuilder,
      $$YearsTableUpdateCompanionBuilder,
      (Year, $$YearsTableReferences),
      Year,
      PrefetchHooks Function({bool periodsRefs, bool targetsRefs})
    >;
typedef $$PeriodsTableCreateCompanionBuilder =
    PeriodsCompanion Function({
      Value<int> id,
      required int yearId,
      required int monthNumber,
      required String monthName,
      required String title,
      Value<String> status,
      Value<DateTime> createdAt,
    });
typedef $$PeriodsTableUpdateCompanionBuilder =
    PeriodsCompanion Function({
      Value<int> id,
      Value<int> yearId,
      Value<int> monthNumber,
      Value<String> monthName,
      Value<String> title,
      Value<String> status,
      Value<DateTime> createdAt,
    });

final class $$PeriodsTableReferences
    extends BaseReferences<_$AppDatabase, $PeriodsTable, Period> {
  $$PeriodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $YearsTable _yearIdTable(_$AppDatabase db) =>
      db.years.createAlias('periods__year_id__years__id');

  $$YearsTableProcessedTableManager get yearId {
    final $_column = $_itemColumn<int>('year_id')!;

    final manager = $$YearsTableTableManager(
      $_db,
      $_db.years,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_yearIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TargetPeriodsTable, List<TargetPeriod>>
  _targetPeriodsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.targetPeriods,
    aliasName: 'periods__id__target_periods__period_id',
  );

  $$TargetPeriodsTableProcessedTableManager get targetPeriodsRefs {
    final manager = $$TargetPeriodsTableTableManager(
      $_db,
      $_db.targetPeriods,
    ).filter((f) => f.periodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_targetPeriodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProgressEntriesTable, List<ProgressEntry>>
  _progressEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.progressEntries,
    aliasName: 'periods__id__progress_entries__period_id',
  );

  $$ProgressEntriesTableProcessedTableManager get progressEntriesRefs {
    final manager = $$ProgressEntriesTableTableManager(
      $_db,
      $_db.progressEntries,
    ).filter((f) => f.periodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _progressEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $PeriodsTable> {
  $$PeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthNumber => $composableBuilder(
    column: $table.monthNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get monthName => $composableBuilder(
    column: $table.monthName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$YearsTableFilterComposer get yearId {
    final $$YearsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.years,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YearsTableFilterComposer(
            $db: $db,
            $table: $db.years,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> targetPeriodsRefs(
    Expression<bool> Function($$TargetPeriodsTableFilterComposer f) f,
  ) {
    final $$TargetPeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targetPeriods,
      getReferencedColumn: (t) => t.periodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetPeriodsTableFilterComposer(
            $db: $db,
            $table: $db.targetPeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> progressEntriesRefs(
    Expression<bool> Function($$ProgressEntriesTableFilterComposer f) f,
  ) {
    final $$ProgressEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressEntries,
      getReferencedColumn: (t) => t.periodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressEntriesTableFilterComposer(
            $db: $db,
            $table: $db.progressEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $PeriodsTable> {
  $$PeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthNumber => $composableBuilder(
    column: $table.monthNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get monthName => $composableBuilder(
    column: $table.monthName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$YearsTableOrderingComposer get yearId {
    final $$YearsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.years,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YearsTableOrderingComposer(
            $db: $db,
            $table: $db.years,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeriodsTable> {
  $$PeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get monthNumber => $composableBuilder(
    column: $table.monthNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get monthName =>
      $composableBuilder(column: $table.monthName, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$YearsTableAnnotationComposer get yearId {
    final $$YearsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.years,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YearsTableAnnotationComposer(
            $db: $db,
            $table: $db.years,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> targetPeriodsRefs<T extends Object>(
    Expression<T> Function($$TargetPeriodsTableAnnotationComposer a) f,
  ) {
    final $$TargetPeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targetPeriods,
      getReferencedColumn: (t) => t.periodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetPeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.targetPeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> progressEntriesRefs<T extends Object>(
    Expression<T> Function($$ProgressEntriesTableAnnotationComposer a) f,
  ) {
    final $$ProgressEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressEntries,
      getReferencedColumn: (t) => t.periodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.progressEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeriodsTable,
          Period,
          $$PeriodsTableFilterComposer,
          $$PeriodsTableOrderingComposer,
          $$PeriodsTableAnnotationComposer,
          $$PeriodsTableCreateCompanionBuilder,
          $$PeriodsTableUpdateCompanionBuilder,
          (Period, $$PeriodsTableReferences),
          Period,
          PrefetchHooks Function({
            bool yearId,
            bool targetPeriodsRefs,
            bool progressEntriesRefs,
          })
        > {
  $$PeriodsTableTableManager(_$AppDatabase db, $PeriodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> yearId = const Value.absent(),
                Value<int> monthNumber = const Value.absent(),
                Value<String> monthName = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PeriodsCompanion(
                id: id,
                yearId: yearId,
                monthNumber: monthNumber,
                monthName: monthName,
                title: title,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int yearId,
                required int monthNumber,
                required String monthName,
                required String title,
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PeriodsCompanion.insert(
                id: id,
                yearId: yearId,
                monthNumber: monthNumber,
                monthName: monthName,
                title: title,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PeriodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                yearId = false,
                targetPeriodsRefs = false,
                progressEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (targetPeriodsRefs) db.targetPeriods,
                    if (progressEntriesRefs) db.progressEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (yearId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.yearId,
                                    referencedTable: $$PeriodsTableReferences
                                        ._yearIdTable(db),
                                    referencedColumn: $$PeriodsTableReferences
                                        ._yearIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (targetPeriodsRefs)
                        await $_getPrefetchedData<
                          Period,
                          $PeriodsTable,
                          TargetPeriod
                        >(
                          currentTable: table,
                          referencedTable: $$PeriodsTableReferences
                              ._targetPeriodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeriodsTableReferences(
                                db,
                                table,
                                p0,
                              ).targetPeriodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.periodId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (progressEntriesRefs)
                        await $_getPrefetchedData<
                          Period,
                          $PeriodsTable,
                          ProgressEntry
                        >(
                          currentTable: table,
                          referencedTable: $$PeriodsTableReferences
                              ._progressEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PeriodsTableReferences(
                                db,
                                table,
                                p0,
                              ).progressEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.periodId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeriodsTable,
      Period,
      $$PeriodsTableFilterComposer,
      $$PeriodsTableOrderingComposer,
      $$PeriodsTableAnnotationComposer,
      $$PeriodsTableCreateCompanionBuilder,
      $$PeriodsTableUpdateCompanionBuilder,
      (Period, $$PeriodsTableReferences),
      Period,
      PrefetchHooks Function({
        bool yearId,
        bool targetPeriodsRefs,
        bool progressEntriesRefs,
      })
    >;
typedef $$UnitsTableCreateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      Value<int?> parentId,
      required String name,
      Value<String?> description,
      Value<int> level,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });
typedef $$UnitsTableUpdateCompanionBuilder =
    UnitsCompanion Function({
      Value<int> id,
      Value<int?> parentId,
      Value<String> name,
      Value<String?> description,
      Value<int> level,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });

final class $$UnitsTableReferences
    extends BaseReferences<_$AppDatabase, $UnitsTable, Unit> {
  $$UnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ApprovalStepsTable, List<ApprovalStep>>
  _approvalStepsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.approvalSteps,
    aliasName: 'units__id__approval_steps__unit_id',
  );

  $$ApprovalStepsTableProcessedTableManager get approvalStepsRefs {
    final manager = $$ApprovalStepsTableTableManager(
      $_db,
      $_db.approvalSteps,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_approvalStepsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ActivitiesTable, List<Activity>>
  _activitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activities,
    aliasName: 'units__id__activities__unit_id',
  );

  $$ActivitiesTableProcessedTableManager get activitiesRefs {
    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.unitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_activitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ActivityCollaboratorsTable,
    List<ActivityCollaborator>
  >
  _activityCollaboratorsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityCollaborators,
        aliasName: 'units__id__activity_collaborators__collaborator_unit_id',
      );

  $$ActivityCollaboratorsTableProcessedTableManager
  get activityCollaboratorsRefs {
    final manager =
        $$ActivityCollaboratorsTableTableManager(
          $_db,
          $_db.activityCollaborators,
        ).filter(
          (f) => f.collaboratorUnitId.id.sqlEquals($_itemColumn<int>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _activityCollaboratorsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UnitsTableFilterComposer extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> approvalStepsRefs(
    Expression<bool> Function($$ApprovalStepsTableFilterComposer f) f,
  ) {
    final $$ApprovalStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.approvalSteps,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApprovalStepsTableFilterComposer(
            $db: $db,
            $table: $db.approvalSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activitiesRefs(
    Expression<bool> Function($$ActivitiesTableFilterComposer f) f,
  ) {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activityCollaboratorsRefs(
    Expression<bool> Function($$ActivityCollaboratorsTableFilterComposer f) f,
  ) {
    final $$ActivityCollaboratorsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityCollaborators,
          getReferencedColumn: (t) => t.collaboratorUnitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityCollaboratorsTableFilterComposer(
                $db: $db,
                $table: $db.activityCollaborators,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$UnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnitsTable> {
  $$UnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> approvalStepsRefs<T extends Object>(
    Expression<T> Function($$ApprovalStepsTableAnnotationComposer a) f,
  ) {
    final $$ApprovalStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.approvalSteps,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApprovalStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.approvalSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> activitiesRefs<T extends Object>(
    Expression<T> Function($$ActivitiesTableAnnotationComposer a) f,
  ) {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.unitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> activityCollaboratorsRefs<T extends Object>(
    Expression<T> Function($$ActivityCollaboratorsTableAnnotationComposer a) f,
  ) {
    final $$ActivityCollaboratorsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityCollaborators,
          getReferencedColumn: (t) => t.collaboratorUnitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityCollaboratorsTableAnnotationComposer(
                $db: $db,
                $table: $db.activityCollaborators,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$UnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnitsTable,
          Unit,
          $$UnitsTableFilterComposer,
          $$UnitsTableOrderingComposer,
          $$UnitsTableAnnotationComposer,
          $$UnitsTableCreateCompanionBuilder,
          $$UnitsTableUpdateCompanionBuilder,
          (Unit, $$UnitsTableReferences),
          Unit,
          PrefetchHooks Function({
            bool approvalStepsRefs,
            bool activitiesRefs,
            bool activityCollaboratorsRefs,
          })
        > {
  $$UnitsTableTableManager(_$AppDatabase db, $UnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UnitsCompanion(
                id: id,
                parentId: parentId,
                name: name,
                description: description,
                level: level,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UnitsCompanion.insert(
                id: id,
                parentId: parentId,
                name: name,
                description: description,
                level: level,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UnitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                approvalStepsRefs = false,
                activitiesRefs = false,
                activityCollaboratorsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (approvalStepsRefs) db.approvalSteps,
                    if (activitiesRefs) db.activities,
                    if (activityCollaboratorsRefs) db.activityCollaborators,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (approvalStepsRefs)
                        await $_getPrefetchedData<
                          Unit,
                          $UnitsTable,
                          ApprovalStep
                        >(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences
                              ._approvalStepsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(
                                db,
                                table,
                                p0,
                              ).approvalStepsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activitiesRefs)
                        await $_getPrefetchedData<Unit, $UnitsTable, Activity>(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences
                              ._activitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(
                                db,
                                table,
                                p0,
                              ).activitiesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.unitId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityCollaboratorsRefs)
                        await $_getPrefetchedData<
                          Unit,
                          $UnitsTable,
                          ActivityCollaborator
                        >(
                          currentTable: table,
                          referencedTable: $$UnitsTableReferences
                              ._activityCollaboratorsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UnitsTableReferences(
                                db,
                                table,
                                p0,
                              ).activityCollaboratorsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.collaboratorUnitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnitsTable,
      Unit,
      $$UnitsTableFilterComposer,
      $$UnitsTableOrderingComposer,
      $$UnitsTableAnnotationComposer,
      $$UnitsTableCreateCompanionBuilder,
      $$UnitsTableUpdateCompanionBuilder,
      (Unit, $$UnitsTableReferences),
      Unit,
      PrefetchHooks Function({
        bool approvalStepsRefs,
        bool activitiesRefs,
        bool activityCollaboratorsRefs,
      })
    >;
typedef $$ApprovalStepsTableCreateCompanionBuilder =
    ApprovalStepsCompanion Function({
      Value<int> id,
      required int unitId,
      Value<int> stepOrder,
      Value<String> approvalType,
      Value<String> subjectType,
      Value<int?> roleId,
      Value<int?> userId,
      Value<String?> label,
      Value<DateTime> createdAt,
    });
typedef $$ApprovalStepsTableUpdateCompanionBuilder =
    ApprovalStepsCompanion Function({
      Value<int> id,
      Value<int> unitId,
      Value<int> stepOrder,
      Value<String> approvalType,
      Value<String> subjectType,
      Value<int?> roleId,
      Value<int?> userId,
      Value<String?> label,
      Value<DateTime> createdAt,
    });

final class $$ApprovalStepsTableReferences
    extends BaseReferences<_$AppDatabase, $ApprovalStepsTable, ApprovalStep> {
  $$ApprovalStepsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UnitsTable _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias('approval_steps__unit_id__units__id');

  $$UnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ApprovalStepsTableFilterComposer
    extends Composer<_$AppDatabase, $ApprovalStepsTable> {
  $$ApprovalStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stepOrder => $composableBuilder(
    column: $table.stepOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get approvalType => $composableBuilder(
    column: $table.approvalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subjectType => $composableBuilder(
    column: $table.subjectType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get roleId => $composableBuilder(
    column: $table.roleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApprovalStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $ApprovalStepsTable> {
  $$ApprovalStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stepOrder => $composableBuilder(
    column: $table.stepOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approvalType => $composableBuilder(
    column: $table.approvalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subjectType => $composableBuilder(
    column: $table.subjectType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get roleId => $composableBuilder(
    column: $table.roleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApprovalStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApprovalStepsTable> {
  $$ApprovalStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stepOrder =>
      $composableBuilder(column: $table.stepOrder, builder: (column) => column);

  GeneratedColumn<String> get approvalType => $composableBuilder(
    column: $table.approvalType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subjectType => $composableBuilder(
    column: $table.subjectType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get roleId =>
      $composableBuilder(column: $table.roleId, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApprovalStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApprovalStepsTable,
          ApprovalStep,
          $$ApprovalStepsTableFilterComposer,
          $$ApprovalStepsTableOrderingComposer,
          $$ApprovalStepsTableAnnotationComposer,
          $$ApprovalStepsTableCreateCompanionBuilder,
          $$ApprovalStepsTableUpdateCompanionBuilder,
          (ApprovalStep, $$ApprovalStepsTableReferences),
          ApprovalStep,
          PrefetchHooks Function({bool unitId})
        > {
  $$ApprovalStepsTableTableManager(_$AppDatabase db, $ApprovalStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApprovalStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApprovalStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApprovalStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> unitId = const Value.absent(),
                Value<int> stepOrder = const Value.absent(),
                Value<String> approvalType = const Value.absent(),
                Value<String> subjectType = const Value.absent(),
                Value<int?> roleId = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ApprovalStepsCompanion(
                id: id,
                unitId: unitId,
                stepOrder: stepOrder,
                approvalType: approvalType,
                subjectType: subjectType,
                roleId: roleId,
                userId: userId,
                label: label,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int unitId,
                Value<int> stepOrder = const Value.absent(),
                Value<String> approvalType = const Value.absent(),
                Value<String> subjectType = const Value.absent(),
                Value<int?> roleId = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ApprovalStepsCompanion.insert(
                id: id,
                unitId: unitId,
                stepOrder: stepOrder,
                approvalType: approvalType,
                subjectType: subjectType,
                roleId: roleId,
                userId: userId,
                label: label,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ApprovalStepsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({unitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (unitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.unitId,
                                referencedTable: $$ApprovalStepsTableReferences
                                    ._unitIdTable(db),
                                referencedColumn: $$ApprovalStepsTableReferences
                                    ._unitIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ApprovalStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApprovalStepsTable,
      ApprovalStep,
      $$ApprovalStepsTableFilterComposer,
      $$ApprovalStepsTableOrderingComposer,
      $$ApprovalStepsTableAnnotationComposer,
      $$ApprovalStepsTableCreateCompanionBuilder,
      $$ApprovalStepsTableUpdateCompanionBuilder,
      (ApprovalStep, $$ApprovalStepsTableReferences),
      ApprovalStep,
      PrefetchHooks Function({bool unitId})
    >;
typedef $$ActivitiesTableCreateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int> id,
      required int unitId,
      Value<String?> activityNumber,
      required String name,
      Value<String> activityType,
      Value<double> weight,
      Value<int?> ownerUserId,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$ActivitiesTableUpdateCompanionBuilder =
    ActivitiesCompanion Function({
      Value<int> id,
      Value<int> unitId,
      Value<String?> activityNumber,
      Value<String> name,
      Value<String> activityType,
      Value<double> weight,
      Value<int?> ownerUserId,
      Value<String?> description,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$ActivitiesTableReferences
    extends BaseReferences<_$AppDatabase, $ActivitiesTable, Activity> {
  $$ActivitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UnitsTable _unitIdTable(_$AppDatabase db) =>
      db.units.createAlias('activities__unit_id__units__id');

  $$UnitsTableProcessedTableManager get unitId {
    final $_column = $_itemColumn<int>('unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_unitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $ActivityCollaboratorsTable,
    List<ActivityCollaborator>
  >
  _activityCollaboratorsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.activityCollaborators,
        aliasName: 'activities__id__activity_collaborators__activity_id',
      );

  $$ActivityCollaboratorsTableProcessedTableManager
  get activityCollaboratorsRefs {
    final manager = $$ActivityCollaboratorsTableTableManager(
      $_db,
      $_db.activityCollaborators,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _activityCollaboratorsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TargetsTable, List<Target>> _targetsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.targets,
    aliasName: 'activities__id__targets__activity_id',
  );

  $$TargetsTableProcessedTableManager get targetsRefs {
    final manager = $$TargetsTableTableManager(
      $_db,
      $_db.targets,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_targetsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProgressEntriesTable, List<ProgressEntry>>
  _progressEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.progressEntries,
    aliasName: 'activities__id__progress_entries__activity_id',
  );

  $$ProgressEntriesTableProcessedTableManager get progressEntriesRefs {
    final manager = $$ProgressEntriesTableTableManager(
      $_db,
      $_db.progressEntries,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _progressEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityNumber => $composableBuilder(
    column: $table.activityNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UnitsTableFilterComposer get unitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> activityCollaboratorsRefs(
    Expression<bool> Function($$ActivityCollaboratorsTableFilterComposer f) f,
  ) {
    final $$ActivityCollaboratorsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityCollaborators,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityCollaboratorsTableFilterComposer(
                $db: $db,
                $table: $db.activityCollaborators,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> targetsRefs(
    Expression<bool> Function($$TargetsTableFilterComposer f) f,
  ) {
    final $$TargetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targets,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetsTableFilterComposer(
            $db: $db,
            $table: $db.targets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> progressEntriesRefs(
    Expression<bool> Function($$ProgressEntriesTableFilterComposer f) f,
  ) {
    final $$ProgressEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressEntries,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressEntriesTableFilterComposer(
            $db: $db,
            $table: $db.progressEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityNumber => $composableBuilder(
    column: $table.activityNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UnitsTableOrderingComposer get unitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get activityNumber => $composableBuilder(
    column: $table.activityNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get activityType => $composableBuilder(
    column: $table.activityType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get ownerUserId => $composableBuilder(
    column: $table.ownerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UnitsTableAnnotationComposer get unitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.unitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> activityCollaboratorsRefs<T extends Object>(
    Expression<T> Function($$ActivityCollaboratorsTableAnnotationComposer a) f,
  ) {
    final $$ActivityCollaboratorsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.activityCollaborators,
          getReferencedColumn: (t) => t.activityId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ActivityCollaboratorsTableAnnotationComposer(
                $db: $db,
                $table: $db.activityCollaborators,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> targetsRefs<T extends Object>(
    Expression<T> Function($$TargetsTableAnnotationComposer a) f,
  ) {
    final $$TargetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targets,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetsTableAnnotationComposer(
            $db: $db,
            $table: $db.targets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> progressEntriesRefs<T extends Object>(
    Expression<T> Function($$ProgressEntriesTableAnnotationComposer a) f,
  ) {
    final $$ProgressEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressEntries,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.progressEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          Activity,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (Activity, $$ActivitiesTableReferences),
          Activity,
          PrefetchHooks Function({
            bool unitId,
            bool activityCollaboratorsRefs,
            bool targetsRefs,
            bool progressEntriesRefs,
          })
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> unitId = const Value.absent(),
                Value<String?> activityNumber = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> activityType = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int?> ownerUserId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                unitId: unitId,
                activityNumber: activityNumber,
                name: name,
                activityType: activityType,
                weight: weight,
                ownerUserId: ownerUserId,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int unitId,
                Value<String?> activityNumber = const Value.absent(),
                required String name,
                Value<String> activityType = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int?> ownerUserId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ActivitiesCompanion.insert(
                id: id,
                unitId: unitId,
                activityNumber: activityNumber,
                name: name,
                activityType: activityType,
                weight: weight,
                ownerUserId: ownerUserId,
                description: description,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                unitId = false,
                activityCollaboratorsRefs = false,
                targetsRefs = false,
                progressEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (activityCollaboratorsRefs) db.activityCollaborators,
                    if (targetsRefs) db.targets,
                    if (progressEntriesRefs) db.progressEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (unitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.unitId,
                                    referencedTable: $$ActivitiesTableReferences
                                        ._unitIdTable(db),
                                    referencedColumn:
                                        $$ActivitiesTableReferences
                                            ._unitIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (activityCollaboratorsRefs)
                        await $_getPrefetchedData<
                          Activity,
                          $ActivitiesTable,
                          ActivityCollaborator
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableReferences
                              ._activityCollaboratorsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).activityCollaboratorsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (targetsRefs)
                        await $_getPrefetchedData<
                          Activity,
                          $ActivitiesTable,
                          Target
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableReferences
                              ._targetsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).targetsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (progressEntriesRefs)
                        await $_getPrefetchedData<
                          Activity,
                          $ActivitiesTable,
                          ProgressEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableReferences
                              ._progressEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).progressEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.activityId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      Activity,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (Activity, $$ActivitiesTableReferences),
      Activity,
      PrefetchHooks Function({
        bool unitId,
        bool activityCollaboratorsRefs,
        bool targetsRefs,
        bool progressEntriesRefs,
      })
    >;
typedef $$ActivityCollaboratorsTableCreateCompanionBuilder =
    ActivityCollaboratorsCompanion Function({
      Value<int> id,
      required int activityId,
      required int collaboratorUnitId,
      Value<double> weight,
    });
typedef $$ActivityCollaboratorsTableUpdateCompanionBuilder =
    ActivityCollaboratorsCompanion Function({
      Value<int> id,
      Value<int> activityId,
      Value<int> collaboratorUnitId,
      Value<double> weight,
    });

final class $$ActivityCollaboratorsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ActivityCollaboratorsTable,
          ActivityCollaborator
        > {
  $$ActivityCollaboratorsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) => db.activities
      .createAlias('activity_collaborators__activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<int>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UnitsTable _collaboratorUnitIdTable(_$AppDatabase db) => db.units
      .createAlias('activity_collaborators__collaborator_unit_id__units__id');

  $$UnitsTableProcessedTableManager get collaboratorUnitId {
    final $_column = $_itemColumn<int>('collaborator_unit_id')!;

    final manager = $$UnitsTableTableManager(
      $_db,
      $_db.units,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collaboratorUnitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityCollaboratorsTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityCollaboratorsTable> {
  $$ActivityCollaboratorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableFilterComposer get collaboratorUnitId {
    final $$UnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collaboratorUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableFilterComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityCollaboratorsTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityCollaboratorsTable> {
  $$ActivityCollaboratorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableOrderingComposer get collaboratorUnitId {
    final $$UnitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collaboratorUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableOrderingComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityCollaboratorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityCollaboratorsTable> {
  $$ActivityCollaboratorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UnitsTableAnnotationComposer get collaboratorUnitId {
    final $$UnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collaboratorUnitId,
      referencedTable: $db.units,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.units,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityCollaboratorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityCollaboratorsTable,
          ActivityCollaborator,
          $$ActivityCollaboratorsTableFilterComposer,
          $$ActivityCollaboratorsTableOrderingComposer,
          $$ActivityCollaboratorsTableAnnotationComposer,
          $$ActivityCollaboratorsTableCreateCompanionBuilder,
          $$ActivityCollaboratorsTableUpdateCompanionBuilder,
          (ActivityCollaborator, $$ActivityCollaboratorsTableReferences),
          ActivityCollaborator,
          PrefetchHooks Function({bool activityId, bool collaboratorUnitId})
        > {
  $$ActivityCollaboratorsTableTableManager(
    _$AppDatabase db,
    $ActivityCollaboratorsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityCollaboratorsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$ActivityCollaboratorsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ActivityCollaboratorsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> activityId = const Value.absent(),
                Value<int> collaboratorUnitId = const Value.absent(),
                Value<double> weight = const Value.absent(),
              }) => ActivityCollaboratorsCompanion(
                id: id,
                activityId: activityId,
                collaboratorUnitId: collaboratorUnitId,
                weight: weight,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int activityId,
                required int collaboratorUnitId,
                Value<double> weight = const Value.absent(),
              }) => ActivityCollaboratorsCompanion.insert(
                id: id,
                activityId: activityId,
                collaboratorUnitId: collaboratorUnitId,
                weight: weight,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityCollaboratorsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({activityId = false, collaboratorUnitId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (activityId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.activityId,
                                    referencedTable:
                                        $$ActivityCollaboratorsTableReferences
                                            ._activityIdTable(db),
                                    referencedColumn:
                                        $$ActivityCollaboratorsTableReferences
                                            ._activityIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (collaboratorUnitId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.collaboratorUnitId,
                                    referencedTable:
                                        $$ActivityCollaboratorsTableReferences
                                            ._collaboratorUnitIdTable(db),
                                    referencedColumn:
                                        $$ActivityCollaboratorsTableReferences
                                            ._collaboratorUnitIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ActivityCollaboratorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityCollaboratorsTable,
      ActivityCollaborator,
      $$ActivityCollaboratorsTableFilterComposer,
      $$ActivityCollaboratorsTableOrderingComposer,
      $$ActivityCollaboratorsTableAnnotationComposer,
      $$ActivityCollaboratorsTableCreateCompanionBuilder,
      $$ActivityCollaboratorsTableUpdateCompanionBuilder,
      (ActivityCollaborator, $$ActivityCollaboratorsTableReferences),
      ActivityCollaborator,
      PrefetchHooks Function({bool activityId, bool collaboratorUnitId})
    >;
typedef $$TargetsTableCreateCompanionBuilder =
    TargetsCompanion Function({
      Value<int> id,
      required int activityId,
      required int yearId,
      Value<double> startValue,
      Value<String> distributionType,
      Value<DateTime> createdAt,
    });
typedef $$TargetsTableUpdateCompanionBuilder =
    TargetsCompanion Function({
      Value<int> id,
      Value<int> activityId,
      Value<int> yearId,
      Value<double> startValue,
      Value<String> distributionType,
      Value<DateTime> createdAt,
    });

final class $$TargetsTableReferences
    extends BaseReferences<_$AppDatabase, $TargetsTable, Target> {
  $$TargetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias('targets__activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<int>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $YearsTable _yearIdTable(_$AppDatabase db) =>
      db.years.createAlias('targets__year_id__years__id');

  $$YearsTableProcessedTableManager get yearId {
    final $_column = $_itemColumn<int>('year_id')!;

    final manager = $$YearsTableTableManager(
      $_db,
      $_db.years,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_yearIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TargetPeriodsTable, List<TargetPeriod>>
  _targetPeriodsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.targetPeriods,
    aliasName: 'targets__id__target_periods__target_id',
  );

  $$TargetPeriodsTableProcessedTableManager get targetPeriodsRefs {
    final manager = $$TargetPeriodsTableTableManager(
      $_db,
      $_db.targetPeriods,
    ).filter((f) => f.targetId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_targetPeriodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TargetsTableFilterComposer
    extends Composer<_$AppDatabase, $TargetsTable> {
  $$TargetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startValue => $composableBuilder(
    column: $table.startValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get distributionType => $composableBuilder(
    column: $table.distributionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$YearsTableFilterComposer get yearId {
    final $$YearsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.years,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YearsTableFilterComposer(
            $db: $db,
            $table: $db.years,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> targetPeriodsRefs(
    Expression<bool> Function($$TargetPeriodsTableFilterComposer f) f,
  ) {
    final $$TargetPeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targetPeriods,
      getReferencedColumn: (t) => t.targetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetPeriodsTableFilterComposer(
            $db: $db,
            $table: $db.targetPeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TargetsTableOrderingComposer
    extends Composer<_$AppDatabase, $TargetsTable> {
  $$TargetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startValue => $composableBuilder(
    column: $table.startValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get distributionType => $composableBuilder(
    column: $table.distributionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$YearsTableOrderingComposer get yearId {
    final $$YearsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.years,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YearsTableOrderingComposer(
            $db: $db,
            $table: $db.years,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TargetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TargetsTable> {
  $$TargetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get startValue => $composableBuilder(
    column: $table.startValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get distributionType => $composableBuilder(
    column: $table.distributionType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$YearsTableAnnotationComposer get yearId {
    final $$YearsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.yearId,
      referencedTable: $db.years,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$YearsTableAnnotationComposer(
            $db: $db,
            $table: $db.years,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> targetPeriodsRefs<T extends Object>(
    Expression<T> Function($$TargetPeriodsTableAnnotationComposer a) f,
  ) {
    final $$TargetPeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.targetPeriods,
      getReferencedColumn: (t) => t.targetId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetPeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.targetPeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TargetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TargetsTable,
          Target,
          $$TargetsTableFilterComposer,
          $$TargetsTableOrderingComposer,
          $$TargetsTableAnnotationComposer,
          $$TargetsTableCreateCompanionBuilder,
          $$TargetsTableUpdateCompanionBuilder,
          (Target, $$TargetsTableReferences),
          Target,
          PrefetchHooks Function({
            bool activityId,
            bool yearId,
            bool targetPeriodsRefs,
          })
        > {
  $$TargetsTableTableManager(_$AppDatabase db, $TargetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TargetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TargetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TargetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> activityId = const Value.absent(),
                Value<int> yearId = const Value.absent(),
                Value<double> startValue = const Value.absent(),
                Value<String> distributionType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TargetsCompanion(
                id: id,
                activityId: activityId,
                yearId: yearId,
                startValue: startValue,
                distributionType: distributionType,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int activityId,
                required int yearId,
                Value<double> startValue = const Value.absent(),
                Value<String> distributionType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TargetsCompanion.insert(
                id: id,
                activityId: activityId,
                yearId: yearId,
                startValue: startValue,
                distributionType: distributionType,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TargetsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                activityId = false,
                yearId = false,
                targetPeriodsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (targetPeriodsRefs) db.targetPeriods,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (activityId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.activityId,
                                    referencedTable: $$TargetsTableReferences
                                        ._activityIdTable(db),
                                    referencedColumn: $$TargetsTableReferences
                                        ._activityIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (yearId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.yearId,
                                    referencedTable: $$TargetsTableReferences
                                        ._yearIdTable(db),
                                    referencedColumn: $$TargetsTableReferences
                                        ._yearIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (targetPeriodsRefs)
                        await $_getPrefetchedData<
                          Target,
                          $TargetsTable,
                          TargetPeriod
                        >(
                          currentTable: table,
                          referencedTable: $$TargetsTableReferences
                              ._targetPeriodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TargetsTableReferences(
                                db,
                                table,
                                p0,
                              ).targetPeriodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.targetId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TargetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TargetsTable,
      Target,
      $$TargetsTableFilterComposer,
      $$TargetsTableOrderingComposer,
      $$TargetsTableAnnotationComposer,
      $$TargetsTableCreateCompanionBuilder,
      $$TargetsTableUpdateCompanionBuilder,
      (Target, $$TargetsTableReferences),
      Target,
      PrefetchHooks Function({
        bool activityId,
        bool yearId,
        bool targetPeriodsRefs,
      })
    >;
typedef $$TargetPeriodsTableCreateCompanionBuilder =
    TargetPeriodsCompanion Function({
      Value<int> id,
      required int targetId,
      required int periodId,
      Value<double> targetValue,
      Value<bool> isActive,
    });
typedef $$TargetPeriodsTableUpdateCompanionBuilder =
    TargetPeriodsCompanion Function({
      Value<int> id,
      Value<int> targetId,
      Value<int> periodId,
      Value<double> targetValue,
      Value<bool> isActive,
    });

final class $$TargetPeriodsTableReferences
    extends BaseReferences<_$AppDatabase, $TargetPeriodsTable, TargetPeriod> {
  $$TargetPeriodsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TargetsTable _targetIdTable(_$AppDatabase db) =>
      db.targets.createAlias('target_periods__target_id__targets__id');

  $$TargetsTableProcessedTableManager get targetId {
    final $_column = $_itemColumn<int>('target_id')!;

    final manager = $$TargetsTableTableManager(
      $_db,
      $_db.targets,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PeriodsTable _periodIdTable(_$AppDatabase db) =>
      db.periods.createAlias('target_periods__period_id__periods__id');

  $$PeriodsTableProcessedTableManager get periodId {
    final $_column = $_itemColumn<int>('period_id')!;

    final manager = $$PeriodsTableTableManager(
      $_db,
      $_db.periods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TargetPeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $TargetPeriodsTable> {
  $$TargetPeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$TargetsTableFilterComposer get targetId {
    final $$TargetsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetId,
      referencedTable: $db.targets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetsTableFilterComposer(
            $db: $db,
            $table: $db.targets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableFilterComposer get periodId {
    final $$PeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableFilterComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TargetPeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $TargetPeriodsTable> {
  $$TargetPeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$TargetsTableOrderingComposer get targetId {
    final $$TargetsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetId,
      referencedTable: $db.targets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetsTableOrderingComposer(
            $db: $db,
            $table: $db.targets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableOrderingComposer get periodId {
    final $$PeriodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableOrderingComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TargetPeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TargetPeriodsTable> {
  $$TargetPeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get targetValue => $composableBuilder(
    column: $table.targetValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$TargetsTableAnnotationComposer get targetId {
    final $$TargetsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.targetId,
      referencedTable: $db.targets,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TargetsTableAnnotationComposer(
            $db: $db,
            $table: $db.targets,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableAnnotationComposer get periodId {
    final $$PeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TargetPeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TargetPeriodsTable,
          TargetPeriod,
          $$TargetPeriodsTableFilterComposer,
          $$TargetPeriodsTableOrderingComposer,
          $$TargetPeriodsTableAnnotationComposer,
          $$TargetPeriodsTableCreateCompanionBuilder,
          $$TargetPeriodsTableUpdateCompanionBuilder,
          (TargetPeriod, $$TargetPeriodsTableReferences),
          TargetPeriod,
          PrefetchHooks Function({bool targetId, bool periodId})
        > {
  $$TargetPeriodsTableTableManager(_$AppDatabase db, $TargetPeriodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TargetPeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TargetPeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TargetPeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> targetId = const Value.absent(),
                Value<int> periodId = const Value.absent(),
                Value<double> targetValue = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TargetPeriodsCompanion(
                id: id,
                targetId: targetId,
                periodId: periodId,
                targetValue: targetValue,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int targetId,
                required int periodId,
                Value<double> targetValue = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => TargetPeriodsCompanion.insert(
                id: id,
                targetId: targetId,
                periodId: periodId,
                targetValue: targetValue,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TargetPeriodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({targetId = false, periodId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (targetId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.targetId,
                                referencedTable: $$TargetPeriodsTableReferences
                                    ._targetIdTable(db),
                                referencedColumn: $$TargetPeriodsTableReferences
                                    ._targetIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (periodId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.periodId,
                                referencedTable: $$TargetPeriodsTableReferences
                                    ._periodIdTable(db),
                                referencedColumn: $$TargetPeriodsTableReferences
                                    ._periodIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TargetPeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TargetPeriodsTable,
      TargetPeriod,
      $$TargetPeriodsTableFilterComposer,
      $$TargetPeriodsTableOrderingComposer,
      $$TargetPeriodsTableAnnotationComposer,
      $$TargetPeriodsTableCreateCompanionBuilder,
      $$TargetPeriodsTableUpdateCompanionBuilder,
      (TargetPeriod, $$TargetPeriodsTableReferences),
      TargetPeriod,
      PrefetchHooks Function({bool targetId, bool periodId})
    >;
typedef $$ProgressEntriesTableCreateCompanionBuilder =
    ProgressEntriesCompanion Function({
      Value<int> id,
      required int activityId,
      required int periodId,
      Value<double> progressValue,
      Value<String?> note,
      Value<String> status,
      Value<int> currentStepIndex,
      Value<int?> enteredByUserId,
      Value<DateTime> updatedAt,
    });
typedef $$ProgressEntriesTableUpdateCompanionBuilder =
    ProgressEntriesCompanion Function({
      Value<int> id,
      Value<int> activityId,
      Value<int> periodId,
      Value<double> progressValue,
      Value<String?> note,
      Value<String> status,
      Value<int> currentStepIndex,
      Value<int?> enteredByUserId,
      Value<DateTime> updatedAt,
    });

final class $$ProgressEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProgressEntriesTable, ProgressEntry> {
  $$ProgressEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) => db.activities
      .createAlias('progress_entries__activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<int>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PeriodsTable _periodIdTable(_$AppDatabase db) =>
      db.periods.createAlias('progress_entries__period_id__periods__id');

  $$PeriodsTableProcessedTableManager get periodId {
    final $_column = $_itemColumn<int>('period_id')!;

    final manager = $$PeriodsTableTableManager(
      $_db,
      $_db.periods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_periodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ProgressHistoryTable, List<ProgressHistoryData>>
  _progressHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.progressHistory,
    aliasName: 'progress_entries__id__progress_history__progress_entry_id',
  );

  $$ProgressHistoryTableProcessedTableManager get progressHistoryRefs {
    final manager = $$ProgressHistoryTableTableManager(
      $_db,
      $_db.progressHistory,
    ).filter((f) => f.progressEntryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _progressHistoryRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get progressValue => $composableBuilder(
    column: $table.progressValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStepIndex => $composableBuilder(
    column: $table.currentStepIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get enteredByUserId => $composableBuilder(
    column: $table.enteredByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableFilterComposer get periodId {
    final $$PeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableFilterComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> progressHistoryRefs(
    Expression<bool> Function($$ProgressHistoryTableFilterComposer f) f,
  ) {
    final $$ProgressHistoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressHistory,
      getReferencedColumn: (t) => t.progressEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressHistoryTableFilterComposer(
            $db: $db,
            $table: $db.progressHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get progressValue => $composableBuilder(
    column: $table.progressValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStepIndex => $composableBuilder(
    column: $table.currentStepIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get enteredByUserId => $composableBuilder(
    column: $table.enteredByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableOrderingComposer get periodId {
    final $$PeriodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableOrderingComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressEntriesTable> {
  $$ProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get progressValue => $composableBuilder(
    column: $table.progressValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get currentStepIndex => $composableBuilder(
    column: $table.currentStepIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get enteredByUserId => $composableBuilder(
    column: $table.enteredByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PeriodsTableAnnotationComposer get periodId {
    final $$PeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.periodId,
      referencedTable: $db.periods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.periods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> progressHistoryRefs<T extends Object>(
    Expression<T> Function($$ProgressHistoryTableAnnotationComposer a) f,
  ) {
    final $$ProgressHistoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.progressHistory,
      getReferencedColumn: (t) => t.progressEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressHistoryTableAnnotationComposer(
            $db: $db,
            $table: $db.progressHistory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressEntriesTable,
          ProgressEntry,
          $$ProgressEntriesTableFilterComposer,
          $$ProgressEntriesTableOrderingComposer,
          $$ProgressEntriesTableAnnotationComposer,
          $$ProgressEntriesTableCreateCompanionBuilder,
          $$ProgressEntriesTableUpdateCompanionBuilder,
          (ProgressEntry, $$ProgressEntriesTableReferences),
          ProgressEntry,
          PrefetchHooks Function({
            bool activityId,
            bool periodId,
            bool progressHistoryRefs,
          })
        > {
  $$ProgressEntriesTableTableManager(
    _$AppDatabase db,
    $ProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> activityId = const Value.absent(),
                Value<int> periodId = const Value.absent(),
                Value<double> progressValue = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> currentStepIndex = const Value.absent(),
                Value<int?> enteredByUserId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProgressEntriesCompanion(
                id: id,
                activityId: activityId,
                periodId: periodId,
                progressValue: progressValue,
                note: note,
                status: status,
                currentStepIndex: currentStepIndex,
                enteredByUserId: enteredByUserId,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int activityId,
                required int periodId,
                Value<double> progressValue = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> currentStepIndex = const Value.absent(),
                Value<int?> enteredByUserId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProgressEntriesCompanion.insert(
                id: id,
                activityId: activityId,
                periodId: periodId,
                progressValue: progressValue,
                note: note,
                status: status,
                currentStepIndex: currentStepIndex,
                enteredByUserId: enteredByUserId,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProgressEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                activityId = false,
                periodId = false,
                progressHistoryRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (progressHistoryRefs) db.progressHistory,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (activityId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.activityId,
                                    referencedTable:
                                        $$ProgressEntriesTableReferences
                                            ._activityIdTable(db),
                                    referencedColumn:
                                        $$ProgressEntriesTableReferences
                                            ._activityIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (periodId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.periodId,
                                    referencedTable:
                                        $$ProgressEntriesTableReferences
                                            ._periodIdTable(db),
                                    referencedColumn:
                                        $$ProgressEntriesTableReferences
                                            ._periodIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (progressHistoryRefs)
                        await $_getPrefetchedData<
                          ProgressEntry,
                          $ProgressEntriesTable,
                          ProgressHistoryData
                        >(
                          currentTable: table,
                          referencedTable: $$ProgressEntriesTableReferences
                              ._progressHistoryRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProgressEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).progressHistoryRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.progressEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressEntriesTable,
      ProgressEntry,
      $$ProgressEntriesTableFilterComposer,
      $$ProgressEntriesTableOrderingComposer,
      $$ProgressEntriesTableAnnotationComposer,
      $$ProgressEntriesTableCreateCompanionBuilder,
      $$ProgressEntriesTableUpdateCompanionBuilder,
      (ProgressEntry, $$ProgressEntriesTableReferences),
      ProgressEntry,
      PrefetchHooks Function({
        bool activityId,
        bool periodId,
        bool progressHistoryRefs,
      })
    >;
typedef $$ProgressHistoryTableCreateCompanionBuilder =
    ProgressHistoryCompanion Function({
      Value<int> id,
      required int progressEntryId,
      Value<int?> userId,
      Value<String?> userName,
      required String action,
      Value<double?> oldValue,
      Value<double?> newValue,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$ProgressHistoryTableUpdateCompanionBuilder =
    ProgressHistoryCompanion Function({
      Value<int> id,
      Value<int> progressEntryId,
      Value<int?> userId,
      Value<String?> userName,
      Value<String> action,
      Value<double?> oldValue,
      Value<double?> newValue,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

final class $$ProgressHistoryTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProgressHistoryTable,
          ProgressHistoryData
        > {
  $$ProgressHistoryTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProgressEntriesTable _progressEntryIdTable(_$AppDatabase db) => db
      .progressEntries
      .createAlias('progress_history__progress_entry_id__progress_entries__id');

  $$ProgressEntriesTableProcessedTableManager get progressEntryId {
    final $_column = $_itemColumn<int>('progress_entry_id')!;

    final manager = $$ProgressEntriesTableTableManager(
      $_db,
      $_db.progressEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_progressEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProgressHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ProgressHistoryTable> {
  $$ProgressHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProgressEntriesTableFilterComposer get progressEntryId {
    final $$ProgressEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.progressEntryId,
      referencedTable: $db.progressEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressEntriesTableFilterComposer(
            $db: $db,
            $table: $db.progressEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgressHistoryTable> {
  $$ProgressHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get oldValue => $composableBuilder(
    column: $table.oldValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get newValue => $composableBuilder(
    column: $table.newValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProgressEntriesTableOrderingComposer get progressEntryId {
    final $$ProgressEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.progressEntryId,
      referencedTable: $db.progressEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.progressEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgressHistoryTable> {
  $$ProgressHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<double> get oldValue =>
      $composableBuilder(column: $table.oldValue, builder: (column) => column);

  GeneratedColumn<double> get newValue =>
      $composableBuilder(column: $table.newValue, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProgressEntriesTableAnnotationComposer get progressEntryId {
    final $$ProgressEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.progressEntryId,
      referencedTable: $db.progressEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProgressEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.progressEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProgressHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgressHistoryTable,
          ProgressHistoryData,
          $$ProgressHistoryTableFilterComposer,
          $$ProgressHistoryTableOrderingComposer,
          $$ProgressHistoryTableAnnotationComposer,
          $$ProgressHistoryTableCreateCompanionBuilder,
          $$ProgressHistoryTableUpdateCompanionBuilder,
          (ProgressHistoryData, $$ProgressHistoryTableReferences),
          ProgressHistoryData,
          PrefetchHooks Function({bool progressEntryId})
        > {
  $$ProgressHistoryTableTableManager(
    _$AppDatabase db,
    $ProgressHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgressHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgressHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgressHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> progressEntryId = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String?> userName = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<double?> oldValue = const Value.absent(),
                Value<double?> newValue = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProgressHistoryCompanion(
                id: id,
                progressEntryId: progressEntryId,
                userId: userId,
                userName: userName,
                action: action,
                oldValue: oldValue,
                newValue: newValue,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int progressEntryId,
                Value<int?> userId = const Value.absent(),
                Value<String?> userName = const Value.absent(),
                required String action,
                Value<double?> oldValue = const Value.absent(),
                Value<double?> newValue = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProgressHistoryCompanion.insert(
                id: id,
                progressEntryId: progressEntryId,
                userId: userId,
                userName: userName,
                action: action,
                oldValue: oldValue,
                newValue: newValue,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProgressHistoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({progressEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (progressEntryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.progressEntryId,
                                referencedTable:
                                    $$ProgressHistoryTableReferences
                                        ._progressEntryIdTable(db),
                                referencedColumn:
                                    $$ProgressHistoryTableReferences
                                        ._progressEntryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProgressHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgressHistoryTable,
      ProgressHistoryData,
      $$ProgressHistoryTableFilterComposer,
      $$ProgressHistoryTableOrderingComposer,
      $$ProgressHistoryTableAnnotationComposer,
      $$ProgressHistoryTableCreateCompanionBuilder,
      $$ProgressHistoryTableUpdateCompanionBuilder,
      (ProgressHistoryData, $$ProgressHistoryTableReferences),
      ProgressHistoryData,
      PrefetchHooks Function({bool progressEntryId})
    >;
typedef $$AuditLogTableCreateCompanionBuilder =
    AuditLogCompanion Function({
      Value<int> id,
      Value<int?> userId,
      required String action,
      Value<String?> details,
      Value<DateTime> createdAt,
    });
typedef $$AuditLogTableUpdateCompanionBuilder =
    AuditLogCompanion Function({
      Value<int> id,
      Value<int?> userId,
      Value<String> action,
      Value<String?> details,
      Value<DateTime> createdAt,
    });

class $$AuditLogTableFilterComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuditLogTableOrderingComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuditLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuditLogTable> {
  $$AuditLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuditLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuditLogTable,
          AuditLogData,
          $$AuditLogTableFilterComposer,
          $$AuditLogTableOrderingComposer,
          $$AuditLogTableAnnotationComposer,
          $$AuditLogTableCreateCompanionBuilder,
          $$AuditLogTableUpdateCompanionBuilder,
          (
            AuditLogData,
            BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
          ),
          AuditLogData,
          PrefetchHooks Function()
        > {
  $$AuditLogTableTableManager(_$AppDatabase db, $AuditLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuditLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuditLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuditLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AuditLogCompanion(
                id: id,
                userId: userId,
                action: action,
                details: details,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                required String action,
                Value<String?> details = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AuditLogCompanion.insert(
                id: id,
                userId: userId,
                action: action,
                details: details,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuditLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuditLogTable,
      AuditLogData,
      $$AuditLogTableFilterComposer,
      $$AuditLogTableOrderingComposer,
      $$AuditLogTableAnnotationComposer,
      $$AuditLogTableCreateCompanionBuilder,
      $$AuditLogTableUpdateCompanionBuilder,
      (
        AuditLogData,
        BaseReferences<_$AppDatabase, $AuditLogTable, AuditLogData>,
      ),
      AuditLogData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RolesTableTableManager get roles =>
      $$RolesTableTableManager(_db, _db.roles);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$UserRolesTableTableManager get userRoles =>
      $$UserRolesTableTableManager(_db, _db.userRoles);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$SessionsTableTableManager get sessions =>
      $$SessionsTableTableManager(_db, _db.sessions);
  $$YearsTableTableManager get years =>
      $$YearsTableTableManager(_db, _db.years);
  $$PeriodsTableTableManager get periods =>
      $$PeriodsTableTableManager(_db, _db.periods);
  $$UnitsTableTableManager get units =>
      $$UnitsTableTableManager(_db, _db.units);
  $$ApprovalStepsTableTableManager get approvalSteps =>
      $$ApprovalStepsTableTableManager(_db, _db.approvalSteps);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$ActivityCollaboratorsTableTableManager get activityCollaborators =>
      $$ActivityCollaboratorsTableTableManager(_db, _db.activityCollaborators);
  $$TargetsTableTableManager get targets =>
      $$TargetsTableTableManager(_db, _db.targets);
  $$TargetPeriodsTableTableManager get targetPeriods =>
      $$TargetPeriodsTableTableManager(_db, _db.targetPeriods);
  $$ProgressEntriesTableTableManager get progressEntries =>
      $$ProgressEntriesTableTableManager(_db, _db.progressEntries);
  $$ProgressHistoryTableTableManager get progressHistory =>
      $$ProgressHistoryTableTableManager(_db, _db.progressHistory);
  $$AuditLogTableTableManager get auditLog =>
      $$AuditLogTableTableManager(_db, _db.auditLog);
}
