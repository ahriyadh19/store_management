// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class StoreFinancialTransaction {
  int? id;
  String uuid;
  int storeId;
  String storeUuid;
  int clientId;
  String clientUuid;
  String transactionNumber;
  String transactionType;
  String sourceType;
  int sourceId;
  String sourceUuid;
  double amount;
  String entryType;
  String description;
  DateTime transactionDate;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  StoreFinancialTransaction({
    this.id,
    String? uuid,
    required this.storeId,
    required this.storeUuid,
    required this.clientId,
    required this.clientUuid,
    required this.transactionNumber,
    required this.transactionType,
    required this.sourceType,
    required this.sourceId,
    required this.sourceUuid,
    required this.amount,
    required this.entryType,
    required this.description,
    required this.transactionDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StoreFinancialTransaction copyWith({
    int? id,
    String? uuid,
    int? storeId,
    String? storeUuid,
    int? clientId,
    String? clientUuid,
    String? transactionNumber,
    String? transactionType,
    String? sourceType,
    int? sourceId,
    String? sourceUuid,
    double? amount,
    String? entryType,
    String? description,
    DateTime? transactionDate,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreFinancialTransaction(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeId: storeId ?? this.storeId,
      storeUuid: storeUuid ?? this.storeUuid,
      clientId: clientId ?? this.clientId,
      clientUuid: clientUuid ?? this.clientUuid,
      transactionNumber: transactionNumber ?? this.transactionNumber,
      transactionType: transactionType ?? this.transactionType,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      sourceUuid: sourceUuid ?? this.sourceUuid,
      amount: amount ?? this.amount,
      entryType: entryType ?? this.entryType,
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
      'transactionNumber': transactionNumber,
      'transactionType': transactionType,
      'sourceType': sourceType,
      'sourceId': sourceId,
      'sourceUuid': sourceUuid,
      'amount': amount,
      'entryType': entryType,
      'description': description,
      'transactionDate': transactionDate.millisecondsSinceEpoch,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory StoreFinancialTransaction.fromMap(Map<String, dynamic> map) {
    return StoreFinancialTransaction(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      storeId: ModelParsing.intOrThrow(map['storeId'], 'storeId'),
      storeUuid: map['storeUuid'] as String,
      clientId: ModelParsing.intOrThrow(map['clientId'], 'clientId'),
      clientUuid: map['clientUuid'] as String,
      transactionNumber: map['transactionNumber'] as String,
      transactionType: map['transactionType'] as String,
      sourceType: map['sourceType'] as String,
      sourceId: ModelParsing.intOrThrow(map['sourceId'], 'sourceId'),
      sourceUuid: map['sourceUuid'] as String,
      amount: ModelParsing.doubleOrThrow(map['amount'], 'amount'),
      entryType: map['entryType'] as String,
      description: map['description'] as String,
      transactionDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['transactionDate'], 'transactionDate'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreFinancialTransaction.fromJson(String source) => StoreFinancialTransaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreFinancialTransaction(id: $id, uuid: $uuid, storeId: $storeId, storeUuid: $storeUuid, clientId: $clientId, clientUuid: $clientUuid, transactionNumber: $transactionNumber, transactionType: $transactionType, sourceType: $sourceType, sourceId: $sourceId, sourceUuid: $sourceUuid, amount: $amount, entryType: $entryType, description: $description, transactionDate: $transactionDate, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StoreFinancialTransaction other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeId == storeId &&
        other.storeUuid == storeUuid &&
      other.clientId == clientId &&
      other.clientUuid == clientUuid &&
        other.transactionNumber == transactionNumber &&
        other.transactionType == transactionType &&
        other.sourceType == sourceType &&
        other.sourceId == sourceId &&
        other.sourceUuid == sourceUuid &&
        other.amount == amount &&
        other.entryType == entryType &&
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
        transactionNumber.hashCode ^
        transactionType.hashCode ^
        sourceType.hashCode ^
        sourceId.hashCode ^
        sourceUuid.hashCode ^
        amount.hashCode ^
        entryType.hashCode ^
        description.hashCode ^
        transactionDate.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}