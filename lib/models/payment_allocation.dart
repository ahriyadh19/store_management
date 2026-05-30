// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class PaymentAllocation extends AuditedSyncModel {
  String paymentVoucherUuid;
  String invoiceUuid;
  Decimal allocatedAmount;
  DateTime allocationDate;

  PaymentAllocation({
    super.id = 0,
    super.uuid,
    required this.paymentVoucherUuid,
    required this.invoiceUuid,
    required this.allocatedAmount,
    required this.allocationDate,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

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
      'paymentVoucherUuid': paymentVoucherUuid,
      'invoiceUuid': invoiceUuid,
      'allocatedAmount': allocatedAmount.toString(),
      'allocationDate': allocationDate.millisecondsSinceEpoch,
      ...auditedSyncMap(),
    };
  }

  Map<String, dynamic> toErpMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'payment_voucher_uuid': paymentVoucherUuid,
      'invoice_uuid': invoiceUuid,
      'allocated_amount': allocatedAmount.toString(),
      'allocation_date': ModelParsing.dateTimeToIso8601Utc(allocationDate),
      'status': status,
      'created_at': ModelParsing.dateTimeToIso8601Utc(createdAt),
      'updated_at': ModelParsing.dateTimeToIso8601Utc(updatedAt),
      'synced': synced,
      'deleted_at': ModelParsing.dateTimeOrNullToIso8601Utc(deletedAt),
      'synced_at': ModelParsing.dateTimeOrNullToIso8601Utc(syncedAt),
    };
  }

  factory PaymentAllocation.fromMap(Map<String, dynamic> map) {
    return PaymentAllocation(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      paymentVoucherUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'paymentVoucherUuid'), 'paymentVoucherUuid'),
      invoiceUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'invoiceUuid'), 'invoiceUuid'),
      allocatedAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'allocatedAmount'), 'allocatedAmount'),
      allocationDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'allocationDate'), 'allocationDate'),
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt'), 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt'), 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentAllocation.fromJson(String source) => PaymentAllocation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentAllocation(id: $id, uuid: $uuid, paymentVoucherUuid: $paymentVoucherUuid, invoiceUuid: $invoiceUuid, allocatedAmount: $allocatedAmount, allocationDate: $allocationDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[...auditedSyncProps, paymentVoucherUuid, invoiceUuid, allocatedAmount, allocationDate];
}
