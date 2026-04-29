// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class Branch {
  @Id()
  int id = 0;
  String uuid;
  String name;
  String description;
  String address;
  String phone;
  String email;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  Branch({
    this.id = 0,
    String? uuid,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  Branch copyWith({int? id, String? uuid, String? name, String? description, String? address, String? phone, String? email, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return Branch(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
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
      'address': address,
      'phone': phone,
      'email': email,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      name: ModelParsing.stringOrThrow(map['name'], 'name'),
      description: ModelParsing.stringOrThrow(map['description'], 'description'),
      address: ModelParsing.stringOrThrow(map['address'], 'address'),
      phone: ModelParsing.stringOrThrow(map['phone'], 'phone'),
      email: ModelParsing.stringOrThrow(map['email'], 'email'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory Branch.fromJson(String source) => Branch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Branch(id: $id, uuid: $uuid, name: $name, description: $description, address: $address, phone: $phone, email: $email, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Branch other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.name == name &&
        other.description == description &&
        other.address == address &&
        other.phone == phone &&
        other.email == email &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ name.hashCode ^ description.hashCode ^ address.hashCode ^ phone.hashCode ^ email.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
