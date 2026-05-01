// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class Tags {
  @Id()
  int id = 0;
  String uuid;
  String name;
  String description;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  Tags({this.id = 0, String? uuid, required this.name, required this.description, required this.status, required this.createdAt, required this.updatedAt, this.synced = false, this.deletedAt, this.syncedAt})
    : uuid = uuid ?? UUIDGenerator.generate();

  Tags copyWith({int? id, String? uuid, String? name, String? description, int? status, DateTime? createdAt, DateTime? updatedAt, bool? synced, DateTime? deletedAt, DateTime? syncedAt}) {
    return Tags(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
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
      'name': name,
      'description': description,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory Tags.fromMap(Map<String, dynamic> map) {
    return Tags(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      name: ModelParsing.stringOrThrow(map['name'], 'name'),
      description: ModelParsing.stringOrThrow(map['description'], 'description'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tags.fromJson(String source) => Tags.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Tags(id: $id, uuid: $uuid, name: $name, description: $description, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant Tags other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.name == name &&
        other.description == description &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.synced == synced &&
        other.deletedAt == deletedAt &&
        other.syncedAt == syncedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ name.hashCode ^ description.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ synced.hashCode ^ deletedAt.hashCode ^ syncedAt.hashCode;
  }
}
