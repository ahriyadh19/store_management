// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class CompanyProducts {
  int? id;
  String uuid;
  int companyId;
  String companyUuid;
  int productId;
  String productUuid;
  Decimal price;
  Decimal? costPrice;
  String description;
  String? sku;
  String? barcode;
  int stock;
  int? reorderLevel;
  int? reorderQuantity;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  CompanyProducts({
    String? uuid,
    this.id,
    required this.companyId,
    required this.companyUuid,
    required this.productId,
    required this.productUuid,
    required this.price,
    this.costPrice,
    required this.description,
    this.sku,
    this.barcode,
    required this.stock,
    this.reorderLevel,
    this.reorderQuantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  CompanyProducts copyWith({
    int? id,
    String? uuid,
    int? companyId,
    String? companyUuid,
    int? productId,
    String? productUuid,
    Decimal? price,
    Decimal? costPrice,
    String? description,
    String? sku,
    String? barcode,
    int? stock,
    int? reorderLevel,
    int? reorderQuantity,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyProducts(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      companyId: companyId ?? this.companyId,
      companyUuid: companyUuid ?? this.companyUuid,
      productId: productId ?? this.productId,
      productUuid: productUuid ?? this.productUuid,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      stock: stock ?? this.stock,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      reorderQuantity: reorderQuantity ?? this.reorderQuantity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isLowStock => reorderLevel != null && stock <= reorderLevel!;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'companyId': companyId,
      'companyUuid': companyUuid,
      'productId': productId,
      'productUuid': productUuid,
      'price': price.toString(),
      'costPrice': costPrice?.toString(),
      'description': description,
      'sku': sku,
      'barcode': barcode,
      'stock': stock,
      'reorderLevel': reorderLevel,
      'reorderQuantity': reorderQuantity,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory CompanyProducts.fromMap(Map<String, dynamic> map) {
    return CompanyProducts(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      companyId: ModelParsing.intOrThrow(map['companyId'], 'companyId'),
      companyUuid: map['companyUuid'] as String,
      productId: ModelParsing.intOrThrow(map['productId'], 'productId'),
      productUuid: map['productUuid'] as String,
      price: ModelParsing.decimalOrThrow(map['price'], 'price'),
      costPrice: ModelParsing.decimalOrNull(map['costPrice']),
      description: map['description'] as String,
      sku: map['sku'] as String?,
      barcode: map['barcode'] as String?,
      stock: ModelParsing.intOrThrow(map['stock'], 'stock'),
      reorderLevel: ModelParsing.intOrNull(map['reorderLevel']),
      reorderQuantity: ModelParsing.intOrNull(map['reorderQuantity']),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory CompanyProducts.fromJson(String source) => CompanyProducts.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CompanyProducts(id: $id, uuid: $uuid, companyId: $companyId, companyUuid: $companyUuid, productId: $productId, productUuid: $productUuid, price: $price, costPrice: $costPrice, description: $description, sku: $sku, barcode: $barcode, stock: $stock, reorderLevel: $reorderLevel, reorderQuantity: $reorderQuantity, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant CompanyProducts other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.companyId == companyId &&
        other.companyUuid == companyUuid &&
        other.productId == productId &&
        other.productUuid == productUuid &&
        other.price == price &&
        other.costPrice == costPrice &&
        other.description == description &&
        other.sku == sku &&
        other.barcode == barcode &&
        other.stock == stock &&
        other.reorderLevel == reorderLevel &&
        other.reorderQuantity == reorderQuantity &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        companyId.hashCode ^
        companyUuid.hashCode ^
        productId.hashCode ^
        productUuid.hashCode ^
        price.hashCode ^
        costPrice.hashCode ^
        description.hashCode ^
        sku.hashCode ^
        barcode.hashCode ^
        stock.hashCode ^
        reorderLevel.hashCode ^
        reorderQuantity.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
