// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class PurchaseOrder extends StatusedSyncModel<String> {
  String ownerUuid;
  String storeUuid;
  String supplierUuid;
  String poNumber;
  DateTime orderDate;
  DateTime? expectedDate;
  String currencyCode;
  Decimal totalAmount;
  String notes;
  String? createdByUserUuid;

  PurchaseOrder({
    super.id = 0,
    super.uuid,
    required this.ownerUuid,
    required this.storeUuid,
    required this.supplierUuid,
    required this.poNumber,
    required this.orderDate,
    this.expectedDate,
    required super.status,
    required this.currencyCode,
    required this.totalAmount,
    required this.notes,
    this.createdByUserUuid,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  PurchaseOrder copyWith({
    int? id,
    String? uuid,
    String? ownerUuid,
    String? storeUuid,
    String? supplierUuid,
    String? poNumber,
    DateTime? orderDate,
    DateTime? expectedDate,
    String? status,
    String? currencyCode,
    Decimal? totalAmount,
    String? notes,
    String? createdByUserUuid,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return PurchaseOrder(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      ownerUuid: ownerUuid ?? this.ownerUuid,
      storeUuid: storeUuid ?? this.storeUuid,
      supplierUuid: supplierUuid ?? this.supplierUuid,
      poNumber: poNumber ?? this.poNumber,
      orderDate: orderDate ?? this.orderDate,
      expectedDate: expectedDate ?? this.expectedDate,
      status: status ?? this.status,
      currencyCode: currencyCode ?? this.currencyCode,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes ?? this.notes,
      createdByUserUuid: createdByUserUuid ?? this.createdByUserUuid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ownerUuid': ownerUuid,
      'storeUuid': storeUuid,
      'supplierUuid': supplierUuid,
      'poNumber': poNumber,
      'orderDate': orderDate.millisecondsSinceEpoch,
      'expectedDate': expectedDate?.millisecondsSinceEpoch,
      'currencyCode': currencyCode,
      'totalAmount': totalAmount.toString(),
      'notes': notes,
      'createdByUserUuid': createdByUserUuid,
      ...statusedSyncMap(),
    };
  }

  factory PurchaseOrder.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return PurchaseOrder(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      storeUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'storeUuid'), 'storeUuid'),
      supplierUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'supplierUuid'), 'supplierUuid'),
      poNumber: ModelParsing.stringOrThrow(ModelParsing.value(map, 'poNumber'), 'poNumber'),
      orderDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'orderDate'), 'orderDate'),
      expectedDate: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'expectedDate')),
      status: ModelParsing.stringOrThrow(ModelParsing.value(map, 'status'), 'status'),
      currencyCode: ModelParsing.stringOrThrow(ModelParsing.value(map, 'currencyCode'), 'currencyCode'),
      totalAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'totalAmount'), 'totalAmount'),
      notes: ModelParsing.stringOrNull(ModelParsing.value(map, 'notes')) ?? '',
      createdByUserUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'createdByUserUuid')),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory PurchaseOrder.fromJson(String source) => PurchaseOrder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PurchaseOrder(id: $id, uuid: $uuid, ownerUuid: $ownerUuid, storeUuid: $storeUuid, supplierUuid: $supplierUuid, poNumber: $poNumber, orderDate: $orderDate, expectedDate: $expectedDate, status: $status, currencyCode: $currencyCode, totalAmount: $totalAmount, notes: $notes, createdByUserUuid: $createdByUserUuid, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[...statusedSyncProps, ownerUuid, storeUuid, supplierUuid, poNumber, orderDate, expectedDate, currencyCode, totalAmount, notes, createdByUserUuid];
}
