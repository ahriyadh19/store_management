// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class InventoryMovement {
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
  }) : uuid = uuid ?? UUIDGenerator.generate();

  InventoryMovement copyWith({
    int? id,
    String? uuid,
    String? companyProductUuid,
    String? productUuid,
    InventoryMovementType? movementType,
    int? quantityDelta,
    int? balanceAfter,
    Decimal? unitCost,
    InventoryReferenceType? referenceType,
    String? referenceUuid,
    String? note,
    String? createdByUserUuid,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InventoryMovement(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      companyProductUuid: companyProductUuid ?? this.companyProductUuid,
      productUuid: productUuid ?? this.productUuid,
      movementType: movementType ?? this.movementType,
      quantityDelta: quantityDelta ?? this.quantityDelta,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      unitCost: unitCost ?? this.unitCost,
      referenceType: referenceType ?? this.referenceType,
      referenceUuid: referenceUuid ?? this.referenceUuid,
      note: note ?? this.note,
      createdByUserUuid: createdByUserUuid ?? this.createdByUserUuid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryMovement.fromJson(String source) => InventoryMovement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'InventoryMovement(id: $id, uuid: $uuid, companyProductUuid: $companyProductUuid, productUuid: $productUuid, movementType: $movementType, quantityDelta: $quantityDelta, balanceAfter: $balanceAfter, unitCost: $unitCost, referenceType: $referenceType, referenceUuid: $referenceUuid, note: $note, createdByUserUuid: $createdByUserUuid, createdAt: $createdAt, updatedAt: $updatedAt)';
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
        other.updatedAt == updatedAt;
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
        updatedAt.hashCode;
  }
}