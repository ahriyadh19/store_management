// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';

class StorePaymentVoucher extends AuditedSyncModel {
  String storeUuid;
  String clientUuid;
  String voucherNumber;
  String payeeName;
  Decimal amount;
  StorePaymentMethod paymentMethod;
  String referenceNumber;
  String description;
  DateTime transactionDate;

  StorePaymentVoucher({
    super.id = 0,
    super.uuid,
    required this.storeUuid,
    required this.clientUuid,
    required this.voucherNumber,
    required this.payeeName,
    required this.amount,
    required this.paymentMethod,
    required this.referenceNumber,
    required this.description,
    required this.transactionDate,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

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
      'storeUuid': storeUuid,
      'clientUuid': clientUuid,
      'voucherNumber': voucherNumber,
      'payeeName': payeeName,
      'amount': amount.toString(),
      'paymentMethod': paymentMethod.value,
      'referenceNumber': referenceNumber,
      'description': description,
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
      'voucher_number': voucherNumber,
      'payee_name': payeeName,
      'amount': amount.toString(),
      'payment_method': paymentMethod.value,
      'reference_number': referenceNumber,
      'description': description,
      'transaction_date': ModelParsing.dateTimeToIso8601Utc(transactionDate),
      'status': status,
      'created_at': ModelParsing.dateTimeToIso8601Utc(createdAt),
      'updated_at': ModelParsing.dateTimeToIso8601Utc(updatedAt),
      'synced': synced,
      'deleted_at': ModelParsing.dateTimeOrNullToIso8601Utc(deletedAt),
      'synced_at': ModelParsing.dateTimeOrNullToIso8601Utc(syncedAt),
    };
  }

  factory StorePaymentVoucher.fromMap(Map<String, dynamic> map) {
    return StorePaymentVoucher(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      storeUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'storeUuid'),
        'storeUuid',
      ),
      clientUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'clientUuid'),
        'clientUuid',
      ),
      voucherNumber: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'voucherNumber'),
        'voucherNumber',
      ),
      payeeName: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'payeeName'),
        'payeeName',
      ),
      amount: ModelParsing.decimalOrThrow(
        ModelParsing.value(map, 'amount'),
        'amount',
      ),
      paymentMethod: ModelParsing.paymentMethodFromValue(
        ModelParsing.value(map, 'paymentMethod'),
        'paymentMethod',
      ),
      referenceNumber: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'referenceNumber'),
        'referenceNumber',
      ),
      description: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'description'),
        'description',
      ),
      transactionDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'transactionDate'),
        'transactionDate',
      ),
      status: ModelParsing.intOrThrow(
        ModelParsing.value(map, 'status'),
        'status',
      ),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'createdAt'),
        'createdAt',
      ),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'updatedAt'),
        'updatedAt',
      ),
      synced:
          ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'deletedAt'),
      ),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'syncedAt'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StorePaymentVoucher.fromJson(String source) =>
      StorePaymentVoucher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StorePaymentVoucher(id: $id, uuid: $uuid, storeUuid: $storeUuid, clientUuid: $clientUuid, voucherNumber: $voucherNumber, payeeName: $payeeName, amount: $amount, paymentMethod: $paymentMethod, referenceNumber: $referenceNumber, description: $description, transactionDate: $transactionDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    storeUuid,
    clientUuid,
    voucherNumber,
    payeeName,
    amount,
    paymentMethod,
    referenceNumber,
    description,
    transactionDate,
  ];
}
