// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class Roles {
  @Id()
  int id = 0;
  String uuid;
  String name;
  String description;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Roles({this.id = 0, String? uuid, required this.name, required this.description, required this.status, required this.createdAt, required this.updatedAt}) : uuid = uuid ?? UUIDGenerator.generate();

  Roles copyWith({int? id, String? uuid, String? name, String? description, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return Roles(
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
    return <String, dynamic>{'id': id, 'uuid': uuid, 'name': name, 'description': description, 'status': status, 'createdAt': createdAt.millisecondsSinceEpoch, 'updatedAt': updatedAt.millisecondsSinceEpoch};
  }

  factory Roles.fromMap(Map<String, dynamic> map) {
    return Roles(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      name: ModelParsing.stringOrThrow(map['name'], 'name'),
      description: ModelParsing.stringOrThrow(map['description'], 'description'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory Roles.fromJson(String source) => Roles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Roles(id: $id, uuid: $uuid, name: $name, description: $description, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Roles other) {
    if (identical(this, other)) return true;

    return other.id == id && other.uuid == uuid && other.name == name && other.description == description && other.status == status && other.createdAt == createdAt && other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ name.hashCode ^ description.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
