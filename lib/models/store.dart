// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class Store {
  @Id()
  int id = 0;
  String uuid;
  String name;
  String description;
  String address;
  String phone;
  String email;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;
  Store({this.id = 0, String? uuid, required this.name, required this.description, required this.address, required this.phone, required this.email, this.synced = false, this.deletedAt, this.syncedAt})
    : uuid = uuid ?? UUIDGenerator.generate();

  Store copyWith({int? id, String? uuid, String? name, String? description, String? address, String? phone, String? email, bool? synced, DateTime? deletedAt, DateTime? syncedAt}) {
    return Store(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
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
      'address': address,
      'phone': phone,
      'email': email,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      name: ModelParsing.stringOrThrow(map['name'], 'name'),
      description: ModelParsing.stringOrThrow(map['description'], 'description'),
      address: ModelParsing.stringOrThrow(map['address'], 'address'),
      phone: ModelParsing.stringOrThrow(map['phone'], 'phone'),
      email: ModelParsing.stringOrThrow(map['email'], 'email'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) => Store.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Store(id: $id, uuid: $uuid, name: $name, description: $description, address: $address, phone: $phone, email: $email, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant Store other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.name == name &&
        other.description == description &&
        other.address == address &&
        other.phone == phone &&
        other.email == email &&
        other.synced == synced &&
        other.deletedAt == deletedAt &&
        other.syncedAt == syncedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ name.hashCode ^ description.hashCode ^ address.hashCode ^ phone.hashCode ^ email.hashCode ^ synced.hashCode ^ deletedAt.hashCode ^ syncedAt.hashCode;
  }
}
