// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class StaffShift extends StatusedSyncModel<String> {
  String ownerUuid;
  String branchUuid;
  String userUuid;
  DateTime shiftDate;
  DateTime startAt;
  DateTime? endAt;

  StaffShift({
    super.id = 0,
    super.uuid,
    required this.ownerUuid,
    required this.branchUuid,
    required this.userUuid,
    required this.shiftDate,
    required this.startAt,
    this.endAt,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    'ownerUuid': ownerUuid,
    'branchUuid': branchUuid,
    'userUuid': userUuid,
    'shiftDate': shiftDate.millisecondsSinceEpoch,
    'startAt': startAt.millisecondsSinceEpoch,
    'endAt': endAt?.millisecondsSinceEpoch,
    ...statusedSyncMap(),
  };

  @override
  List<Object?> get props => <Object?>[...statusedSyncProps, ownerUuid, branchUuid, userUuid, shiftDate, startAt, endAt];

  factory StaffShift.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return StaffShift(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      branchUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'branchUuid'), 'branchUuid'),
      userUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'userUuid'), 'userUuid'),
      shiftDate: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'shiftDate'), 'shiftDate'),
      startAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'startAt'), 'startAt'),
      endAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'endAt')),
      status: ModelParsing.stringOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());
  factory StaffShift.fromJson(String source) => StaffShift.fromMap(json.decode(source) as Map<String, dynamic>);
}
