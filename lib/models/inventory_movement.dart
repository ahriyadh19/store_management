// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class InventoryMovement {
  int? id;
  String uuid;
  int companyProductId;
  String companyProductUuid;
  int productId;
  String productUuid;
  InventoryMovementType movementType;
  int quantityDelta;
  int balanceAfter;
  Decimal? unitCost;
  InventoryReferenceType referenceType;
  int? referenceId;
  String? referenceUuid;
  String note;
  int? createdByUserId;
  String? createdByUserUuid;
  DateTime createdAt;
  DateTime updatedAt;

  InventoryMovement({
    this.id,
    String? uuid,
    required this.companyProductId,
    required this.companyProductUuid,
    required this.productId,
    required this.productUuid,
    required this.movementType,
    required this.quantityDelta,
    required this.balanceAfter,
    this.unitCost,
    required this.referenceType,
    this.referenceId,
    this.referenceUuid,
    required this.note,
    this.createdByUserId,
    this.createdByUserUuid,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  InventoryMovement copyWith({
    int? id,
    String? uuid,
    int? companyProductId,
    String? companyProductUuid,
    int? productId,
    String? productUuid,
    InventoryMovementType? movementType,
    int? quantityDelta,
    int? balanceAfter,
    Decimal? unitCost,
    InventoryReferenceType? referenceType,
    int? referenceId,
    String? referenceUuid,
    String? note,
    int? createdByUserId,
    String? createdByUserUuid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryMovement(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      companyProductId: companyProductId ?? this.companyProductId,
      companyProductUuid: companyProductUuid ?? this.companyProductUuid,
      productId: productId ?? this.productId,
      productUuid: productUuid ?? this.productUuid,
      movementType: movementType ?? this.movementType,
      quantityDelta: quantityDelta ?? this.quantityDelta,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      unitCost: unitCost ?? this.unitCost,
      referenceType: referenceType ?? this.referenceType,
      referenceId: referenceId ?? this.referenceId,
      referenceUuid: referenceUuid ?? this.referenceUuid,
      note: note ?? this.note,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdByUserUuid: createdByUserUuid ?? this.createdByUserUuid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'companyProductId': companyProductId,
      'companyProductUuid': companyProductUuid,
      'productId': productId,
      'productUuid': productUuid,
      'movementType': movementType.value,
      'quantityDelta': quantityDelta,
      'balanceAfter': balanceAfter,
      'unitCost': unitCost?.toString(),
      'referenceType': referenceType.value,
      'referenceId': referenceId,
      'referenceUuid': referenceUuid,
      'note': note,
      'createdByUserId': createdByUserId,
      'createdByUserUuid': createdByUserUuid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory InventoryMovement.fromMap(Map<String, dynamic> map) {
    return InventoryMovement(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      companyProductId: ModelParsing.intOrThrow(map['companyProductId'], 'companyProductId'),
      companyProductUuid: map['companyProductUuid'] as String,
      productId: ModelParsing.intOrThrow(map['productId'], 'productId'),
      productUuid: map['productUuid'] as String,
      movementType: ModelParsing.inventoryMovementTypeFromValue(map['movementType'], 'movementType'),
      quantityDelta: ModelParsing.intOrThrow(map['quantityDelta'], 'quantityDelta'),
      balanceAfter: ModelParsing.intOrThrow(map['balanceAfter'], 'balanceAfter'),
      unitCost: ModelParsing.decimalOrNull(map['unitCost']),
      referenceType: ModelParsing.inventoryReferenceTypeFromValue(map['referenceType'], 'referenceType'),
      referenceId: ModelParsing.intOrNull(map['referenceId']),
      referenceUuid: map['referenceUuid'] as String?,
      note: map['note'] as String,
      createdByUserId: ModelParsing.intOrNull(map['createdByUserId']),
      createdByUserUuid: map['createdByUserUuid'] as String?,
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryMovement.fromJson(String source) => InventoryMovement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InventoryMovement(id: $id, uuid: $uuid, companyProductId: $companyProductId, companyProductUuid: $companyProductUuid, productId: $productId, productUuid: $productUuid, movementType: $movementType, quantityDelta: $quantityDelta, balanceAfter: $balanceAfter, unitCost: $unitCost, referenceType: $referenceType, referenceId: $referenceId, referenceUuid: $referenceUuid, note: $note, createdByUserId: $createdByUserId, createdByUserUuid: $createdByUserUuid, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant InventoryMovement other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.companyProductId == companyProductId &&
        other.companyProductUuid == companyProductUuid &&
        other.productId == productId &&
        other.productUuid == productUuid &&
        other.movementType == movementType &&
        other.quantityDelta == quantityDelta &&
        other.balanceAfter == balanceAfter &&
        other.unitCost == unitCost &&
        other.referenceType == referenceType &&
        other.referenceId == referenceId &&
        other.referenceUuid == referenceUuid &&
        other.note == note &&
        other.createdByUserId == createdByUserId &&
        other.createdByUserUuid == createdByUserUuid &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        companyProductId.hashCode ^
        companyProductUuid.hashCode ^
        productId.hashCode ^
        productUuid.hashCode ^
        movementType.hashCode ^
        quantityDelta.hashCode ^
        balanceAfter.hashCode ^
        unitCost.hashCode ^
        referenceType.hashCode ^
        referenceId.hashCode ^
        referenceUuid.hashCode ^
        note.hashCode ^
        createdByUserId.hashCode ^
        createdByUserUuid.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}