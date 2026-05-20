// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database_drift.dart';

// ignore_for_file: type=lint
class $SyncRecordsTable extends SyncRecords
    with TableInfo<$SyncRecordsTable, SyncRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cacheKeyMeta = const VerificationMeta(
    'cacheKey',
  );
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
    'cache_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _modelTypeMeta = const VerificationMeta(
    'modelType',
  );
  @override
  late final GeneratedColumn<String> modelType = GeneratedColumn<String>(
    'model_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordUuidMeta = const VerificationMeta(
    'recordUuid',
  );
  @override
  late final GeneratedColumn<String> recordUuid = GeneratedColumn<String>(
    'record_uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMillisMeta = const VerificationMeta(
    'updatedAtMillis',
  );
  @override
  late final GeneratedColumn<int> updatedAtMillis = GeneratedColumn<int>(
    'updated_at_millis',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteUpdatedAtMillisMeta =
      const VerificationMeta('remoteUpdatedAtMillis');
  @override
  late final GeneratedColumn<int> remoteUpdatedAtMillis = GeneratedColumn<int>(
    'remote_updated_at_millis',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conflictDetectedAtMillisMeta =
      const VerificationMeta('conflictDetectedAtMillis');
  @override
  late final GeneratedColumn<int> conflictDetectedAtMillis =
      GeneratedColumn<int>(
        'conflict_detected_at_millis',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _syncStateMeta = const VerificationMeta(
    'syncState',
  );
  @override
  late final GeneratedColumn<int> syncState = GeneratedColumn<int>(
    'sync_state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cacheKey,
    modelType,
    recordUuid,
    payloadJson,
    updatedAtMillis,
    remoteUpdatedAtMillis,
    conflictDetectedAtMillis,
    syncState,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cache_key')) {
      context.handle(
        _cacheKeyMeta,
        cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('model_type')) {
      context.handle(
        _modelTypeMeta,
        modelType.isAcceptableOrUnknown(data['model_type']!, _modelTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_modelTypeMeta);
    }
    if (data.containsKey('record_uuid')) {
      context.handle(
        _recordUuidMeta,
        recordUuid.isAcceptableOrUnknown(data['record_uuid']!, _recordUuidMeta),
      );
    } else if (isInserting) {
      context.missing(_recordUuidMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('updated_at_millis')) {
      context.handle(
        _updatedAtMillisMeta,
        updatedAtMillis.isAcceptableOrUnknown(
          data['updated_at_millis']!,
          _updatedAtMillisMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMillisMeta);
    }
    if (data.containsKey('remote_updated_at_millis')) {
      context.handle(
        _remoteUpdatedAtMillisMeta,
        remoteUpdatedAtMillis.isAcceptableOrUnknown(
          data['remote_updated_at_millis']!,
          _remoteUpdatedAtMillisMeta,
        ),
      );
    }
    if (data.containsKey('conflict_detected_at_millis')) {
      context.handle(
        _conflictDetectedAtMillisMeta,
        conflictDetectedAtMillis.isAcceptableOrUnknown(
          data['conflict_detected_at_millis']!,
          _conflictDetectedAtMillisMeta,
        ),
      );
    }
    if (data.containsKey('sync_state')) {
      context.handle(
        _syncStateMeta,
        syncState.isAcceptableOrUnknown(data['sync_state']!, _syncStateMeta),
      );
    } else if (isInserting) {
      context.missing(_syncStateMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cacheKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cache_key'],
      )!,
      modelType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_type'],
      )!,
      recordUuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_uuid'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      updatedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_millis'],
      )!,
      remoteUpdatedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_updated_at_millis'],
      ),
      conflictDetectedAtMillis: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}conflict_detected_at_millis'],
      ),
      syncState: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_state'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $SyncRecordsTable createAlias(String alias) {
    return $SyncRecordsTable(attachedDatabase, alias);
  }
}

class SyncRecord extends DataClass implements Insertable<SyncRecord> {
  final int id;
  final String cacheKey;
  final String modelType;
  final String recordUuid;
  final String payloadJson;
  final int updatedAtMillis;
  final int? remoteUpdatedAtMillis;
  final int? conflictDetectedAtMillis;
  final int syncState;
  final bool isDeleted;
  const SyncRecord({
    required this.id,
    required this.cacheKey,
    required this.modelType,
    required this.recordUuid,
    required this.payloadJson,
    required this.updatedAtMillis,
    this.remoteUpdatedAtMillis,
    this.conflictDetectedAtMillis,
    required this.syncState,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cache_key'] = Variable<String>(cacheKey);
    map['model_type'] = Variable<String>(modelType);
    map['record_uuid'] = Variable<String>(recordUuid);
    map['payload_json'] = Variable<String>(payloadJson);
    map['updated_at_millis'] = Variable<int>(updatedAtMillis);
    if (!nullToAbsent || remoteUpdatedAtMillis != null) {
      map['remote_updated_at_millis'] = Variable<int>(remoteUpdatedAtMillis);
    }
    if (!nullToAbsent || conflictDetectedAtMillis != null) {
      map['conflict_detected_at_millis'] = Variable<int>(
        conflictDetectedAtMillis,
      );
    }
    map['sync_state'] = Variable<int>(syncState);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  SyncRecordsCompanion toCompanion(bool nullToAbsent) {
    return SyncRecordsCompanion(
      id: Value(id),
      cacheKey: Value(cacheKey),
      modelType: Value(modelType),
      recordUuid: Value(recordUuid),
      payloadJson: Value(payloadJson),
      updatedAtMillis: Value(updatedAtMillis),
      remoteUpdatedAtMillis: remoteUpdatedAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteUpdatedAtMillis),
      conflictDetectedAtMillis: conflictDetectedAtMillis == null && nullToAbsent
          ? const Value.absent()
          : Value(conflictDetectedAtMillis),
      syncState: Value(syncState),
      isDeleted: Value(isDeleted),
    );
  }

  factory SyncRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncRecord(
      id: serializer.fromJson<int>(json['id']),
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      modelType: serializer.fromJson<String>(json['modelType']),
      recordUuid: serializer.fromJson<String>(json['recordUuid']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      updatedAtMillis: serializer.fromJson<int>(json['updatedAtMillis']),
      remoteUpdatedAtMillis: serializer.fromJson<int?>(
        json['remoteUpdatedAtMillis'],
      ),
      conflictDetectedAtMillis: serializer.fromJson<int?>(
        json['conflictDetectedAtMillis'],
      ),
      syncState: serializer.fromJson<int>(json['syncState']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cacheKey': serializer.toJson<String>(cacheKey),
      'modelType': serializer.toJson<String>(modelType),
      'recordUuid': serializer.toJson<String>(recordUuid),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'updatedAtMillis': serializer.toJson<int>(updatedAtMillis),
      'remoteUpdatedAtMillis': serializer.toJson<int?>(remoteUpdatedAtMillis),
      'conflictDetectedAtMillis': serializer.toJson<int?>(
        conflictDetectedAtMillis,
      ),
      'syncState': serializer.toJson<int>(syncState),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  SyncRecord copyWith({
    int? id,
    String? cacheKey,
    String? modelType,
    String? recordUuid,
    String? payloadJson,
    int? updatedAtMillis,
    Value<int?> remoteUpdatedAtMillis = const Value.absent(),
    Value<int?> conflictDetectedAtMillis = const Value.absent(),
    int? syncState,
    bool? isDeleted,
  }) => SyncRecord(
    id: id ?? this.id,
    cacheKey: cacheKey ?? this.cacheKey,
    modelType: modelType ?? this.modelType,
    recordUuid: recordUuid ?? this.recordUuid,
    payloadJson: payloadJson ?? this.payloadJson,
    updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
    remoteUpdatedAtMillis: remoteUpdatedAtMillis.present
        ? remoteUpdatedAtMillis.value
        : this.remoteUpdatedAtMillis,
    conflictDetectedAtMillis: conflictDetectedAtMillis.present
        ? conflictDetectedAtMillis.value
        : this.conflictDetectedAtMillis,
    syncState: syncState ?? this.syncState,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  SyncRecord copyWithCompanion(SyncRecordsCompanion data) {
    return SyncRecord(
      id: data.id.present ? data.id.value : this.id,
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      modelType: data.modelType.present ? data.modelType.value : this.modelType,
      recordUuid: data.recordUuid.present
          ? data.recordUuid.value
          : this.recordUuid,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      updatedAtMillis: data.updatedAtMillis.present
          ? data.updatedAtMillis.value
          : this.updatedAtMillis,
      remoteUpdatedAtMillis: data.remoteUpdatedAtMillis.present
          ? data.remoteUpdatedAtMillis.value
          : this.remoteUpdatedAtMillis,
      conflictDetectedAtMillis: data.conflictDetectedAtMillis.present
          ? data.conflictDetectedAtMillis.value
          : this.conflictDetectedAtMillis,
      syncState: data.syncState.present ? data.syncState.value : this.syncState,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncRecord(')
          ..write('id: $id, ')
          ..write('cacheKey: $cacheKey, ')
          ..write('modelType: $modelType, ')
          ..write('recordUuid: $recordUuid, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAtMillis: $updatedAtMillis, ')
          ..write('remoteUpdatedAtMillis: $remoteUpdatedAtMillis, ')
          ..write('conflictDetectedAtMillis: $conflictDetectedAtMillis, ')
          ..write('syncState: $syncState, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cacheKey,
    modelType,
    recordUuid,
    payloadJson,
    updatedAtMillis,
    remoteUpdatedAtMillis,
    conflictDetectedAtMillis,
    syncState,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncRecord &&
          other.id == this.id &&
          other.cacheKey == this.cacheKey &&
          other.modelType == this.modelType &&
          other.recordUuid == this.recordUuid &&
          other.payloadJson == this.payloadJson &&
          other.updatedAtMillis == this.updatedAtMillis &&
          other.remoteUpdatedAtMillis == this.remoteUpdatedAtMillis &&
          other.conflictDetectedAtMillis == this.conflictDetectedAtMillis &&
          other.syncState == this.syncState &&
          other.isDeleted == this.isDeleted);
}

class SyncRecordsCompanion extends UpdateCompanion<SyncRecord> {
  final Value<int> id;
  final Value<String> cacheKey;
  final Value<String> modelType;
  final Value<String> recordUuid;
  final Value<String> payloadJson;
  final Value<int> updatedAtMillis;
  final Value<int?> remoteUpdatedAtMillis;
  final Value<int?> conflictDetectedAtMillis;
  final Value<int> syncState;
  final Value<bool> isDeleted;
  const SyncRecordsCompanion({
    this.id = const Value.absent(),
    this.cacheKey = const Value.absent(),
    this.modelType = const Value.absent(),
    this.recordUuid = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.updatedAtMillis = const Value.absent(),
    this.remoteUpdatedAtMillis = const Value.absent(),
    this.conflictDetectedAtMillis = const Value.absent(),
    this.syncState = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  SyncRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String cacheKey,
    required String modelType,
    required String recordUuid,
    required String payloadJson,
    required int updatedAtMillis,
    this.remoteUpdatedAtMillis = const Value.absent(),
    this.conflictDetectedAtMillis = const Value.absent(),
    required int syncState,
    this.isDeleted = const Value.absent(),
  }) : cacheKey = Value(cacheKey),
       modelType = Value(modelType),
       recordUuid = Value(recordUuid),
       payloadJson = Value(payloadJson),
       updatedAtMillis = Value(updatedAtMillis),
       syncState = Value(syncState);
  static Insertable<SyncRecord> custom({
    Expression<int>? id,
    Expression<String>? cacheKey,
    Expression<String>? modelType,
    Expression<String>? recordUuid,
    Expression<String>? payloadJson,
    Expression<int>? updatedAtMillis,
    Expression<int>? remoteUpdatedAtMillis,
    Expression<int>? conflictDetectedAtMillis,
    Expression<int>? syncState,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cacheKey != null) 'cache_key': cacheKey,
      if (modelType != null) 'model_type': modelType,
      if (recordUuid != null) 'record_uuid': recordUuid,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (updatedAtMillis != null) 'updated_at_millis': updatedAtMillis,
      if (remoteUpdatedAtMillis != null)
        'remote_updated_at_millis': remoteUpdatedAtMillis,
      if (conflictDetectedAtMillis != null)
        'conflict_detected_at_millis': conflictDetectedAtMillis,
      if (syncState != null) 'sync_state': syncState,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  SyncRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? cacheKey,
    Value<String>? modelType,
    Value<String>? recordUuid,
    Value<String>? payloadJson,
    Value<int>? updatedAtMillis,
    Value<int?>? remoteUpdatedAtMillis,
    Value<int?>? conflictDetectedAtMillis,
    Value<int>? syncState,
    Value<bool>? isDeleted,
  }) {
    return SyncRecordsCompanion(
      id: id ?? this.id,
      cacheKey: cacheKey ?? this.cacheKey,
      modelType: modelType ?? this.modelType,
      recordUuid: recordUuid ?? this.recordUuid,
      payloadJson: payloadJson ?? this.payloadJson,
      updatedAtMillis: updatedAtMillis ?? this.updatedAtMillis,
      remoteUpdatedAtMillis:
          remoteUpdatedAtMillis ?? this.remoteUpdatedAtMillis,
      conflictDetectedAtMillis:
          conflictDetectedAtMillis ?? this.conflictDetectedAtMillis,
      syncState: syncState ?? this.syncState,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (modelType.present) {
      map['model_type'] = Variable<String>(modelType.value);
    }
    if (recordUuid.present) {
      map['record_uuid'] = Variable<String>(recordUuid.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (updatedAtMillis.present) {
      map['updated_at_millis'] = Variable<int>(updatedAtMillis.value);
    }
    if (remoteUpdatedAtMillis.present) {
      map['remote_updated_at_millis'] = Variable<int>(
        remoteUpdatedAtMillis.value,
      );
    }
    if (conflictDetectedAtMillis.present) {
      map['conflict_detected_at_millis'] = Variable<int>(
        conflictDetectedAtMillis.value,
      );
    }
    if (syncState.present) {
      map['sync_state'] = Variable<int>(syncState.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncRecordsCompanion(')
          ..write('id: $id, ')
          ..write('cacheKey: $cacheKey, ')
          ..write('modelType: $modelType, ')
          ..write('recordUuid: $recordUuid, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('updatedAtMillis: $updatedAtMillis, ')
          ..write('remoteUpdatedAtMillis: $remoteUpdatedAtMillis, ')
          ..write('conflictDetectedAtMillis: $conflictDetectedAtMillis, ')
          ..write('syncState: $syncState, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$_LocalStoreDatabase extends GeneratedDatabase {
  _$_LocalStoreDatabase(QueryExecutor e) : super(e);
  $_LocalStoreDatabaseManager get managers => $_LocalStoreDatabaseManager(this);
  late final $SyncRecordsTable syncRecords = $SyncRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [syncRecords];
}

typedef $$SyncRecordsTableCreateCompanionBuilder =
    SyncRecordsCompanion Function({
      Value<int> id,
      required String cacheKey,
      required String modelType,
      required String recordUuid,
      required String payloadJson,
      required int updatedAtMillis,
      Value<int?> remoteUpdatedAtMillis,
      Value<int?> conflictDetectedAtMillis,
      required int syncState,
      Value<bool> isDeleted,
    });
typedef $$SyncRecordsTableUpdateCompanionBuilder =
    SyncRecordsCompanion Function({
      Value<int> id,
      Value<String> cacheKey,
      Value<String> modelType,
      Value<String> recordUuid,
      Value<String> payloadJson,
      Value<int> updatedAtMillis,
      Value<int?> remoteUpdatedAtMillis,
      Value<int?> conflictDetectedAtMillis,
      Value<int> syncState,
      Value<bool> isDeleted,
    });

class $$SyncRecordsTableFilterComposer
    extends Composer<_$_LocalStoreDatabase, $SyncRecordsTable> {
  $$SyncRecordsTableFilterComposer({
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

  ColumnFilters<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelType => $composableBuilder(
    column: $table.modelType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordUuid => $composableBuilder(
    column: $table.recordUuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remoteUpdatedAtMillis => $composableBuilder(
    column: $table.remoteUpdatedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get conflictDetectedAtMillis => $composableBuilder(
    column: $table.conflictDetectedAtMillis,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncRecordsTableOrderingComposer
    extends Composer<_$_LocalStoreDatabase, $SyncRecordsTable> {
  $$SyncRecordsTableOrderingComposer({
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

  ColumnOrderings<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelType => $composableBuilder(
    column: $table.modelType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordUuid => $composableBuilder(
    column: $table.recordUuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remoteUpdatedAtMillis => $composableBuilder(
    column: $table.remoteUpdatedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get conflictDetectedAtMillis => $composableBuilder(
    column: $table.conflictDetectedAtMillis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncState => $composableBuilder(
    column: $table.syncState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncRecordsTableAnnotationComposer
    extends Composer<_$_LocalStoreDatabase, $SyncRecordsTable> {
  $$SyncRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get modelType =>
      $composableBuilder(column: $table.modelType, builder: (column) => column);

  GeneratedColumn<String> get recordUuid => $composableBuilder(
    column: $table.recordUuid,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtMillis => $composableBuilder(
    column: $table.updatedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remoteUpdatedAtMillis => $composableBuilder(
    column: $table.remoteUpdatedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get conflictDetectedAtMillis => $composableBuilder(
    column: $table.conflictDetectedAtMillis,
    builder: (column) => column,
  );

  GeneratedColumn<int> get syncState =>
      $composableBuilder(column: $table.syncState, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$SyncRecordsTableTableManager
    extends
        RootTableManager<
          _$_LocalStoreDatabase,
          $SyncRecordsTable,
          SyncRecord,
          $$SyncRecordsTableFilterComposer,
          $$SyncRecordsTableOrderingComposer,
          $$SyncRecordsTableAnnotationComposer,
          $$SyncRecordsTableCreateCompanionBuilder,
          $$SyncRecordsTableUpdateCompanionBuilder,
          (
            SyncRecord,
            BaseReferences<
              _$_LocalStoreDatabase,
              $SyncRecordsTable,
              SyncRecord
            >,
          ),
          SyncRecord,
          PrefetchHooks Function()
        > {
  $$SyncRecordsTableTableManager(
    _$_LocalStoreDatabase db,
    $SyncRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> cacheKey = const Value.absent(),
                Value<String> modelType = const Value.absent(),
                Value<String> recordUuid = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int> updatedAtMillis = const Value.absent(),
                Value<int?> remoteUpdatedAtMillis = const Value.absent(),
                Value<int?> conflictDetectedAtMillis = const Value.absent(),
                Value<int> syncState = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => SyncRecordsCompanion(
                id: id,
                cacheKey: cacheKey,
                modelType: modelType,
                recordUuid: recordUuid,
                payloadJson: payloadJson,
                updatedAtMillis: updatedAtMillis,
                remoteUpdatedAtMillis: remoteUpdatedAtMillis,
                conflictDetectedAtMillis: conflictDetectedAtMillis,
                syncState: syncState,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String cacheKey,
                required String modelType,
                required String recordUuid,
                required String payloadJson,
                required int updatedAtMillis,
                Value<int?> remoteUpdatedAtMillis = const Value.absent(),
                Value<int?> conflictDetectedAtMillis = const Value.absent(),
                required int syncState,
                Value<bool> isDeleted = const Value.absent(),
              }) => SyncRecordsCompanion.insert(
                id: id,
                cacheKey: cacheKey,
                modelType: modelType,
                recordUuid: recordUuid,
                payloadJson: payloadJson,
                updatedAtMillis: updatedAtMillis,
                remoteUpdatedAtMillis: remoteUpdatedAtMillis,
                conflictDetectedAtMillis: conflictDetectedAtMillis,
                syncState: syncState,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$_LocalStoreDatabase,
      $SyncRecordsTable,
      SyncRecord,
      $$SyncRecordsTableFilterComposer,
      $$SyncRecordsTableOrderingComposer,
      $$SyncRecordsTableAnnotationComposer,
      $$SyncRecordsTableCreateCompanionBuilder,
      $$SyncRecordsTableUpdateCompanionBuilder,
      (
        SyncRecord,
        BaseReferences<_$_LocalStoreDatabase, $SyncRecordsTable, SyncRecord>,
      ),
      SyncRecord,
      PrefetchHooks Function()
    >;

class $_LocalStoreDatabaseManager {
  final _$_LocalStoreDatabase _db;
  $_LocalStoreDatabaseManager(this._db);
  $$SyncRecordsTableTableManager get syncRecords =>
      $$SyncRecordsTableTableManager(_db, _db.syncRecords);
}
