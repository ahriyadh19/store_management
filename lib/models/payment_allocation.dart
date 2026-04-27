// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class PaymentAllocation {
  int? id;
  String uuid;
  int paymentVoucherId;
  String paymentVoucherUuid;
  int invoiceId;
  String invoiceUuid;
  Decimal allocatedAmount;
  DateTime allocationDate;
  RecordStatus status;
  DateTime createdAt;
  DateTime updatedAt;

  PaymentAllocation({
    this.id,
    String? uuid,
    required this.paymentVoucherId,
    required this.paymentVoucherUuid,
    required this.invoiceId,
    required this.invoiceUuid,
    required this.allocatedAmount,
    required this.allocationDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  PaymentAllocation copyWith({
    int? id,
    String? uuid,
    int? paymentVoucherId,
    String? paymentVoucherUuid,
    int? invoiceId,
    String? invoiceUuid,
    Decimal? allocatedAmount,
    DateTime? allocationDate,
    RecordStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentAllocation(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      paymentVoucherId: paymentVoucherId ?? this.paymentVoucherId,
      paymentVoucherUuid: paymentVoucherUuid ?? this.paymentVoucherUuid,
      invoiceId: invoiceId ?? this.invoiceId,
      invoiceUuid: invoiceUuid ?? this.invoiceUuid,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      allocationDate: allocationDate ?? this.allocationDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'paymentVoucherId': paymentVoucherId,
      'paymentVoucherUuid': paymentVoucherUuid,
      'invoiceId': invoiceId,
      'invoiceUuid': invoiceUuid,
      'allocatedAmount': allocatedAmount.toString(),
      'allocationDate': allocationDate.millisecondsSinceEpoch,
      'status': status.code,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory PaymentAllocation.fromMap(Map<String, dynamic> map) {
    return PaymentAllocation(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      paymentVoucherId: ModelParsing.intOrThrow(map['paymentVoucherId'], 'paymentVoucherId'),
      paymentVoucherUuid: map['paymentVoucherUuid'] as String,
      invoiceId: ModelParsing.intOrThrow(map['invoiceId'], 'invoiceId'),
      invoiceUuid: map['invoiceUuid'] as String,
      allocatedAmount: ModelParsing.decimalOrThrow(map['allocatedAmount'], 'allocatedAmount'),
      allocationDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['allocationDate'], 'allocationDate'),
      status: ModelParsing.recordStatusFromCode(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentAllocation.fromJson(String source) => PaymentAllocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentAllocation(id: $id, uuid: $uuid, paymentVoucherId: $paymentVoucherId, paymentVoucherUuid: $paymentVoucherUuid, invoiceId: $invoiceId, invoiceUuid: $invoiceUuid, allocatedAmount: $allocatedAmount, allocationDate: $allocationDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant PaymentAllocation other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.paymentVoucherId == paymentVoucherId &&
        other.paymentVoucherUuid == paymentVoucherUuid &&
        other.invoiceId == invoiceId &&
        other.invoiceUuid == invoiceUuid &&
        other.allocatedAmount == allocatedAmount &&
        other.allocationDate == allocationDate &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        paymentVoucherId.hashCode ^
        paymentVoucherUuid.hashCode ^
        invoiceId.hashCode ^
        invoiceUuid.hashCode ^
        allocatedAmount.hashCode ^
        allocationDate.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}