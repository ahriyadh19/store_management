// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class UserPermission extends AuditedSyncModel {
  String ownerUuid;
  String userUuid;
  String permissionUuid;
  bool isAllowed;

  UserPermission({
    super.id = 0,
    super.uuid,
    this.ownerUuid = '',
    required this.userUuid,
    required this.permissionUuid,
    this.isAllowed = true,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  UserPermission copyWith({
    int? id,
    String? uuid,
    String? ownerUuid,
    String? userUuid,
    String? permissionUuid,
    bool? isAllowed,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return UserPermission(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      ownerUuid: ownerUuid ?? this.ownerUuid,
      userUuid: userUuid ?? this.userUuid,
      permissionUuid: permissionUuid ?? this.permissionUuid,
      isAllowed: isAllowed ?? this.isAllowed,
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
      'ownerUuid': ownerUuid,
      'userUuid': userUuid,
      'permissionUuid': permissionUuid,
      'isAllowed': isAllowed,
      ...auditedSyncMap(),
    };
  }

  factory UserPermission.fromMap(Map<String, dynamic> map) {
    return UserPermission(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'ownerUuid')) ?? '',
      userUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'userUuid'),
        'userUuid',
      ),
      permissionUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'permissionUuid'),
        'permissionUuid',
      ),
      isAllowed:
          ModelParsing.boolOrNull(ModelParsing.value(map, 'isAllowed')) ?? true,
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

  factory UserPermission.fromJson(String source) =>
      UserPermission.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserPermission(id: $id, uuid: $uuid, ownerUuid: $ownerUuid, userUuid: $userUuid, permissionUuid: $permissionUuid, isAllowed: $isAllowed, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    ownerUuid,
    userUuid,
    permissionUuid,
    isAllowed,
  ];
}
