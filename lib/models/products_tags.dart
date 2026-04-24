// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/services/uuid.dart';

class ProductsTags {
  int? id;
  String uuid;
  String productId;
  String tagId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  ProductsTags({this.id, String? uuid, required this.productId, required this.tagId, required this.status, required this.createdAt, required this.updatedAt}) : uuid = uuid ?? UUIDGenerator.generate();

  ProductsTags copyWith({int? id, String? uuid, String? productId, String? tagId, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return ProductsTags(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      productId: productId ?? this.productId,
      tagId: tagId ?? this.tagId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'uuid': uuid, 'productId': productId, 'tagId': tagId, 'status': status, 'createdAt': createdAt.millisecondsSinceEpoch, 'updatedAt': updatedAt.millisecondsSinceEpoch};
  }

  factory ProductsTags.fromMap(Map<String, dynamic> map) {
    return ProductsTags(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] as String,
      productId: map['productId'] as String,
      tagId: map['tagId'] as String,
      status: map['status'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductsTags.fromJson(String source) => ProductsTags.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductsTags(id: $id, uuid: $uuid, productId: $productId, tagId: $tagId, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ProductsTags other) {
    if (identical(this, other)) return true;

    return other.id == id && other.uuid == uuid && other.productId == productId && other.tagId == tagId && other.status == status && other.createdAt == createdAt && other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ productId.hashCode ^ tagId.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
