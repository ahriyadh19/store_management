// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class ProductsTags {
  int? id;
  String uuid;
  String productUuid;
  String tagUuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  ProductsTags({this.id, String? uuid, required this.productUuid, required this.tagUuid, required this.status, required this.createdAt, required this.updatedAt})
    : uuid = uuid ?? UUIDGenerator.generate();

  ProductsTags copyWith({int? id, String? uuid, String? productUuid, String? tagUuid, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return ProductsTags(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      productUuid: productUuid ?? this.productUuid,
      tagUuid: tagUuid ?? this.tagUuid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'productUuid': productUuid,
      'tagUuid': tagUuid,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ProductsTags.fromMap(Map<String, dynamic> map) {
    return ProductsTags(
      id: ModelParsing.intOrNull(map['id']),
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      productUuid: ModelParsing.stringOrThrow(map['productUuid'], 'productUuid'),
      tagUuid: ModelParsing.stringOrThrow(map['tagUuid'], 'tagUuid'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsTags.fromJson(String source) => ProductsTags.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductsTags(id: $id, uuid: $uuid, productUuid: $productUuid, tagUuid: $tagUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ProductsTags other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.productUuid == productUuid &&
        other.tagUuid == tagUuid &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ productUuid.hashCode ^ tagUuid.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
