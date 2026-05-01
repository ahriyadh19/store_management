// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class ProductsTags {
  @Id()
  int id = 0;
  String uuid;
  String productUuid;
  String tagUuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;
  ProductsTags({this.id = 0, String? uuid, required this.productUuid, required this.tagUuid, required this.status, required this.createdAt, required this.updatedAt, this.synced = false, this.deletedAt, this.syncedAt})
    : uuid = uuid ?? UUIDGenerator.generate();

  ProductsTags copyWith({int? id, String? uuid, String? productUuid, String? tagUuid, int? status, DateTime? createdAt, DateTime? updatedAt, bool? synced, DateTime? deletedAt, DateTime? syncedAt}) {
    return ProductsTags(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      productUuid: productUuid ?? this.productUuid,
      tagUuid: tagUuid ?? this.tagUuid,
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
      'id': id,
      'uuid': uuid,
      'productUuid': productUuid,
      'tagUuid': tagUuid,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory ProductsTags.fromMap(Map<String, dynamic> map) {
    return ProductsTags(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      productUuid: ModelParsing.stringOrThrow(map['productUuid'], 'productUuid'),
      tagUuid: ModelParsing.stringOrThrow(map['tagUuid'], 'tagUuid'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'] ?? map['created_at'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'] ?? map['updated_at'], 'updatedAt'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsTags.fromJson(String source) => ProductsTags.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductsTags(id: $id, uuid: $uuid, productUuid: $productUuid, tagUuid: $tagUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
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
        other.updatedAt == updatedAt &&
        other.synced == synced &&
        other.deletedAt == deletedAt &&
        other.syncedAt == syncedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ productUuid.hashCode ^ tagUuid.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode ^ synced.hashCode ^ deletedAt.hashCode ^ syncedAt.hashCode;
  }
}
