// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class StoreInvoice {
  int? id;
  String uuid;
  int storeId;
  String storeUuid;
  int clientId;
  String clientUuid;
  String invoiceNumber;
  Decimal totalAmount;
  Decimal paidAmount;
  Decimal balanceAmount;
  String notes;
  DateTime issuedAt;
  DateTime dueAt;
  RecordStatus status;
  DateTime createdAt;
  DateTime updatedAt;

  StoreInvoice({
    this.id,
    String? uuid,
    required this.storeId,
    required this.storeUuid,
    required this.clientId,
    required this.clientUuid,
    required this.invoiceNumber,
    required this.totalAmount,
    required this.paidAmount,
    required this.balanceAmount,
    required this.notes,
    required this.issuedAt,
    required this.dueAt,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  StoreInvoice copyWith({
    int? id,
    String? uuid,
    int? storeId,
    String? storeUuid,
    int? clientId,
    String? clientUuid,
    String? invoiceNumber,
    Decimal? totalAmount,
    Decimal? paidAmount,
    Decimal? balanceAmount,
    String? notes,
    DateTime? issuedAt,
    DateTime? dueAt,
    RecordStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreInvoice(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeId: storeId ?? this.storeId,
      storeUuid: storeUuid ?? this.storeUuid,
      clientId: clientId ?? this.clientId,
      clientUuid: clientUuid ?? this.clientUuid,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      notes: notes ?? this.notes,
      issuedAt: issuedAt ?? this.issuedAt,
      dueAt: dueAt ?? this.dueAt,
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
      'invoiceNumber': invoiceNumber,
      'totalAmount': totalAmount.toString(),
      'paidAmount': paidAmount.toString(),
      'balanceAmount': balanceAmount.toString(),
      'notes': notes,
      'issuedAt': issuedAt.millisecondsSinceEpoch,
      'dueAt': dueAt.millisecondsSinceEpoch,
      'status': status.code,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory StoreInvoice.fromMap(Map<String, dynamic> map) {
    return StoreInvoice(
      id: ModelParsing.intOrNull(map['id']),
      uuid: map['uuid'] as String,
      storeId: ModelParsing.intOrThrow(map['storeId'], 'storeId'),
      storeUuid: map['storeUuid'] as String,
      clientId: ModelParsing.intOrThrow(map['clientId'], 'clientId'),
      clientUuid: map['clientUuid'] as String,
      invoiceNumber: map['invoiceNumber'] as String,
      totalAmount: ModelParsing.decimalOrThrow(map['totalAmount'], 'totalAmount'),
      paidAmount: ModelParsing.decimalOrThrow(map['paidAmount'], 'paidAmount'),
      balanceAmount: ModelParsing.decimalOrThrow(map['balanceAmount'], 'balanceAmount'),
      notes: map['notes'] as String,
      issuedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['issuedAt'], 'issuedAt'),
      dueAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['dueAt'], 'dueAt'),
      status: ModelParsing.recordStatusFromCode(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreInvoice.fromJson(String source) => StoreInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreInvoice(id: $id, uuid: $uuid, storeId: $storeId, storeUuid: $storeUuid, clientId: $clientId, clientUuid: $clientUuid, invoiceNumber: $invoiceNumber, totalAmount: $totalAmount, paidAmount: $paidAmount, balanceAmount: $balanceAmount, notes: $notes, issuedAt: $issuedAt, dueAt: $dueAt, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StoreInvoice other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeId == storeId &&
        other.storeUuid == storeUuid &&
      other.clientId == clientId &&
      other.clientUuid == clientUuid &&
        other.invoiceNumber == invoiceNumber &&
        other.totalAmount == totalAmount &&
        other.paidAmount == paidAmount &&
        other.balanceAmount == balanceAmount &&
        other.notes == notes &&
        other.issuedAt == issuedAt &&
        other.dueAt == dueAt &&
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
        invoiceNumber.hashCode ^
        totalAmount.hashCode ^
        paidAmount.hashCode ^
        balanceAmount.hashCode ^
        notes.hashCode ^
        issuedAt.hashCode ^
        dueAt.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}