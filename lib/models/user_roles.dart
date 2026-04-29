// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class UserRoles {
  @Id()
  int id = 0;
  String uuid;
  String userUuid;
  String roleUuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  UserRoles({this.id = 0, String? uuid, required this.userUuid, required this.roleUuid, required this.status, required this.createdAt, required this.updatedAt})
    : uuid = uuid ?? UUIDGenerator.generate();

  UserRoles copyWith({int? id, String? uuid, String? userUuid, String? roleUuid, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return UserRoles(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      userUuid: userUuid ?? this.userUuid,
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
      'userUuid': userUuid,
      'roleUuid': roleUuid,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserRoles.fromMap(Map<String, dynamic> map) {
    return UserRoles(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      userUuid: ModelParsing.stringOrThrow(map['userUuid'], 'userUuid'),
      roleUuid: ModelParsing.stringOrThrow(map['roleUuid'], 'roleUuid'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRoles.fromJson(String source) => UserRoles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserRoles(id: $id, uuid: $uuid, userUuid: $userUuid, roleUuid: $roleUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant UserRoles other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.userUuid == userUuid &&
        other.roleUuid == roleUuid &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ userUuid.hashCode ^ roleUuid.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
