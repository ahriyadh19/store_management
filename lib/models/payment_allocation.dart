// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class PaymentAllocation {
  @Id()
  int id = 0;
  String uuid;
  String paymentVoucherUuid;
  String invoiceUuid;
  Decimal allocatedAmount;
  DateTime allocationDate;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  PaymentAllocation({
    this.id = 0,
    String? uuid,
    required this.paymentVoucherUuid,
    required this.invoiceUuid,
    required this.allocatedAmount,
    required this.allocationDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  PaymentAllocation copyWith({
    int? id,
    String? uuid,
    String? paymentVoucherUuid,
    String? invoiceUuid,
    Decimal? allocatedAmount,
    DateTime? allocationDate,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return PaymentAllocation(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      paymentVoucherUuid: paymentVoucherUuid ?? this.paymentVoucherUuid,
      invoiceUuid: invoiceUuid ?? this.invoiceUuid,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      allocationDate: allocationDate ?? this.allocationDate,
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
      'paymentVoucherUuid': paymentVoucherUuid,
      'invoiceUuid': invoiceUuid,
      'allocatedAmount': allocatedAmount.toString(),
      'allocationDate': allocationDate.millisecondsSinceEpoch,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory PaymentAllocation.fromMap(Map<String, dynamic> map) {
    return PaymentAllocation(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      paymentVoucherUuid: ModelParsing.stringOrThrow(map['paymentVoucherUuid'], 'paymentVoucherUuid'),
      invoiceUuid: ModelParsing.stringOrThrow(map['invoiceUuid'], 'invoiceUuid'),
      allocatedAmount: ModelParsing.decimalOrThrow(map['allocatedAmount'], 'allocatedAmount'),
      allocationDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['allocationDate'], 'allocationDate'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentAllocation.fromJson(String source) => PaymentAllocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentAllocation(id: $id, uuid: $uuid, paymentVoucherUuid: $paymentVoucherUuid, invoiceUuid: $invoiceUuid, allocatedAmount: $allocatedAmount, allocationDate: $allocationDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant PaymentAllocation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.paymentVoucherUuid == paymentVoucherUuid &&
        other.invoiceUuid == invoiceUuid &&
        other.allocatedAmount == allocatedAmount &&
        other.allocationDate == allocationDate &&
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
        paymentVoucherUuid.hashCode ^
        invoiceUuid.hashCode ^
        allocatedAmount.hashCode ^
        allocationDate.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}