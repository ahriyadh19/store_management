// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class BranchPrice extends AuditedSyncModel {
  String ownerUuid;
  String branchUuid;
  String productUuid;
  String priceType;
  Decimal price;
  DateTime? startsAt;
  DateTime? endsAt;
  int priority;

  BranchPrice({
    super.id = 0,
    super.uuid,
    required this.ownerUuid,
    required this.branchUuid,
    required this.productUuid,
    required this.priceType,
    required this.price,
    this.startsAt,
    this.endsAt,
    this.priority = 0,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    'ownerUuid': ownerUuid,
    'branchUuid': branchUuid,
    'productUuid': productUuid,
    'priceType': priceType,
    'price': price.toString(),
    'startsAt': startsAt?.millisecondsSinceEpoch,
    'endsAt': endsAt?.millisecondsSinceEpoch,
    'priority': priority,
    ...auditedSyncMap(),
  };

  @override
  List<Object?> get props => <Object?>[...auditedSyncProps, ownerUuid, branchUuid, productUuid, priceType, price, startsAt, endsAt, priority];

  factory BranchPrice.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return BranchPrice(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      branchUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'branchUuid'), 'branchUuid'),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
      priceType: ModelParsing.stringOrThrow(ModelParsing.value(map, 'priceType'), 'priceType'),
      price: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'price'), 'price'),
      startsAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'startsAt')),
      endsAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'endsAt')),
      priority: ModelParsing.intOrNull(ModelParsing.value(map, 'priority')) ?? 0,
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());
  factory BranchPrice.fromJson(String source) => BranchPrice.fromMap(json.decode(source) as Map<String, dynamic>);
}
