// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';

class StoreReturn extends AuditedSyncModel {
  String storeUuid;
  String clientUuid;
  String returnNumber;
  StoreReturnType returnType;
  int itemCount;
  Decimal totalAmount;
  String reason;
  DateTime transactionDate;

  StoreReturn({
    super.id = 0,
    super.uuid,
    required this.storeUuid,
    required this.clientUuid,
    required this.returnNumber,
    required this.returnType,
    required this.itemCount,
    required this.totalAmount,
    required this.reason,
    required this.transactionDate,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  StoreReturn copyWith({
    int? id,
    String? uuid,
    String? storeUuid,
    String? clientUuid,
    String? returnNumber,
    StoreReturnType? returnType,
    int? itemCount,
    Decimal? totalAmount,
    String? reason,
    DateTime? transactionDate,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return StoreReturn(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeUuid: storeUuid ?? this.storeUuid,
      clientUuid: clientUuid ?? this.clientUuid,
      returnNumber: returnNumber ?? this.returnNumber,
      returnType: returnType ?? this.returnType,
      itemCount: itemCount ?? this.itemCount,
      totalAmount: totalAmount ?? this.totalAmount,
      reason: reason ?? this.reason,
      transactionDate: transactionDate ?? this.transactionDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'storeUuid': storeUuid,
      'clientUuid': clientUuid,
      'returnNumber': returnNumber,
      'returnType': returnType.value,
      'itemCount': itemCount,
      'totalAmount': totalAmount.toString(),
      'reason': reason,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      ...auditedSyncMap(),
    };
  }

  Map<String, dynamic> toErpMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'store_uuid': storeUuid,
      'client_uuid': clientUuid,
      'return_number': returnNumber,
      'return_type': returnType.value,
      'item_count': itemCount,
      'total_amount': totalAmount.toString(),
      'reason': reason,
      'transaction_date': ModelParsing.dateTimeToIso8601Utc(transactionDate),
      'status': status,
      'created_at': ModelParsing.dateTimeToIso8601Utc(createdAt),
      'updated_at': ModelParsing.dateTimeToIso8601Utc(updatedAt),
      'synced': synced,
      'deleted_at': ModelParsing.dateTimeOrNullToIso8601Utc(deletedAt),
      'synced_at': ModelParsing.dateTimeOrNullToIso8601Utc(syncedAt),
    };
  }

  factory StoreReturn.fromMap(Map<String, dynamic> map) {
    return StoreReturn(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      storeUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'storeUuid'), 'storeUuid'),
      clientUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'clientUuid'), 'clientUuid'),
      returnNumber: ModelParsing.stringOrThrow(ModelParsing.value(map, 'returnNumber'), 'returnNumber'),
      returnType: ModelParsing.returnTypeFromValue(ModelParsing.value(map, 'returnType'), 'returnType'),
      itemCount: ModelParsing.intOrThrow(ModelParsing.value(map, 'itemCount'), 'itemCount'),
      totalAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'totalAmount'), 'totalAmount'),
      reason: ModelParsing.stringOrThrow(ModelParsing.value(map, 'reason'), 'reason'),
      transactionDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'transactionDate'), 'transactionDate'),
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt'), 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt'), 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreReturn.fromJson(String source) => StoreReturn.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreReturn(id: $id, uuid: $uuid, storeUuid: $storeUuid, clientUuid: $clientUuid, returnNumber: $returnNumber, returnType: $returnType, itemCount: $itemCount, totalAmount: $totalAmount, reason: $reason, transactionDate: $transactionDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[...auditedSyncProps, storeUuid, clientUuid, returnNumber, returnType, itemCount, totalAmount, reason, transactionDate];
}
