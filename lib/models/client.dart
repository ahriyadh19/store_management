// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class Client {
  @Id()
  int id = 0;
  String uuid;
  String name;
  String description;
  String email;
  String phone;
  String address;
  int status;
  Decimal creditLimit;
  Decimal currentCredit;
  Decimal availableCredit;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;
  Client({
    this.id = 0,
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
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
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
    Decimal? creditLimit,
    Decimal? currentCredit,
    Decimal? availableCredit,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
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
      'email': email,
      'phone': phone,
      'address': address,
      'status': status,
      'creditLimit': creditLimit.toString(),
      'currentCredit': currentCredit.toString(),
      'availableCredit': availableCredit.toString(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      name: ModelParsing.stringOrThrow(ModelParsing.value(map, 'name'), 'name'),
      description: ModelParsing.stringOrThrow(ModelParsing.value(map, 'description'), 'description'),
      email: ModelParsing.stringOrThrow(ModelParsing.value(map, 'email'), 'email'),
      phone: ModelParsing.stringOrThrow(ModelParsing.value(map, 'phone'), 'phone'),
      address: ModelParsing.stringOrThrow(ModelParsing.value(map, 'address'), 'address'),
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      creditLimit: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'creditLimit'), 'creditLimit'),
      currentCredit: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'currentCredit'), 'currentCredit'),
      availableCredit: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'availableCredit'), 'availableCredit'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt'), 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt'), 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory Client.fromJson(String source) => Client.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Client(id: $id, uuid: $uuid, name: $name, description: $description, email: $email, phone: $phone, address: $address, status: $status, creditLimit: $creditLimit, currentCredit: $currentCredit, availableCredit: $availableCredit, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
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
        other.updatedAt == updatedAt &&
        other.synced == synced &&
        other.deletedAt == deletedAt &&
        other.syncedAt == syncedAt;
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
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}

