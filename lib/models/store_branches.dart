// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class StoreBranches {
  @Id()
  int id = 0;
  String uuid;
  String storeUuid;
  String branchUuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  StoreBranches({this.id = 0, String? uuid, required this.storeUuid, required this.branchUuid, required this.status, required this.createdAt, required this.updatedAt, this.synced = false, this.deletedAt, this.syncedAt})
    : uuid = uuid ?? UUIDGenerator.generate();

  StoreBranches copyWith({int? id, String? uuid, String? storeUuid, String? branchUuid, int? status, DateTime? createdAt, DateTime? updatedAt, bool? synced, DateTime? deletedAt, DateTime? syncedAt}) {
    return StoreBranches(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeUuid: storeUuid ?? this.storeUuid,
      branchUuid: branchUuid ?? this.branchUuid,
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
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory StoreBranches.fromMap(Map<String, dynamic> map) {
    return StoreBranches(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      storeUuid: ModelParsing.stringOrThrow(map['storeUuid'], 'storeUuid'),
      branchUuid: ModelParsing.stringOrThrow(map['branchUuid'], 'branchUuid'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreBranches.fromJson(String source) => StoreBranches.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreBranches(id: $id, uuid: $uuid, storeUuid: $storeUuid, branchUuid: $branchUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant StoreBranches other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeUuid == storeUuid &&
        other.branchUuid == branchUuid &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.synced == synced &&
        other.deletedAt == deletedAt &&
        other.syncedAt == syncedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ storeUuid.hashCode ^ branchUuid.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}
