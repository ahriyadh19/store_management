// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class StoreFinancialTransaction {
  @Id()
  int id = 0;
  String uuid;
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
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  StoreFinancialTransaction({
    this.id = 0,
    String? uuid,
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
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

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
      'id': id,
      'uuid': uuid,
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
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory StoreFinancialTransaction.fromMap(Map<String, dynamic> map) {
    return StoreFinancialTransaction(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      storeUuid: ModelParsing.stringOrThrow(map['storeUuid'], 'storeUuid'),
      clientUuid: ModelParsing.stringOrThrow(map['clientUuid'], 'clientUuid'),
      transactionNumber: ModelParsing.stringOrThrow(map['transactionNumber'], 'transactionNumber'),
      transactionType: ModelParsing.financialTransactionTypeFromValue(map['transactionType'], 'transactionType'),
      sourceType: ModelParsing.financialSourceTypeFromValue(map['sourceType'], 'sourceType'),
      sourceUuid: ModelParsing.stringOrThrow(map['sourceUuid'], 'sourceUuid'),
      amount: ModelParsing.decimalOrThrow(map['amount'], 'amount'),
      entryType: ModelParsing.ledgerEntryTypeFromValue(map['entryType'], 'entryType'),
      description: ModelParsing.stringOrThrow(map['description'], 'description'),
      transactionDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['transactionDate'], 'transactionDate'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
      synced: ModelParsing.boolOrNull(map['synced']) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreFinancialTransaction.fromJson(String source) => StoreFinancialTransaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreFinancialTransaction(id: $id, uuid: $uuid, storeUuid: $storeUuid, clientUuid: $clientUuid, transactionNumber: $transactionNumber, transactionType: $transactionType, sourceType: $sourceType, sourceUuid: $sourceUuid, amount: $amount, entryType: $entryType, description: $description, transactionDate: $transactionDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant StoreFinancialTransaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeUuid == storeUuid &&
      other.clientUuid == clientUuid &&
        other.transactionNumber == transactionNumber &&
        other.transactionType == transactionType &&
        other.sourceType == sourceType &&
        other.sourceUuid == sourceUuid &&
        other.amount == amount &&
        other.entryType == entryType &&
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
        transactionNumber.hashCode ^
        transactionType.hashCode ^
        sourceType.hashCode ^
        sourceUuid.hashCode ^
        amount.hashCode ^
        entryType.hashCode ^
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