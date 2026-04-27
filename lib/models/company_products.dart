// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class CompanyProducts {
  int? id;
  String uuid;
  String companyId;
  String productId;
  double price;
  String description;
  int stock;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  CompanyProducts({
    String? uuid,
    this.id,
    required this.companyId,
    required this.productId,
    required this.price,
    required this.description,
    required this.stock,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  CompanyProducts copyWith({int? id, String? uuid, String? companyId, String? productId, double? price, String? description, int? stock, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return CompanyProducts(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      companyId: companyId ?? this.companyId,
      productId: productId ?? this.productId,
      price: price ?? this.price,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'companyId': companyId,
      'productId': productId,
      'price': price,
      'description': description,
      'stock': stock,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory CompanyProducts.fromMap(Map<String, dynamic> map) {
    return CompanyProducts(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      companyId: map['companyId'] as String,
      productId: map['productId'] as String,
      price: ModelParsing.doubleOrThrow(map['price'], 'price'),
      description: map['description'] as String,
      stock: ModelParsing.intOrThrow(map['stock'], 'stock'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyProducts.fromJson(String source) => CompanyProducts.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompanyProducts(id: $id, uuid: $uuid, companyId: $companyId, productId: $productId, price: $price, description: $description, stock: $stock, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CompanyProducts other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.companyId == companyId &&
        other.productId == productId &&
        other.price == price &&
        other.description == description &&
        other.stock == stock &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ companyId.hashCode ^ productId.hashCode ^ price.hashCode ^ description.hashCode ^ stock.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
