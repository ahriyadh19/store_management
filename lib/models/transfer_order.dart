// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class TransferOrder {
  @Id()
  int id = 0;
  String uuid;
  String ownerUuid;
  String sourceBranchUuid;
  String destinationBranchUuid;
  String transferNumber;
  String status;
  DateTime requestedAt;
  DateTime? shippedAt;
  DateTime? receivedAt;
  String? createdByUserUuid;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  TransferOrder({
    this.id = 0,
    String? uuid,
    required this.ownerUuid,
    required this.sourceBranchUuid,
    required this.destinationBranchUuid,
    required this.transferNumber,
    required this.status,
    required this.requestedAt,
    this.shippedAt,
    this.receivedAt,
    this.createdByUserUuid,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'uuid': uuid,
    'ownerUuid': ownerUuid,
    'sourceBranchUuid': sourceBranchUuid,
    'destinationBranchUuid': destinationBranchUuid,
    'transferNumber': transferNumber,
    'status': status,
    'requestedAt': requestedAt.millisecondsSinceEpoch,
    'shippedAt': shippedAt?.millisecondsSinceEpoch,
    'receivedAt': receivedAt?.millisecondsSinceEpoch,
    'createdByUserUuid': createdByUserUuid,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
    'synced': synced,
    'deletedAt': deletedAt?.millisecondsSinceEpoch,
    'syncedAt': syncedAt?.millisecondsSinceEpoch,
  };

  factory TransferOrder.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return TransferOrder(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      sourceBranchUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'sourceBranchUuid'), 'sourceBranchUuid'),
      destinationBranchUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'destinationBranchUuid'), 'destinationBranchUuid'),
      transferNumber: ModelParsing.stringOrThrow(ModelParsing.value(map, 'transferNumber'), 'transferNumber'),
      status: ModelParsing.stringOrThrow(ModelParsing.value(map, 'status'), 'status'),
      requestedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'requestedAt'), 'requestedAt'),
      shippedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'shippedAt')),
      receivedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'receivedAt')),
      createdByUserUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'createdByUserUuid')),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());
  factory TransferOrder.fromJson(String source) => TransferOrder.fromMap(json.decode(source) as Map<String, dynamic>);
}
