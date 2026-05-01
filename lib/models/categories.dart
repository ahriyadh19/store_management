// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class Categories {
  static const Object _unset = Object();

  @Id()
  int id = 0;
  String uuid;
  String name;
  String description;
  int status;
  String? parentUuid;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  Categories({
    this.id = 0,
    String? uuid,
    required this.name,
    required this.description,
    required this.status,
    this.parentUuid,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  Categories copyWith({
    int? id,
    String? uuid,
    String? name,
    String? description,
    int? status,
    Object? parentUuid = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return Categories(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      parentUuid: identical(parentUuid, _unset) ? this.parentUuid : parentUuid as String?,
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
      'name': name,
      'description': description,
      'status': status,
      'parentUuid': parentUuid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      name: ModelParsing.stringOrThrow(map['name'], 'name'),
      description: ModelParsing.stringOrThrow(map['description'], 'description'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      parentUuid: ModelParsing.stringOrNull(map['parentUuid']),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Categories.fromJson(String source) => Categories.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Categories(id: $id, uuid: $uuid, name: $name, description: $description, status: $status, parentUuid: $parentUuid, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant Categories other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.name == name &&
        other.description == description &&
        other.status == status &&
        other.parentUuid == parentUuid &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.synced == synced &&
        other.deletedAt == deletedAt &&
        other.syncedAt == syncedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ name.hashCode ^ description.hashCode ^ status.hashCode ^ parentUuid.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ synced.hashCode ^ deletedAt.hashCode ^ syncedAt.hashCode;
  }
}
