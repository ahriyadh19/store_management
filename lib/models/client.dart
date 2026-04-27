// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class Client {
  int? id;
  String uuid;
  String name;
  String description;
  String email;
  String phone;
  String address;
  int status;
  double creditLimit;
  double currentCredit;
  double availableCredit;
  DateTime createdAt;
  DateTime updatedAt;
  Client({
    this.id,
    String? uuid,
    required this.name,
    required this.description,
    required this.email,
    required this.phone,
    required this.address,
    required this.status,
    required this.creditLimit,
    required this.currentCredit,
    required this.availableCredit,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  Client copyWith({
    int? id,
    String? uuid,
    String? name,
    String? description,
    String? email,
    String? phone,
    String? address,
    int? status,
    double? creditLimit,
    double? currentCredit,
    double? availableCredit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Client(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      status: status ?? this.status,
      creditLimit: creditLimit ?? this.creditLimit,
      currentCredit: currentCredit ?? this.currentCredit,
      availableCredit: availableCredit ?? this.availableCredit,
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
      'email': email,
      'phone': phone,
      'address': address,
      'status': status,
      'creditLimit': creditLimit,
      'currentCredit': currentCredit,
      'availableCredit': availableCredit,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      address: map['address'] as String,
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      creditLimit: ModelParsing.doubleOrThrow(map['creditLimit'], 'creditLimit'),
      currentCredit: ModelParsing.doubleOrThrow(map['currentCredit'], 'currentCredit'),
      availableCredit: ModelParsing.doubleOrThrow(map['availableCredit'], 'availableCredit'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory Client.fromJson(String source) => Client.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Client(id: $id, uuid: $uuid, name: $name, description: $description, email: $email, phone: $phone, address: $address, status: $status, creditLimit: $creditLimit, currentCredit: $currentCredit, availableCredit: $availableCredit, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Client other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.name == name &&
        other.description == description &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.status == status &&
        other.creditLimit == creditLimit &&
        other.currentCredit == currentCredit &&
        other.availableCredit == availableCredit &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        name.hashCode ^
        description.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        status.hashCode ^
        creditLimit.hashCode ^
        currentCredit.hashCode ^
        availableCredit.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
