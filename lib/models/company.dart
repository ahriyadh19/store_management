// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/services/uuid.dart';

class Company {
  int? id;
  String uuid;
  String name;
  String description;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  
  Company({
    this.id,
    String? uuid,
    required this.name,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  Company copyWith({
    int? id,
    String? uuid,
    String? name,
    String? description,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Company(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
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
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      status: map['status'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Company.fromJson(String source) => Company.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Company(id: $id, uuid: $uuid, name: $name, description: $description, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Company other) {
    if (identical(this, other)) return true;

    return other.id == id && other.uuid == uuid && other.name == name && other.description == description && other.status == status && other.createdAt == createdAt && other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ name.hashCode ^ description.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
