// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/services/uuid.dart';

class UserRoles {
  int? id;
  String uuid;
  String userId;
  String roleId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  UserRoles({this.id, String? uuid, required this.userId, required this.roleId, required this.status, required this.createdAt, required this.updatedAt}) : uuid = uuid ?? UUIDGenerator.generate();

  UserRoles copyWith({int? id, String? uuid, String? userId, String? roleId, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return UserRoles(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'uuid': uuid, 'userId': userId, 'roleId': roleId, 'status': status, 'createdAt': createdAt.millisecondsSinceEpoch, 'updatedAt': updatedAt.millisecondsSinceEpoch};
  }

  factory UserRoles.fromMap(Map<String, dynamic> map) {
    return UserRoles(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] as String,
      userId: map['userId'] as String,
      roleId: map['roleId'] as String,
      status: map['status'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserRoles.fromJson(String source) => UserRoles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserRoles(id: $id, uuid: $uuid, userId: $userId, roleId: $roleId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant UserRoles other) {
    if (identical(this, other)) return true;

    return other.id == id && other.uuid == uuid && other.userId == userId && other.roleId == roleId && other.status == status && other.createdAt == createdAt && other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ userId.hashCode ^ roleId.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
