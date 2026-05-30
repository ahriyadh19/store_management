// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class UserRoles extends AuditedSyncModel {
  String userUuid;
  String roleUuid;

  UserRoles({
    super.id = 0,
    super.uuid,
    required this.userUuid,
    required this.roleUuid,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  UserRoles copyWith({
    int? id,
    String? uuid,
    String? userUuid,
    String? roleUuid,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return UserRoles(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      userUuid: userUuid ?? this.userUuid,
      roleUuid: roleUuid ?? this.roleUuid,
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
      'userUuid': userUuid,
      'roleUuid': roleUuid,
      ...auditedSyncMap(),
    };
  }

  factory UserRoles.fromMap(Map<String, dynamic> map) {
    return UserRoles(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      userUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'userUuid'),
        'userUuid',
      ),
      roleUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'roleUuid'),
        'roleUuid',
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

  factory UserRoles.fromJson(String source) =>
      UserRoles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserRoles(id: $id, uuid: $uuid, userUuid: $userUuid, roleUuid: $roleUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[...auditedSyncProps, userUuid, roleUuid];
}
