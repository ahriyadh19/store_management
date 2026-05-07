// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class SalesReturn {
  @Id()
  int id = 0;
  String uuid;
  String ownerUuid;
  String salesInvoiceUuid;
  String returnNumber;
  DateTime returnDate;
  String reason;
  Decimal refundAmount;
  String status;
  String? createdByUserUuid;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  SalesReturn({
    this.id = 0,
    String? uuid,
    required this.ownerUuid,
    required this.salesInvoiceUuid,
    required this.returnNumber,
    required this.returnDate,
    required this.reason,
    required this.refundAmount,
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
    'salesInvoiceUuid': salesInvoiceUuid,
    'returnNumber': returnNumber,
    'returnDate': returnDate.millisecondsSinceEpoch,
    'reason': reason,
    'refundAmount': refundAmount.toString(),
    'status': status,
    'createdByUserUuid': createdByUserUuid,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
    'synced': synced,
    'deletedAt': deletedAt?.millisecondsSinceEpoch,
    'syncedAt': syncedAt?.millisecondsSinceEpoch,
  };

  factory SalesReturn.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return SalesReturn(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      salesInvoiceUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'salesInvoiceUuid'), 'salesInvoiceUuid'),
      returnNumber: ModelParsing.stringOrThrow(ModelParsing.value(map, 'returnNumber'), 'returnNumber'),
      returnDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'returnDate'), 'returnDate'),
      reason: ModelParsing.stringOrNull(ModelParsing.value(map, 'reason')) ?? '',
      refundAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'refundAmount'), 'refundAmount'),
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
  factory SalesReturn.fromJson(String source) => SalesReturn.fromMap(json.decode(source) as Map<String, dynamic>);
}
