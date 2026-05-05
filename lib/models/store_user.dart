// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class StoreUser {
  static const Object _unset = Object();

  @Id()
  int id = 0;
  String uuid;
  String storeUuid;
  String? branchUuid;
  String userUuid;
  String userRoleUuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;
  StoreUser({
    this.id = 0,
    String? uuid,
    required this.storeUuid,
    this.branchUuid,
    required this.userUuid,
    required this.userRoleUuid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

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
      branchUuid: identical(branchUuid, _unset) ? this.branchUuid : branchUuid as String?,
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
      'id': id,
      'uuid': uuid,
      'storeUuid': storeUuid,
      'branchUuid': branchUuid,
      'userUuid': userUuid,
      'userRoleUuid': userRoleUuid,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory StoreUser.fromMap(Map<String, dynamic> map) {
    return StoreUser(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      storeUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'storeUuid'), 'storeUuid'),
      branchUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'branchUuid')),
      userUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'userUuid'), 'userUuid'),
      userRoleUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'userRoleUuid'), 'userRoleUuid'),
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt'), 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt'), 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreUser.fromJson(String source) => StoreUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreUser(id: $id, uuid: $uuid, storeUuid: $storeUuid, branchUuid: $branchUuid, userUuid: $userUuid, userRoleUuid: $userRoleUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant StoreUser other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeUuid == storeUuid &&
        other.branchUuid == branchUuid &&
        other.userUuid == userUuid &&
        other.userRoleUuid == userRoleUuid &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.synced == synced &&
        other.deletedAt == deletedAt &&
        other.syncedAt == syncedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        storeUuid.hashCode ^
        branchUuid.hashCode ^
        userUuid.hashCode ^
        userRoleUuid.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}

