// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class StoreCompany {
  int? id;
  String uuid;
  int storeId;
  String storeUuid;
  int companyId;
  String companyUuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  StoreCompany({
    this.id,
    String? uuid,
    required this.storeId,
    required this.storeUuid,
    required this.companyId,
    required this.companyUuid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StoreCompany copyWith({int? id, String? uuid, int? storeId, String? storeUuid, int? companyId, String? companyUuid, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return StoreCompany(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeId: storeId ?? this.storeId,
      storeUuid: storeUuid ?? this.storeUuid,
      companyId: companyId ?? this.companyId,
      companyUuid: companyUuid ?? this.companyUuid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'storeId': storeId,
      'storeUuid': storeUuid,
      'companyId': companyId,
      'companyUuid': companyUuid,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory StoreCompany.fromMap(Map<String, dynamic> map) {
    return StoreCompany(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      storeId: ModelParsing.intOrThrow(map['storeId'], 'storeId'),
      storeUuid: map['storeUuid'] as String,
      companyId: ModelParsing.intOrThrow(map['companyId'], 'companyId'),
      companyUuid: map['companyUuid'] as String,
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreCompany.fromJson(String source) => StoreCompany.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreCompany(id: $id, uuid: $uuid, storeId: $storeId, storeUuid: $storeUuid, companyId: $companyId, companyUuid: $companyUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StoreCompany other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeId == storeId &&
        other.storeUuid == storeUuid &&
        other.companyId == companyId &&
        other.companyUuid == companyUuid &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ storeId.hashCode ^ storeUuid.hashCode ^ companyId.hashCode ^ companyUuid.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}