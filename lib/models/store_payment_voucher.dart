// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class StorePaymentVoucher {
  @Id()
  int id = 0;
  String uuid;
  String storeUuid;
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
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  StorePaymentVoucher({
    this.id = 0,
    String? uuid,
    required this.storeUuid,
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
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StorePaymentVoucher copyWith({
    int? id,
    String? uuid,
    String? storeUuid,
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
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return StorePaymentVoucher(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeUuid: storeUuid ?? this.storeUuid,
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
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory StorePaymentVoucher.fromMap(Map<String, dynamic> map) {
    return StorePaymentVoucher(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      storeUuid: ModelParsing.stringOrThrow(map['storeUuid'], 'storeUuid'),
      clientUuid: ModelParsing.stringOrThrow(map['clientUuid'], 'clientUuid'),
      voucherNumber: ModelParsing.stringOrThrow(map['voucherNumber'], 'voucherNumber'),
      payeeName: ModelParsing.stringOrThrow(map['payeeName'], 'payeeName'),
      amount: ModelParsing.decimalOrThrow(map['amount'], 'amount'),
      paymentMethod: ModelParsing.paymentMethodFromValue(map['paymentMethod'], 'paymentMethod'),
      referenceNumber: ModelParsing.stringOrThrow(map['referenceNumber'], 'referenceNumber'),
      description: ModelParsing.stringOrThrow(map['description'], 'description'),
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

  factory StorePaymentVoucher.fromJson(String source) => StorePaymentVoucher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StorePaymentVoucher(id: $id, uuid: $uuid, storeUuid: $storeUuid, clientUuid: $clientUuid, voucherNumber: $voucherNumber, payeeName: $payeeName, amount: $amount, paymentMethod: $paymentMethod, referenceNumber: $referenceNumber, description: $description, transactionDate: $transactionDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant StorePaymentVoucher other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeUuid == storeUuid &&
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
        voucherNumber.hashCode ^
        payeeName.hashCode ^
        amount.hashCode ^
        paymentMethod.hashCode ^
        referenceNumber.hashCode ^
        description.hashCode ^
        transactionDate.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}