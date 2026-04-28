// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class StoreReturn {
  int? id;
  String uuid;
  int storeId;
  String storeUuid;
  int clientId;
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

  StoreReturn({
    this.id,
    String? uuid,
    required this.storeId,
    required this.storeUuid,
    required this.clientId,
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
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StoreReturn copyWith({
    int? id,
    String? uuid,
    int? storeId,
    String? storeUuid,
    int? clientId,
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
  }) {
    return StoreReturn(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeId: storeId ?? this.storeId,
      storeUuid: storeUuid ?? this.storeUuid,
      clientId: clientId ?? this.clientId,
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
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'storeId': storeId,
      'storeUuid': storeUuid,
      'clientId': clientId,
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
    };
  }

  factory StoreReturn.fromMap(Map<String, dynamic> map) {
    return StoreReturn(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      storeId: ModelParsing.intOrThrow(map['storeId'], 'storeId'),
      storeUuid: map['storeUuid'] as String,
      clientId: ModelParsing.intOrThrow(map['clientId'], 'clientId'),
      clientUuid: map['clientUuid'] as String,
      returnNumber: map['returnNumber'] as String,
      returnType: ModelParsing.returnTypeFromValue(map['returnType'], 'returnType'),
      itemCount: ModelParsing.intOrThrow(map['itemCount'], 'itemCount'),
      totalAmount: ModelParsing.decimalOrThrow(map['totalAmount'], 'totalAmount'),
      reason: map['reason'] as String,
      transactionDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['transactionDate'], 'transactionDate'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreReturn.fromJson(String source) => StoreReturn.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreReturn(id: $id, uuid: $uuid, storeId: $storeId, storeUuid: $storeUuid, clientId: $clientId, clientUuid: $clientUuid, returnNumber: $returnNumber, returnType: $returnType, itemCount: $itemCount, totalAmount: $totalAmount, reason: $reason, transactionDate: $transactionDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StoreReturn other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeId == storeId &&
        other.storeUuid == storeUuid &&
      other.clientId == clientId &&
      other.clientUuid == clientUuid &&
        other.returnNumber == returnNumber &&
        other.returnType == returnType &&
        other.itemCount == itemCount &&
        other.totalAmount == totalAmount &&
        other.reason == reason &&
        other.transactionDate == transactionDate &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        storeId.hashCode ^
        storeUuid.hashCode ^
      clientId.hashCode ^
      clientUuid.hashCode ^
        returnNumber.hashCode ^
        returnType.hashCode ^
        itemCount.hashCode ^
        totalAmount.hashCode ^
        reason.hashCode ^
        transactionDate.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}