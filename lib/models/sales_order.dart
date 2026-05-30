// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class SalesOrder extends StatusedSyncModel<String> {
  String ownerUuid;
  String storeUuid;
  String branchUuid;
  String? customerUuid;
  String orderNumber;
  DateTime orderDate;
  String pricingStrategy;
  String? createdByUserUuid;

  SalesOrder({
    super.id = 0,
    super.uuid,
    required this.ownerUuid,
    required this.storeUuid,
    required this.branchUuid,
    this.customerUuid,
    required this.orderNumber,
    required this.orderDate,
    required super.status,
    required this.pricingStrategy,
    this.createdByUserUuid,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    'ownerUuid': ownerUuid,
    'storeUuid': storeUuid,
    'branchUuid': branchUuid,
    'customerUuid': customerUuid,
    'orderNumber': orderNumber,
    'orderDate': orderDate.millisecondsSinceEpoch,
    'pricingStrategy': pricingStrategy,
    'createdByUserUuid': createdByUserUuid,
    ...statusedSyncMap(),
  };

  @override
  List<Object?> get props => <Object?>[
    ...statusedSyncProps,
    ownerUuid,
    storeUuid,
    branchUuid,
    customerUuid,
    orderNumber,
    orderDate,
    pricingStrategy,
    createdByUserUuid,
  ];

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
