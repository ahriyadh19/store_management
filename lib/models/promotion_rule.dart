// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class PromotionRule extends AuditedSyncModel {
  String ownerUuid;
  String name;
  String? branchUuid;
  String? productUuid;
  String discountType;
  Decimal discountValue;
  DateTime startsAt;
  DateTime? endsAt;

  PromotionRule({
    super.id = 0,
    super.uuid,
    required this.ownerUuid,
    required this.name,
    this.branchUuid,
    this.productUuid,
    required this.discountType,
    required this.discountValue,
    required this.startsAt,
    this.endsAt,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    'ownerUuid': ownerUuid,
    'name': name,
    'branchUuid': branchUuid,
    'productUuid': productUuid,
    'discountType': discountType,
    'discountValue': discountValue.toString(),
    'startsAt': startsAt.millisecondsSinceEpoch,
    'endsAt': endsAt?.millisecondsSinceEpoch,
    ...auditedSyncMap(),
  };

  @override
  List<Object?> get props => <Object?>[...auditedSyncProps, ownerUuid, name, branchUuid, productUuid, discountType, discountValue, startsAt, endsAt];

  factory PromotionRule.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return PromotionRule(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      name: ModelParsing.stringOrThrow(ModelParsing.value(map, 'name'), 'name'),
      branchUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'branchUuid')),
      productUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'productUuid')),
      discountType: ModelParsing.stringOrThrow(ModelParsing.value(map, 'discountType'), 'discountType'),
      discountValue: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'discountValue'), 'discountValue'),
      startsAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'startsAt'), 'startsAt'),
      endsAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'endsAt')),
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());
  factory PromotionRule.fromJson(String source) => PromotionRule.fromMap(json.decode(source) as Map<String, dynamic>);
}
