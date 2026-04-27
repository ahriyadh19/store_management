// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class UserRoles {
  int? id;
  String uuid;
  int userId;
  String userUuid;
  int roleId;
  String roleUuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  UserRoles({this.id, String? uuid, required this.userId, required this.userUuid, required this.roleId, required this.roleUuid, required this.status, required this.createdAt, required this.updatedAt})
    : uuid = uuid ?? UUIDGenerator.generate();

  UserRoles copyWith({int? id, String? uuid, int? userId, String? userUuid, int? roleId, String? roleUuid, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return UserRoles(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      userId: userId ?? this.userId,
      userUuid: userUuid ?? this.userUuid,
      roleId: roleId ?? this.roleId,
      roleUuid: roleUuid ?? this.roleUuid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'userId': userId,
      'userUuid': userUuid,
      'roleId': roleId,
      'roleUuid': roleUuid,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserRoles.fromMap(Map<String, dynamic> map) {
    return UserRoles(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      userId: ModelParsing.intOrThrow(map['userId'], 'userId'),
      userUuid: map['userUuid'] as String,
      roleId: ModelParsing.intOrThrow(map['roleId'], 'roleId'),
      roleUuid: map['roleUuid'] as String,
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRoles.fromJson(String source) => UserRoles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserRoles(id: $id, uuid: $uuid, userId: $userId, userUuid: $userUuid, roleId: $roleId, roleUuid: $roleUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant UserRoles other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.userId == userId &&
        other.userUuid == userUuid &&
        other.roleId == roleId &&
        other.roleUuid == roleUuid &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ userId.hashCode ^ userUuid.hashCode ^ roleId.hashCode ^ roleUuid.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
