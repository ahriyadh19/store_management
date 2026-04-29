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
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentAllocation.fromJson(String source) => PaymentAllocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentAllocation(id: $id, uuid: $uuid, paymentVoucherUuid: $paymentVoucherUuid, invoiceUuid: $invoiceUuid, allocatedAmount: $allocatedAmount, allocationDate: $allocationDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
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
        other.updatedAt == updatedAt;
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
        updatedAt.hashCode;
  }
}