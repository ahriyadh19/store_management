// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class StoreReturn {
  @Id()
  int id = 0;
  String uuid;
  String storeUuid;
  String clientUuid;
  String returnNumber;
  StoreReturnType returnType;
  int itemCount;
  Decimal totalAmount;
  String reason;
  DateTime transactionDate;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  StoreReturn({
    this.id = 0,
    String? uuid,
    required this.storeUuid,
    required this.clientUuid,
    required this.returnNumber,
    required this.returnType,
    required this.itemCount,
    required this.totalAmount,
    required this.reason,
    required this.transactionDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

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
      'id': id,
      'uuid': uuid,
      'storeUuid': storeUuid,
      'clientUuid': clientUuid,
      'returnNumber': returnNumber,
      'returnType': returnType.value,
      'itemCount': itemCount,
      'totalAmount': totalAmount.toString(),
      'reason': reason,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory StoreReturn.fromMap(Map<String, dynamic> map) {
    return StoreReturn(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      storeUuid: ModelParsing.stringOrThrow(map['storeUuid'], 'storeUuid'),
      clientUuid: ModelParsing.stringOrThrow(map['clientUuid'], 'clientUuid'),
      returnNumber: ModelParsing.stringOrThrow(map['returnNumber'], 'returnNumber'),
      returnType: ModelParsing.returnTypeFromValue(map['returnType'], 'returnType'),
      itemCount: ModelParsing.intOrThrow(map['itemCount'], 'itemCount'),
      totalAmount: ModelParsing.decimalOrThrow(map['totalAmount'], 'totalAmount'),
      reason: ModelParsing.stringOrThrow(map['reason'], 'reason'),
      transactionDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['transactionDate'], 'transactionDate'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'] ?? map['created_at'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'] ?? map['updated_at'], 'updatedAt'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreReturn.fromJson(String source) => StoreReturn.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreReturn(id: $id, uuid: $uuid, storeUuid: $storeUuid, clientUuid: $clientUuid, returnNumber: $returnNumber, returnType: $returnType, itemCount: $itemCount, totalAmount: $totalAmount, reason: $reason, transactionDate: $transactionDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant StoreReturn other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeUuid == storeUuid &&
      other.clientUuid == clientUuid &&
        other.returnNumber == returnNumber &&
        other.returnType == returnType &&
        other.itemCount == itemCount &&
        other.totalAmount == totalAmount &&
        other.reason == reason &&
        other.transactionDate == transactionDate &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.synced == synced &&
        other.deletedAt == deletedAt &&
        other.syncedAt == syncedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        storeUuid.hashCode ^
      clientUuid.hashCode ^
        returnNumber.hashCode ^
        returnType.hashCode ^
        itemCount.hashCode ^
        totalAmount.hashCode ^
        reason.hashCode ^
        transactionDate.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}