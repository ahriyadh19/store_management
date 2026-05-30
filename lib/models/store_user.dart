// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class StoreUser extends AuditedSyncModel {
  static const Object _unset = Object();

  String storeUuid;
  String? branchUuid;
  String userUuid;
  String userRoleUuid;
  StoreUser({
    super.id = 0,
    super.uuid,
    required this.storeUuid,
    this.branchUuid,
    required this.userUuid,
    required this.userRoleUuid,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  StoreUser copyWith({
    int? id,
    String? uuid,
    String? storeUuid,
    Object? branchUuid = _unset,
    String? userUuid,
    String? userRoleUuid,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return StoreUser(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeUuid: storeUuid ?? this.storeUuid,
      branchUuid: identical(branchUuid, _unset)
          ? this.branchUuid
          : branchUuid as String?,
      userUuid: userUuid ?? this.userUuid,
      userRoleUuid: userRoleUuid ?? this.userRoleUuid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'storeUuid': storeUuid,
      'branchUuid': branchUuid,
      'userUuid': userUuid,
      'userRoleUuid': userRoleUuid,
      ...auditedSyncMap(),
    };
  }

  factory StoreUser.fromMap(Map<String, dynamic> map) {
    return StoreUser(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      storeUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'storeUuid'),
        'storeUuid',
      ),
      branchUuid: ModelParsing.stringOrNull(
        ModelParsing.value(map, 'branchUuid'),
      ),
      userUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'userUuid'),
        'userUuid',
      ),
      userRoleUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'userRoleUuid'),
        'userRoleUuid',
      ),
      status: ModelParsing.intOrThrow(
        ModelParsing.value(map, 'status'),
        'status',
      ),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'createdAt'),
        'createdAt',
      ),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'updatedAt'),
        'updatedAt',
      ),
      synced:
          ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'deletedAt'),
      ),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'syncedAt'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreUser.fromJson(String source) =>
      StoreUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreUser(id: $id, uuid: $uuid, storeUuid: $storeUuid, branchUuid: $branchUuid, userUuid: $userUuid, userRoleUuid: $userRoleUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    storeUuid,
    branchUuid,
    userUuid,
    userRoleUuid,
  ];
}
