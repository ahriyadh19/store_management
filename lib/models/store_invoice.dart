// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class StoreInvoice {
  @Id()
  int id = 0;
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
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  StoreInvoice({
    this.id = 0,
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
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
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
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
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
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  Map<String, dynamic> toErpMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'store_uuid': storeUuid,
      'client_uuid': clientUuid,
      'invoice_number': invoiceNumber,
      'invoice_type': invoiceType.value,
      'item_count': itemCount,
      'total_amount': totalAmount.toString(),
      'paid_amount': paidAmount.toString(),
      'balance_amount': balanceAmount.toString(),
      'notes': notes,
      'issued_at': ModelParsing.dateTimeToIso8601Utc(issuedAt),
      'due_at': ModelParsing.dateTimeToIso8601Utc(dueAt),
      'status': status,
      'created_at': ModelParsing.dateTimeToIso8601Utc(createdAt),
      'updated_at': ModelParsing.dateTimeToIso8601Utc(updatedAt),
      'synced': synced,
      'deleted_at': ModelParsing.dateTimeOrNullToIso8601Utc(deletedAt),
      'synced_at': ModelParsing.dateTimeOrNullToIso8601Utc(syncedAt),
    };
  }

  factory StoreInvoice.fromMap(Map<String, dynamic> map) {
    return StoreInvoice(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      storeUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'storeUuid'), 'storeUuid'),
      clientUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'clientUuid'), 'clientUuid'),
      invoiceNumber: ModelParsing.stringOrThrow(ModelParsing.value(map, 'invoiceNumber'), 'invoiceNumber'),
      invoiceType: ModelParsing.invoiceTypeFromValue(ModelParsing.value(map, 'invoiceType'), 'invoiceType'),
      itemCount: ModelParsing.intOrThrow(ModelParsing.value(map, 'itemCount'), 'itemCount'),
      totalAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'totalAmount'), 'totalAmount'),
      paidAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'paidAmount'), 'paidAmount'),
      balanceAmount: ModelParsing.decimalOrThrow(ModelParsing.value(map, 'balanceAmount'), 'balanceAmount'),
      notes: ModelParsing.stringOrThrow(ModelParsing.value(map, 'notes'), 'notes'),
      issuedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'issuedAt'), 'issuedAt'),
      dueAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'dueAt'), 'dueAt'),
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt'), 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt'), 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreInvoice.fromJson(String source) => StoreInvoice.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreInvoice(id: $id, uuid: $uuid, storeUuid: $storeUuid, clientUuid: $clientUuid, invoiceNumber: $invoiceNumber, invoiceType: $invoiceType, itemCount: $itemCount, totalAmount: $totalAmount, paidAmount: $paidAmount, balanceAmount: $balanceAmount, notes: $notes, issuedAt: $issuedAt, dueAt: $dueAt, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
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
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}
