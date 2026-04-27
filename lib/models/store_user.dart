// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class StoreUser {
  int? id;
  String uuid;
  int storeId;
  String storeUuid;
  int userId;
  String userUuid;
  int userRoleId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  StoreUser({
    this.id,
    String? uuid,
    required this.storeId,
    required this.storeUuid,
    required this.userId,
    required this.userUuid,
    required this.userRoleId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StoreUser copyWith({int? id, String? uuid, int? storeId, String? storeUuid, int? userId, String? userUuid, int? userRoleId, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return StoreUser(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeId: storeId ?? this.storeId,
      storeUuid: storeUuid ?? this.storeUuid,
      userId: userId ?? this.userId,
      userUuid: userUuid ?? this.userUuid,
      userRoleId: userRoleId ?? this.userRoleId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'storeId': storeId,
      'storeUuid': storeUuid,
      'userId': userId,
      'userUuid': userUuid,
      'userRoleId': userRoleId,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory StoreUser.fromMap(Map<String, dynamic> map) {
    return StoreUser(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      storeId: ModelParsing.intOrThrow(map['storeId'], 'storeId'),
      storeUuid: map['storeUuid'] as String,
      userId: ModelParsing.intOrThrow(map['userId'], 'userId'),
      userUuid: map['userUuid'] as String,
      userRoleId: ModelParsing.intOrThrow(map['userRoleId'], 'userRoleId'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreUser.fromJson(String source) => StoreUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreUser(id: $id, uuid: $uuid, storeId: $storeId, storeUuid: $storeUuid, userId: $userId, userUuid: $userUuid, userRoleId: $userRoleId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StoreUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeId == storeId &&
        other.storeUuid == storeUuid &&
        other.userId == userId &&
        other.userUuid == userUuid &&
        other.userRoleId == userRoleId &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ storeId.hashCode ^ storeUuid.hashCode ^ userId.hashCode ^ userUuid.hashCode ^ userRoleId.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
