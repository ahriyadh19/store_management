// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';

class StoreFinancialTransaction extends AuditedSyncModel {
  String storeUuid;
  String clientUuid;
  String transactionNumber;
  FinancialTransactionType transactionType;
  FinancialSourceType sourceType;
  String sourceUuid;
  Decimal amount;
  LedgerEntryType entryType;
  String description;
  DateTime transactionDate;

  StoreFinancialTransaction({
    super.id = 0,
    super.uuid,
    required this.storeUuid,
    required this.clientUuid,
    required this.transactionNumber,
    required this.transactionType,
    required this.sourceType,
    required this.sourceUuid,
    required this.amount,
    required this.entryType,
    required this.description,
    required this.transactionDate,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  StoreFinancialTransaction copyWith({
    int? id,
    String? uuid,
    String? storeUuid,
    String? clientUuid,
    String? transactionNumber,
    FinancialTransactionType? transactionType,
    FinancialSourceType? sourceType,
    String? sourceUuid,
    Decimal? amount,
    LedgerEntryType? entryType,
    String? description,
    DateTime? transactionDate,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return StoreFinancialTransaction(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeUuid: storeUuid ?? this.storeUuid,
      clientUuid: clientUuid ?? this.clientUuid,
      transactionNumber: transactionNumber ?? this.transactionNumber,
      transactionType: transactionType ?? this.transactionType,
      sourceType: sourceType ?? this.sourceType,
      sourceUuid: sourceUuid ?? this.sourceUuid,
      amount: amount ?? this.amount,
      entryType: entryType ?? this.entryType,
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
      'transactionNumber': transactionNumber,
      'transactionType': transactionType.value,
      'sourceType': sourceType.value,
      'sourceUuid': sourceUuid,
      'amount': amount.toString(),
      'entryType': entryType.value,
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
      'transaction_number': transactionNumber,
      'transaction_type': transactionType.value,
      'source_type': sourceType.value,
      'source_uuid': sourceUuid,
      'amount': amount.toString(),
      'entry_type': entryType.value,
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

  factory StoreFinancialTransaction.fromMap(Map<String, dynamic> map) {
    return StoreFinancialTransaction(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      storeUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'storeUuid'), 'storeUuid'),
      clientUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'clientUuid'), 'clientUuid'),
      transactionNumber: ModelParsing.stringOrThrow(ModelParsing.value(map, 'transactionNumber'), 'transactionNumber'),
      transactionType: ModelParsing.financialTransactionTypeFromValue(ModelParsing.value(map, 'transactionType'), 'transactionType'),
      sourceType: ModelParsing.financialSourceTypeFromValue(ModelParsing.value(map, 'sourceType'), 'sourceType'),
      sourceUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'sourceUuid'), 'sourceUuid'),
      amount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'amount'), 'amount'),
      entryType: ModelParsing.ledgerEntryTypeFromValue(ModelParsing.value(map, 'entryType'), 'entryType'),
      description: ModelParsing.stringOrThrow(ModelParsing.value(map, 'description'), 'description'),
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

  factory StoreFinancialTransaction.fromJson(String source) => StoreFinancialTransaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreFinancialTransaction(id: $id, uuid: $uuid, storeUuid: $storeUuid, clientUuid: $clientUuid, transactionNumber: $transactionNumber, transactionType: $transactionType, sourceType: $sourceType, sourceUuid: $sourceUuid, amount: $amount, entryType: $entryType, description: $description, transactionDate: $transactionDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[...auditedSyncProps, storeUuid, clientUuid, transactionNumber, transactionType, sourceType, sourceUuid, amount, entryType, description, transactionDate];
}
