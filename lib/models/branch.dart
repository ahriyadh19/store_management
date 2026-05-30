// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class Branch extends AuditedSyncModel {
  String ownerUuid;
  String? storeUuid;
  String name;
  String description;
  String address;
  String phone;
  String email;

  Branch({
    super.id = 0,
    super.uuid,
    this.ownerUuid = '',
    this.storeUuid,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Branch copyWith({
    int? id,
    String? uuid,
    String? ownerUuid,
    String? storeUuid,
    String? name,
    String? description,
    String? address,
    String? phone,
    String? email,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return Branch(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      ownerUuid: ownerUuid ?? this.ownerUuid,
      storeUuid: storeUuid ?? this.storeUuid,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
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
      'ownerUuid': ownerUuid,
      'storeUuid': storeUuid,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      ...auditedSyncMap(),
    };
  }

  factory Branch.fromMap(Map<String, dynamic> map) {
    return Branch(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'ownerUuid')) ?? '',
      storeUuid: ModelParsing.stringOrNull(
        ModelParsing.value(map, 'storeUuid'),
      ),
      name: ModelParsing.stringOrThrow(ModelParsing.value(map, 'name'), 'name'),
      description: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'description'),
        'description',
      ),
      address: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'address'),
        'address',
      ),
      phone: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'phone'),
        'phone',
      ),
      email: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'email'),
        'email',
      ),
      status: ModelParsing.intOrThrow(
        ModelParsing.value(map, 'status'),
        'status',
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

  factory Branch.fromJson(String source) =>
      Branch.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Branch(id: $id, uuid: $uuid, ownerUuid: $ownerUuid, storeUuid: $storeUuid, name: $name, description: $description, address: $address, phone: $phone, email: $email, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    ownerUuid,
    storeUuid,
    name,
    description,
    address,
    phone,
    email,
  ];
}
