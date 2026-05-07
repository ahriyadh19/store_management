// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class SalesOrder {
  @Id()
  int id = 0;
  String uuid;
  String ownerUuid;
  String storeUuid;
  String branchUuid;
  String? customerUuid;
  String orderNumber;
  DateTime orderDate;
  String status;
  String pricingStrategy;
  String? createdByUserUuid;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  SalesOrder({
    this.id = 0,
    String? uuid,
    required this.ownerUuid,
    required this.storeUuid,
    required this.branchUuid,
    this.customerUuid,
    required this.orderNumber,
    required this.orderDate,
    required this.status,
    required this.pricingStrategy,
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
    'customerUuid': customerUuid,
    'orderNumber': orderNumber,
    'orderDate': orderDate.millisecondsSinceEpoch,
    'status': status,
    'pricingStrategy': pricingStrategy,
    'createdByUserUuid': createdByUserUuid,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
    'synced': synced,
    'deletedAt': deletedAt?.millisecondsSinceEpoch,
    'syncedAt': syncedAt?.millisecondsSinceEpoch,
  };

  factory SalesOrder.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return SalesOrder(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      storeUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'storeUuid'), 'storeUuid'),
      branchUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'branchUuid'), 'branchUuid'),
      customerUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'customerUuid')),
      orderNumber: ModelParsing.stringOrThrow(ModelParsing.value(map, 'orderNumber'), 'orderNumber'),
      orderDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'orderDate'), 'orderDate'),
      status: ModelParsing.stringOrThrow(ModelParsing.value(map, 'status'), 'status'),
      pricingStrategy: ModelParsing.stringOrThrow(ModelParsing.value(map, 'pricingStrategy'), 'pricingStrategy'),
      createdByUserUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'createdByUserUuid')),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());
  factory SalesOrder.fromJson(String source) => SalesOrder.fromMap(json.decode(source) as Map<String, dynamic>);
}
