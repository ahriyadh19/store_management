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
  int quantityDelta;
  int balanceAfter;
  Decimal? unitCost;
  InventoryReferenceType referenceType;
  String? referenceUuid;
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
    required this.quantityDelta,
    required this.balanceAfter,
    this.unitCost,
    required this.referenceType,
    this.referenceUuid,
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
    int? quantityDelta,
    int? balanceAfter,
    Object? unitCost = _unset,
    InventoryReferenceType? referenceType,
    Object? referenceUuid = _unset,
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
      quantityDelta: quantityDelta ?? this.quantityDelta,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      unitCost: identical(unitCost, _unset) ? this.unitCost : unitCost as Decimal?,
      referenceType: referenceType ?? this.referenceType,
      referenceUuid: identical(referenceUuid, _unset) ? this.referenceUuid : referenceUuid as String?,
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
      'quantityDelta': quantityDelta,
      'balanceAfter': balanceAfter,
      'unitCost': unitCost?.toString(),
      'referenceType': referenceType.value,
      'referenceUuid': referenceUuid,
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
      companyProductUuid: ModelParsing.stringOrThrow(map['companyProductUuid'], 'companyProductUuid'),
      productUuid: ModelParsing.stringOrThrow(map['productUuid'], 'productUuid'),
      movementType: ModelParsing.inventoryMovementTypeFromValue(map['movementType'], 'movementType'),
      quantityDelta: ModelParsing.intOrThrow(map['quantityDelta'], 'quantityDelta'),
      balanceAfter: ModelParsing.intOrThrow(map['balanceAfter'], 'balanceAfter'),
      unitCost: ModelParsing.decimalOrNull(map['unitCost']),
      referenceType: ModelParsing.inventoryReferenceTypeFromValue(map['referenceType'], 'referenceType'),
      referenceUuid: ModelParsing.stringOrNull(map['referenceUuid']),
      note: ModelParsing.stringOrThrow(map['note'], 'note'),
      createdByUserUuid: ModelParsing.stringOrNull(map['createdByUserUuid']),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryMovement.fromJson(String source) => InventoryMovement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InventoryMovement(id: $id, uuid: $uuid, companyProductUuid: $companyProductUuid, productUuid: $productUuid, movementType: $movementType, quantityDelta: $quantityDelta, balanceAfter: $balanceAfter, unitCost: $unitCost, referenceType: $referenceType, referenceUuid: $referenceUuid, note: $note, createdByUserUuid: $createdByUserUuid, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant InventoryMovement other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.companyProductUuid == companyProductUuid &&
        other.productUuid == productUuid &&
        other.movementType == movementType &&
        other.quantityDelta == quantityDelta &&
        other.balanceAfter == balanceAfter &&
        other.unitCost == unitCost &&
        other.referenceType == referenceType &&
        other.referenceUuid == referenceUuid &&
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
        quantityDelta.hashCode ^
        balanceAfter.hashCode ^
        unitCost.hashCode ^
        referenceType.hashCode ^
        referenceUuid.hashCode ^
        note.hashCode ^
        createdByUserUuid.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}