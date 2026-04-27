// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/services/uuid.dart';

class Store {
  int? id;
  String uuid;
  String name;
  String description;
  String address;
  String phone;
  String email;
  Store({this.id, String? uuid, required this.name, required this.description, required this.address, required this.phone, required this.email}) : uuid = uuid ?? UUIDGenerator.generate();

  Store copyWith({int? id, String? uuid, String? name, String? description, String? address, String? phone, String? email}) {
    return Store(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'uuid': uuid, 'name': name, 'description': description, 'address': address, 'phone': phone, 'email': email};
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      address: map['address'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Store.fromJson(String source) => Store.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Store(id: $id, uuid: $uuid, name: $name, description: $description, address: $address, phone: $phone, email: $email)';
  }

  @override
  bool operator ==(covariant Store other) {
    if (identical(this, other)) return true;

    return other.id == id && other.uuid == uuid && other.name == name && other.description == description && other.address == address && other.phone == phone && other.email == email;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ name.hashCode ^ description.hashCode ^ address.hashCode ^ phone.hashCode ^ email.hashCode;
  }
}
