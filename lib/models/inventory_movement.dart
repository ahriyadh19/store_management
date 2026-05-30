// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';

class InventoryMovement extends TimestampedSyncModel {
  static const Object _unset = Object();

  String supplierProductUuid;
  String productUuid;
  InventoryMovementType movementType;
  InventoryHolderType? inventoryHolderType;
  String? inventoryHolderUuid;
  int quantityDelta;
  int balanceAfter;
  Decimal? unitCost;
  InventoryReferenceType referenceType;
  String? referenceUuid;
  InventoryHolderType? counterpartyHolderType;
  String? counterpartyHolderUuid;
  String? transactionUuid;
  String note;
  String? createdByUserUuid;

  InventoryMovement({
    super.id = 0,
    super.uuid,
    required this.supplierProductUuid,
    required this.productUuid,
    required this.movementType,
    this.inventoryHolderType,
    this.inventoryHolderUuid,
    required this.quantityDelta,
    required this.balanceAfter,
    this.unitCost,
    required this.referenceType,
    this.referenceUuid,
    this.counterpartyHolderType,
    this.counterpartyHolderUuid,
    this.transactionUuid,
    required this.note,
    this.createdByUserUuid,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  InventoryMovement copyWith({
    int? id,
    String? uuid,
    String? supplierProductUuid,
    String? productUuid,
    InventoryMovementType? movementType,
    Object? inventoryHolderType = _unset,
    Object? inventoryHolderUuid = _unset,
    int? quantityDelta,
    int? balanceAfter,
    Object? unitCost = _unset,
    InventoryReferenceType? referenceType,
    Object? referenceUuid = _unset,
    Object? counterpartyHolderType = _unset,
    Object? counterpartyHolderUuid = _unset,
    Object? transactionUuid = _unset,
    String? note,
    Object? createdByUserUuid = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return InventoryMovement(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      supplierProductUuid: supplierProductUuid ?? this.supplierProductUuid,
      productUuid: productUuid ?? this.productUuid,
      movementType: movementType ?? this.movementType,
      inventoryHolderType: identical(inventoryHolderType, _unset) ? this.inventoryHolderType : inventoryHolderType as InventoryHolderType?,
      inventoryHolderUuid: identical(inventoryHolderUuid, _unset) ? this.inventoryHolderUuid : inventoryHolderUuid as String?,
      quantityDelta: quantityDelta ?? this.quantityDelta,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      unitCost: identical(unitCost, _unset) ? this.unitCost : unitCost as Decimal?,
      referenceType: referenceType ?? this.referenceType,
      referenceUuid: identical(referenceUuid, _unset) ? this.referenceUuid : referenceUuid as String?,
      counterpartyHolderType: identical(counterpartyHolderType, _unset) ? this.counterpartyHolderType : counterpartyHolderType as InventoryHolderType?,
      counterpartyHolderUuid: identical(counterpartyHolderUuid, _unset) ? this.counterpartyHolderUuid : counterpartyHolderUuid as String?,
      transactionUuid: identical(transactionUuid, _unset) ? this.transactionUuid : transactionUuid as String?,
      note: note ?? this.note,
      createdByUserUuid: identical(createdByUserUuid, _unset) ? this.createdByUserUuid : createdByUserUuid as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'supplierProductUuid': supplierProductUuid,
      'productUuid': productUuid,
      'movementType': movementType.value,
      'inventoryHolderType': inventoryHolderType?.value,
      'inventoryHolderUuid': inventoryHolderUuid,
      'quantityDelta': quantityDelta,
      'balanceAfter': balanceAfter,
      'unitCost': unitCost?.toString(),
      'referenceType': referenceType.value,
      'referenceUuid': referenceUuid,
      'counterpartyHolderType': counterpartyHolderType?.value,
      'counterpartyHolderUuid': counterpartyHolderUuid,
      'transactionUuid': transactionUuid,
      'note': note,
      'createdByUserUuid': createdByUserUuid,
      ...timestampedSyncMap(),
    };
  }

  Map<String, dynamic> toErpMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'supplier_product_uuid': supplierProductUuid,
      'product_uuid': productUuid,
      'movement_type': movementType.value,
      'inventory_holder_type': inventoryHolderType?.value,
      'inventory_holder_uuid': inventoryHolderUuid,
      'quantity_delta': quantityDelta,
      'balance_after': balanceAfter,
      'unit_cost': unitCost?.toString(),
      'reference_type': referenceType.value,
      'reference_uuid': referenceUuid,
      'counterparty_holder_type': counterpartyHolderType?.value,
      'counterparty_holder_uuid': counterpartyHolderUuid,
      'transaction_uuid': transactionUuid,
      'note': note,
      'created_by_user_uuid': createdByUserUuid,
      'created_at': ModelParsing.dateTimeToIso8601Utc(createdAt),
      'updated_at': ModelParsing.dateTimeToIso8601Utc(updatedAt),
      'synced': synced,
      'deleted_at': ModelParsing.dateTimeOrNullToIso8601Utc(deletedAt),
      'synced_at': ModelParsing.dateTimeOrNullToIso8601Utc(syncedAt),
    };
  }

  factory InventoryMovement.fromMap(Map<String, dynamic> map) {
    return InventoryMovement(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      supplierProductUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'supplierProductUuid'), 'supplierProductUuid'),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
      movementType: ModelParsing.inventoryMovementTypeFromValue(ModelParsing.value(map, 'movementType'), 'movementType'),
      inventoryHolderType: ModelParsing.value(map, 'inventoryHolderType') == null ? null : ModelParsing.inventoryHolderTypeFromValue(ModelParsing.value(map, 'inventoryHolderType'), 'inventoryHolderType'),
      inventoryHolderUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'inventoryHolderUuid')),
      quantityDelta: ModelParsing.intOrThrow(ModelParsing.value(map, 'quantityDelta'), 'quantityDelta'),
      balanceAfter: ModelParsing.intOrThrow(ModelParsing.value(map, 'balanceAfter'), 'balanceAfter'),
      unitCost: ModelParsing.decimalOrNull(ModelParsing.value(map, 'unitCost')),
      referenceType: ModelParsing.inventoryReferenceTypeFromValue(ModelParsing.value(map, 'referenceType'), 'referenceType'),
      referenceUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'referenceUuid')),
      counterpartyHolderType: ModelParsing.value(map, 'counterpartyHolderType') == null ? null : ModelParsing.inventoryHolderTypeFromValue(ModelParsing.value(map, 'counterpartyHolderType'), 'counterpartyHolderType'),
      counterpartyHolderUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'counterpartyHolderUuid')),
      transactionUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'transactionUuid')),
      note: ModelParsing.stringOrThrow(ModelParsing.value(map, 'note'), 'note'),
      createdByUserUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'createdByUserUuid')),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt'), 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt'), 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryMovement.fromJson(String source) => InventoryMovement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InventoryMovement(id: $id, uuid: $uuid, supplierProductUuid: $supplierProductUuid, productUuid: $productUuid, movementType: $movementType, inventoryHolderType: $inventoryHolderType, inventoryHolderUuid: $inventoryHolderUuid, quantityDelta: $quantityDelta, balanceAfter: $balanceAfter, unitCost: $unitCost, referenceType: $referenceType, referenceUuid: $referenceUuid, counterpartyHolderType: $counterpartyHolderType, counterpartyHolderUuid: $counterpartyHolderUuid, transactionUuid: $transactionUuid, note: $note, createdByUserUuid: $createdByUserUuid, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...timestampedSyncProps,
    supplierProductUuid,
    productUuid,
    movementType,
    inventoryHolderType,
    inventoryHolderUuid,
    quantityDelta,
    balanceAfter,
    unitCost,
    referenceType,
    referenceUuid,
    counterpartyHolderType,
    counterpartyHolderUuid,
    transactionUuid,
    note,
    createdByUserUuid,
  ];
}
