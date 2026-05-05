// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class SupplierProducts {
  static const Object _unset = Object();

  @Id()
  int id = 0;
  String uuid;
  String supplierUuid;
  String productUuid;
  Decimal price;
  Decimal? costPrice;
  String description;
  String? sku;
  String? barcode;
  String? batchNumber;
  DateTime? expiryDate;
  int stock;
  int? reorderLevel;
  int? reorderQuantity;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  SupplierProducts({
    String? uuid,
    this.id = 0,
    required this.supplierUuid,
    required this.productUuid,
    required this.price,
    this.costPrice,
    required this.description,
    this.sku,
    this.barcode,
    this.batchNumber,
    this.expiryDate,
    required this.stock,
    this.reorderLevel,
    this.reorderQuantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  SupplierProducts copyWith({
    int? id,
    String? uuid,
    String? supplierUuid,
    String? productUuid,
    Decimal? price,
    Object? costPrice = _unset,
    String? description,
    Object? sku = _unset,
    Object? barcode = _unset,
    Object? batchNumber = _unset,
    Object? expiryDate = _unset,
    int? stock,
    Object? reorderLevel = _unset,
    Object? reorderQuantity = _unset,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return SupplierProducts(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      supplierUuid: supplierUuid ?? this.supplierUuid,
      productUuid: productUuid ?? this.productUuid,
      price: price ?? this.price,
      costPrice: identical(costPrice, _unset) ? this.costPrice : costPrice as Decimal?,
      description: description ?? this.description,
      sku: identical(sku, _unset) ? this.sku : sku as String?,
      barcode: identical(barcode, _unset) ? this.barcode : barcode as String?,
      batchNumber: identical(batchNumber, _unset) ? this.batchNumber : batchNumber as String?,
      expiryDate: identical(expiryDate, _unset) ? this.expiryDate : expiryDate as DateTime?,
      stock: stock ?? this.stock,
      reorderLevel: identical(reorderLevel, _unset) ? this.reorderLevel : reorderLevel as int?,
      reorderQuantity: identical(reorderQuantity, _unset) ? this.reorderQuantity : reorderQuantity as int?,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  bool get isLowStock => reorderLevel != null && stock <= reorderLevel!;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'supplierUuid': supplierUuid,
      'productUuid': productUuid,
      'price': price.toString(),
      'costPrice': costPrice?.toString(),
      'description': description,
      'sku': sku,
      'barcode': barcode,
      'batchNumber': batchNumber,
      'expiryDate': expiryDate?.millisecondsSinceEpoch,
      'stock': stock,
      'reorderLevel': reorderLevel,
      'reorderQuantity': reorderQuantity,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory SupplierProducts.fromMap(Map<String, dynamic> map) {
    return SupplierProducts(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      supplierUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'supplierUuid'), 'supplierUuid'),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
      price: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'price'), 'price'),
      costPrice: ModelParsing.decimalOrNull(ModelParsing.value(map, 'costPrice')),
      description: ModelParsing.stringOrThrow(ModelParsing.value(map, 'description'), 'description'),
      sku: ModelParsing.stringOrNull(ModelParsing.value(map, 'sku')),
      barcode: ModelParsing.stringOrNull(ModelParsing.value(map, 'barcode')),
      batchNumber: ModelParsing.stringOrNull(ModelParsing.value(map, 'batchNumber')),
      expiryDate: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'expiryDate')),
      stock: ModelParsing.intOrThrow(ModelParsing.value(map, 'stock'), 'stock'),
      reorderLevel: ModelParsing.intOrNull(ModelParsing.value(map, 'reorderLevel')),
      reorderQuantity: ModelParsing.intOrNull(ModelParsing.value(map, 'reorderQuantity')),
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt'), 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt'), 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory SupplierProducts.fromJson(String source) => SupplierProducts.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SupplierProducts(id: $id, uuid: $uuid, supplierUuid: $supplierUuid, productUuid: $productUuid, price: $price, costPrice: $costPrice, description: $description, sku: $sku, barcode: $barcode, batchNumber: $batchNumber, expiryDate: $expiryDate, stock: $stock, reorderLevel: $reorderLevel, reorderQuantity: $reorderQuantity, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant SupplierProducts other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.supplierUuid == supplierUuid &&
        other.productUuid == productUuid &&
        other.price == price &&
        other.costPrice == costPrice &&
        other.description == description &&
        other.sku == sku &&
        other.barcode == barcode &&
        other.batchNumber == batchNumber &&
        other.expiryDate == expiryDate &&
        other.stock == stock &&
        other.reorderLevel == reorderLevel &&
        other.reorderQuantity == reorderQuantity &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.synced == synced &&
        other.deletedAt == deletedAt &&
        other.syncedAt == syncedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        supplierUuid.hashCode ^
        productUuid.hashCode ^
        price.hashCode ^
        costPrice.hashCode ^
        description.hashCode ^
        sku.hashCode ^
        barcode.hashCode ^
        batchNumber.hashCode ^
        expiryDate.hashCode ^
        stock.hashCode ^
        reorderLevel.hashCode ^
        reorderQuantity.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}

