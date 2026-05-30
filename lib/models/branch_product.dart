// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class BranchProduct extends AuditedSyncModel {
  static const Object _unset = Object();

  String branchUuid;
  String supplierProductUuid;
  String productUuid;
  int stock;
  int reservedQuantity;
  int? reorderLevel;
  DateTime? lastMovementAt;

  BranchProduct({
    super.id = 0,
    super.uuid,
    required this.branchUuid,
    required this.supplierProductUuid,
    required this.productUuid,
    required this.stock,
    this.reservedQuantity = 0,
    this.reorderLevel,
    this.lastMovementAt,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  BranchProduct copyWith({
    int? id,
    String? uuid,
    String? branchUuid,
    String? supplierProductUuid,
    String? productUuid,
    int? stock,
    int? reservedQuantity,
    Object? reorderLevel = _unset,
    Object? lastMovementAt = _unset,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return BranchProduct(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      branchUuid: branchUuid ?? this.branchUuid,
      supplierProductUuid: supplierProductUuid ?? this.supplierProductUuid,
      productUuid: productUuid ?? this.productUuid,
      stock: stock ?? this.stock,
      reservedQuantity: reservedQuantity ?? this.reservedQuantity,
      reorderLevel: identical(reorderLevel, _unset) ? this.reorderLevel : reorderLevel as int?,
      lastMovementAt: identical(lastMovementAt, _unset) ? this.lastMovementAt : lastMovementAt as DateTime?,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  int get availableQuantity => stock - reservedQuantity;

  bool get isLowStock => reorderLevel != null && availableQuantity <= reorderLevel!;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'branchUuid': branchUuid,
      'supplierProductUuid': supplierProductUuid,
      'productUuid': productUuid,
      'stock': stock,
      'reservedQuantity': reservedQuantity,
      'reorderLevel': reorderLevel,
      'lastMovementAt': lastMovementAt?.millisecondsSinceEpoch,
      ...auditedSyncMap(),
    };
  }

  factory BranchProduct.fromMap(Map<String, dynamic> map) {
    return BranchProduct(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      branchUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'branchUuid'), 'branchUuid'),
      supplierProductUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'supplierProductUuid'), 'supplierProductUuid'),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
      stock: ModelParsing.intOrThrow(ModelParsing.value(map, 'stock'), 'stock'),
      reservedQuantity: ModelParsing.intOrNull(ModelParsing.value(map, 'reservedQuantity')) ?? 0,
      reorderLevel: ModelParsing.intOrNull(ModelParsing.value(map, 'reorderLevel')),
      lastMovementAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'lastMovementAt')),
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt'), 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt'), 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory BranchProduct.fromJson(String source) => BranchProduct.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BranchProduct(id: $id, uuid: $uuid, branchUuid: $branchUuid, supplierProductUuid: $supplierProductUuid, productUuid: $productUuid, stock: $stock, reservedQuantity: $reservedQuantity, reorderLevel: $reorderLevel, lastMovementAt: $lastMovementAt, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[...auditedSyncProps, branchUuid, supplierProductUuid, productUuid, stock, reservedQuantity, reorderLevel, lastMovementAt];
}
