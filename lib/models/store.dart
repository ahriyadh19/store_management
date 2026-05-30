// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class Store extends SyncModel {
  String ownerUserUuid;
  String name;
  String description;
  String address;
  String phone;
  String email;
  Store({
    super.id = 0,
    super.uuid,
    this.ownerUserUuid = '',
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Store copyWith({
    int? id,
    String? uuid,
    String? ownerUserUuid,
    String? name,
    String? description,
    String? address,
    String? phone,
    String? email,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return Store(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      ownerUserUuid: ownerUserUuid ?? this.ownerUserUuid,
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
      'ownerUserUuid': ownerUserUuid,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      ...syncMap(),
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUserUuid:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'ownerUserUuid')) ??
          '',
      name: ModelParsing.stringOrNull(ModelParsing.value(map, 'name')) ?? '',
      description:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'description')) ??
          '',
      address:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'address')) ?? '',
      phone: ModelParsing.stringOrNull(ModelParsing.value(map, 'phone')) ?? '',
      email: ModelParsing.stringOrNull(ModelParsing.value(map, 'email')) ?? '',
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

  factory Store.fromJson(String source) =>
      Store.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Store(id: $id, uuid: $uuid, ownerUserUuid: $ownerUserUuid, name: $name, description: $description, address: $address, phone: $phone, email: $email, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...syncProps,
    ownerUserUuid,
    name,
    description,
    address,
    phone,
    email,
  ];
}
