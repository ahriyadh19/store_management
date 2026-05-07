// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class SalesInvoice {
  @Id()
  int id = 0;
  String uuid;
  String ownerUuid;
  String storeUuid;
  String branchUuid;
  String? salesOrderUuid;
  String? customerUuid;
  String invoiceNumber;
  DateTime issuedAt;
  String currencyCode;
  Decimal subtotal;
  Decimal discountAmount;
  Decimal taxAmount;
  Decimal totalAmount;
  Decimal paidAmount;
  String status;
  String? createdByUserUuid;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  SalesInvoice({
    this.id = 0,
    String? uuid,
    required this.ownerUuid,
    required this.storeUuid,
    required this.branchUuid,
    this.salesOrderUuid,
    this.customerUuid,
    required this.invoiceNumber,
    required this.issuedAt,
    required this.currencyCode,
    required this.subtotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalAmount,
    required this.paidAmount,
    required this.status,
    this.createdByUserUuid,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'uuid': uuid,
    'ownerUuid': ownerUuid,
    'storeUuid': storeUuid,
    'branchUuid': branchUuid,
    'salesOrderUuid': salesOrderUuid,
    'customerUuid': customerUuid,
    'invoiceNumber': invoiceNumber,
    'issuedAt': issuedAt.millisecondsSinceEpoch,
    'currencyCode': currencyCode,
    'subtotal': subtotal.toString(),
    'discountAmount': discountAmount.toString(),
    'taxAmount': taxAmount.toString(),
    'totalAmount': totalAmount.toString(),
    'paidAmount': paidAmount.toString(),
    'status': status,
    'createdByUserUuid': createdByUserUuid,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
    'synced': synced,
    'deletedAt': deletedAt?.millisecondsSinceEpoch,
    'syncedAt': syncedAt?.millisecondsSinceEpoch,
  };

  factory SalesInvoice.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return SalesInvoice(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      storeUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'storeUuid'), 'storeUuid'),
      branchUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'branchUuid'), 'branchUuid'),
      salesOrderUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'salesOrderUuid')),
      customerUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'customerUuid')),
      invoiceNumber: ModelParsing.stringOrThrow(ModelParsing.value(map, 'invoiceNumber'), 'invoiceNumber'),
      issuedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'issuedAt'), 'issuedAt'),
      currencyCode: ModelParsing.stringOrThrow(ModelParsing.value(map, 'currencyCode'), 'currencyCode'),
      subtotal: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'subtotal'), 'subtotal'),
      discountAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'discountAmount'), 'discountAmount'),
      taxAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'taxAmount'), 'taxAmount'),
      totalAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'totalAmount'), 'totalAmount'),
      paidAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'paidAmount'), 'paidAmount'),
      status: ModelParsing.stringOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdByUserUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'createdByUserUuid')),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());
  factory SalesInvoice.fromJson(String source) => SalesInvoice.fromMap(json.decode(source) as Map<String, dynamic>);
}
