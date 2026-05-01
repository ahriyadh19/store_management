// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class InventoryMovement {
  static const Object _unset = Object();

  @Id()
  int id = 0;
  String uuid;
  String companyProductUuid;
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
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  InventoryMovement({
    this.id = 0,
    String? uuid,
    required this.companyProductUuid,
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
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  InventoryMovement copyWith({
    int? id,
    String? uuid,
    String? companyProductUuid,
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
      companyProductUuid: companyProductUuid ?? this.companyProductUuid,
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
      'id': id,
      'uuid': uuid,
      'companyProductUuid': companyProductUuid,
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
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory InventoryMovement.fromMap(Map<String, dynamic> map) {
    return InventoryMovement(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      companyProductUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'companyProductUuid'), 'companyProductUuid'),
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
      note: ModelParsing.stringOrThrow(map['note'], 'note'),
      createdByUserUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'createdByUserUuid')),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'] ?? map['created_at'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'] ?? map['updated_at'], 'updatedAt'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryMovement.fromJson(String source) => InventoryMovement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InventoryMovement(id: $id, uuid: $uuid, companyProductUuid: $companyProductUuid, productUuid: $productUuid, movementType: $movementType, inventoryHolderType: $inventoryHolderType, inventoryHolderUuid: $inventoryHolderUuid, quantityDelta: $quantityDelta, balanceAfter: $balanceAfter, unitCost: $unitCost, referenceType: $referenceType, referenceUuid: $referenceUuid, counterpartyHolderType: $counterpartyHolderType, counterpartyHolderUuid: $counterpartyHolderUuid, transactionUuid: $transactionUuid, note: $note, createdByUserUuid: $createdByUserUuid, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant InventoryMovement other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.companyProductUuid == companyProductUuid &&
        other.productUuid == productUuid &&
        other.movementType == movementType &&
        other.inventoryHolderType == inventoryHolderType &&
        other.inventoryHolderUuid == inventoryHolderUuid &&
        other.quantityDelta == quantityDelta &&
        other.balanceAfter == balanceAfter &&
        other.unitCost == unitCost &&
        other.referenceType == referenceType &&
        other.referenceUuid == referenceUuid &&
        other.counterpartyHolderType == counterpartyHolderType &&
        other.counterpartyHolderUuid == counterpartyHolderUuid &&
        other.transactionUuid == transactionUuid &&
        other.note == note &&
        other.createdByUserUuid == createdByUserUuid &&
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
        companyProductUuid.hashCode ^
        productUuid.hashCode ^
        movementType.hashCode ^
        inventoryHolderType.hashCode ^
        inventoryHolderUuid.hashCode ^
        quantityDelta.hashCode ^
        balanceAfter.hashCode ^
        unitCost.hashCode ^
        referenceType.hashCode ^
        referenceUuid.hashCode ^
        counterpartyHolderType.hashCode ^
        counterpartyHolderUuid.hashCode ^
        transactionUuid.hashCode ^
        note.hashCode ^
        createdByUserUuid.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}