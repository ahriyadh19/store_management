// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/uuid.dart';

class StoreInvoice {
  int? id;
  String uuid;
  String storeUuid;
  String clientUuid;
  String invoiceNumber;
  StoreInvoiceType invoiceType;
  int itemCount;
  Decimal totalAmount;
  Decimal paidAmount;
  Decimal balanceAmount;
  String notes;
  DateTime issuedAt;
  DateTime dueAt;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  StoreInvoice({
    this.id,
    String? uuid,
    required this.storeUuid,
    required this.clientUuid,
    required this.invoiceNumber,
    required this.invoiceType,
    required this.itemCount,
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
    String? storeUuid,
    String? clientUuid,
    String? invoiceNumber,
    StoreInvoiceType? invoiceType,
    int? itemCount,
    Decimal? totalAmount,
    Decimal? paidAmount,
    Decimal? balanceAmount,
    String? notes,
    DateTime? issuedAt,
    DateTime? dueAt,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreInvoice(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeUuid: storeUuid ?? this.storeUuid,
      clientUuid: clientUuid ?? this.clientUuid,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceType: invoiceType ?? this.invoiceType,
      itemCount: itemCount ?? this.itemCount,
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
      'storeUuid': storeUuid,
      'clientUuid': clientUuid,
      'invoiceNumber': invoiceNumber,
      'invoiceType': invoiceType.value,
      'itemCount': itemCount,
      'totalAmount': totalAmount.toString(),
      'paidAmount': paidAmount.toString(),
      'balanceAmount': balanceAmount.toString(),
      'notes': notes,
      'issuedAt': issuedAt.millisecondsSinceEpoch,
      'dueAt': dueAt.millisecondsSinceEpoch,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory StoreInvoice.fromMap(Map<String, dynamic> map) {
    return StoreInvoice(
      id: ModelParsing.intOrNull(map['id']),
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      storeUuid: ModelParsing.stringOrThrow(map['storeUuid'], 'storeUuid'),
      clientUuid: ModelParsing.stringOrThrow(map['clientUuid'], 'clientUuid'),
      invoiceNumber: ModelParsing.stringOrThrow(map['invoiceNumber'], 'invoiceNumber'),
      invoiceType: ModelParsing.invoiceTypeFromValue(map['invoiceType'], 'invoiceType'),
      itemCount: ModelParsing.intOrThrow(map['itemCount'], 'itemCount'),
      totalAmount: ModelParsing.decimalOrThrow(map['totalAmount'], 'totalAmount'),
      paidAmount: ModelParsing.decimalOrThrow(map['paidAmount'], 'paidAmount'),
      balanceAmount: ModelParsing.decimalOrThrow(map['balanceAmount'], 'balanceAmount'),
      notes: ModelParsing.stringOrThrow(map['notes'], 'notes'),
      issuedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['issuedAt'], 'issuedAt'),
      dueAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['dueAt'], 'dueAt'),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreInvoice.fromJson(String source) => StoreInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreInvoice(id: $id, uuid: $uuid, storeUuid: $storeUuid, clientUuid: $clientUuid, invoiceNumber: $invoiceNumber, invoiceType: $invoiceType, itemCount: $itemCount, totalAmount: $totalAmount, paidAmount: $paidAmount, balanceAmount: $balanceAmount, notes: $notes, issuedAt: $issuedAt, dueAt: $dueAt, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StoreInvoice other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeUuid == storeUuid &&
      other.clientUuid == clientUuid &&
        other.invoiceNumber == invoiceNumber &&
        other.invoiceType == invoiceType &&
        other.itemCount == itemCount &&
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
        storeUuid.hashCode ^
      clientUuid.hashCode ^
        invoiceNumber.hashCode ^
        invoiceType.hashCode ^
        itemCount.hashCode ^
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