// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class Client extends AuditedSyncModel {
  String name;
  String description;
  String email;
  String phone;
  String address;
  Decimal creditLimit;
  Decimal currentCredit;
  Decimal availableCredit;

  Client({
    super.id = 0,
    super.uuid,
    required this.name,
    required this.description,
    required this.email,
    required this.phone,
    required this.address,
    required super.status,
    required this.creditLimit,
    required this.currentCredit,
    required this.availableCredit,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

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
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
      'address': address,
      'creditLimit': creditLimit.toString(),
      'currentCredit': currentCredit.toString(),
      'availableCredit': availableCredit.toString(),
      ...auditedSyncMap(),
    };
  }

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      name: ModelParsing.stringOrThrow(ModelParsing.value(map, 'name'), 'name'),
      description: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'description'),
        'description',
      ),
      email: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'email'),
        'email',
      ),
      phone: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'phone'),
        'phone',
      ),
      address: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'address'),
        'address',
      ),
      status: ModelParsing.intOrThrow(
        ModelParsing.value(map, 'status'),
        'status',
      ),
      creditLimit: ModelParsing.decimalOrThrow(
        ModelParsing.value(map, 'creditLimit'),
        'creditLimit',
      ),
      currentCredit: ModelParsing.decimalOrThrow(
        ModelParsing.value(map, 'currentCredit'),
        'currentCredit',
      ),
      availableCredit: ModelParsing.decimalOrThrow(
        ModelParsing.value(map, 'availableCredit'),
        'availableCredit',
      ),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'createdAt'),
        'createdAt',
      ),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'updatedAt'),
        'updatedAt',
      ),
      synced:
          ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'deletedAt'),
      ),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'syncedAt'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Client.fromJson(String source) =>
      Client.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Client(id: $id, uuid: $uuid, name: $name, description: $description, email: $email, phone: $phone, address: $address, status: $status, creditLimit: $creditLimit, currentCredit: $currentCredit, availableCredit: $availableCredit, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    name,
    description,
    email,
    phone,
    address,
    creditLimit,
    currentCredit,
    availableCredit,
  ];
}
