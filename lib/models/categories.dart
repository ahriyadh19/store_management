// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/services/uuid.dart';

class Categories {
  int? id;
  String uuid;
  String name;
  String description;
  int status;
  int parentId;
  DateTime createdAt;
  DateTime updatedAt;

  
  Categories({this.id, String? uuid, required this.name, required this.description, required this.status, required this.parentId, required this.createdAt, required this.updatedAt})
    : uuid = uuid ?? UUIDGenerator.generate();

  Categories copyWith({int? id, String? uuid, String? name, String? description, int? status, int? parentId, DateTime? createdAt, DateTime? updatedAt}) {
    return Categories(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      parentId: parentId ?? this.parentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'name': name,
      'description': description,
      'status': status,
      'parentId': parentId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      status: map['status'] as int,
      parentId: map['parentId'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Categories.fromJson(String source) => Categories.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Categories(id: $id, uuid: $uuid, name: $name, description: $description, status: $status, parentId: $parentId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Categories other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.name == name &&
        other.description == description &&
        other.status == status &&
        other.parentId == parentId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ name.hashCode ^ description.hashCode ^ status.hashCode ^ parentId.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
