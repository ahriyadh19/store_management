// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class StorePaymentVoucher {
  int? id;
  String uuid;
  int storeId;
  String storeUuid;
  int clientId;
  String clientUuid;
  String voucherNumber;
  String payeeName;
  Decimal amount;
  StorePaymentMethod paymentMethod;
  String referenceNumber;
  String description;
  DateTime transactionDate;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  StorePaymentVoucher({
    this.id,
    String? uuid,
    required this.storeId,
    required this.storeUuid,
    required this.clientId,
    required this.clientUuid,
    required this.voucherNumber,
    required this.payeeName,
    required this.amount,
    required this.paymentMethod,
    required this.referenceNumber,
    required this.description,
    required this.transactionDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StorePaymentVoucher copyWith({
    int? id,
    String? uuid,
    int? storeId,
    String? storeUuid,
    int? clientId,
    String? clientUuid,
    String? voucherNumber,
    String? payeeName,
    Decimal? amount,
    StorePaymentMethod? paymentMethod,
    String? referenceNumber,
    String? description,
    DateTime? transactionDate,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StorePaymentVoucher(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeId: storeId ?? this.storeId,
      storeUuid: storeUuid ?? this.storeUuid,
      clientId: clientId ?? this.clientId,
      clientUuid: clientUuid ?? this.clientUuid,
      voucherNumber: voucherNumber ?? this.voucherNumber,
      payeeName: payeeName ?? this.payeeName,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      description: description ?? this.description,
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
      'voucherNumber': voucherNumber,
      'payeeName': payeeName,
      'amount': amount.toString(),
      'paymentMethod': paymentMethod.value,
      'referenceNumber': referenceNumber,
      'description': description,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory StorePaymentVoucher.fromMap(Map<String, dynamic> map) {
    return StorePaymentVoucher(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      storeId: ModelParsing.intOrThrow(map['storeId'], 'storeId'),
      storeUuid: map['storeUuid'] as String,
      clientId: ModelParsing.intOrThrow(map['clientId'], 'clientId'),
      clientUuid: map['clientUuid'] as String,
      voucherNumber: map['voucherNumber'] as String,
      payeeName: map['payeeName'] as String,
      amount: ModelParsing.decimalOrThrow(map['amount'], 'amount'),
      paymentMethod: ModelParsing.paymentMethodFromValue(map['paymentMethod'], 'paymentMethod'),
      referenceNumber: map['referenceNumber'] as String,
      description: map['description'] as String,
      transactionDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['transactionDate'], 'transactionDate'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory StorePaymentVoucher.fromJson(String source) => StorePaymentVoucher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StorePaymentVoucher(id: $id, uuid: $uuid, storeId: $storeId, storeUuid: $storeUuid, clientId: $clientId, clientUuid: $clientUuid, voucherNumber: $voucherNumber, payeeName: $payeeName, amount: $amount, paymentMethod: $paymentMethod, referenceNumber: $referenceNumber, description: $description, transactionDate: $transactionDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StorePaymentVoucher other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeId == storeId &&
        other.storeUuid == storeUuid &&
      other.clientId == clientId &&
      other.clientUuid == clientUuid &&
        other.voucherNumber == voucherNumber &&
        other.payeeName == payeeName &&
        other.amount == amount &&
        other.paymentMethod == paymentMethod &&
        other.referenceNumber == referenceNumber &&
        other.description == description &&
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
        voucherNumber.hashCode ^
        payeeName.hashCode ^
        amount.hashCode ^
        paymentMethod.hashCode ^
        referenceNumber.hashCode ^
        description.hashCode ^
        transactionDate.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}