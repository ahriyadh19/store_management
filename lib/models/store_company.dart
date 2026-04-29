// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class StoreCompany {
  @Id()
  int id = 0;
  String uuid;
  String storeUuid;
  String companyUuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  StoreCompany({
    this.id = 0,
    String? uuid,
    required this.storeUuid,
    required this.companyUuid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StoreCompany copyWith({int? id, String? uuid, String? storeUuid, String? companyUuid, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return StoreCompany(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeUuid: storeUuid ?? this.storeUuid,
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
      'storeUuid': storeUuid,
      'companyUuid': companyUuid,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory StoreCompany.fromMap(Map<String, dynamic> map) {
    return StoreCompany(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      storeUuid: ModelParsing.stringOrThrow(map['storeUuid'], 'storeUuid'),
      companyUuid: ModelParsing.stringOrThrow(map['companyUuid'], 'companyUuid'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreCompany.fromJson(String source) => StoreCompany.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreCompany(id: $id, uuid: $uuid, storeUuid: $storeUuid, companyUuid: $companyUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StoreCompany other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeUuid == storeUuid &&
        other.companyUuid == companyUuid &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ storeUuid.hashCode ^ companyUuid.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}