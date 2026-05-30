// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class StaffAttendance extends StatusedModel<String> {
  String ownerUuid;
  String staffShiftUuid;
  DateTime? checkInAt;
  DateTime? checkOutAt;
  int? minutesWorked;

  StaffAttendance({
    super.id = 0,
    super.uuid,
    required this.ownerUuid,
    required this.staffShiftUuid,
    this.checkInAt,
    this.checkOutAt,
    this.minutesWorked,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    'ownerUuid': ownerUuid,
    'staffShiftUuid': staffShiftUuid,
    'checkInAt': checkInAt?.millisecondsSinceEpoch,
    'checkOutAt': checkOutAt?.millisecondsSinceEpoch,
    'minutesWorked': minutesWorked,
    ...statusedMap(),
  };

  @override
  List<Object?> get props => <Object?>[...statusedProps, ownerUuid, staffShiftUuid, checkInAt, checkOutAt, minutesWorked];

  factory StaffAttendance.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    return StaffAttendance(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      staffShiftUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'staffShiftUuid'), 'staffShiftUuid'),
      checkInAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'checkInAt')),
      checkOutAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'checkOutAt')),
      minutesWorked: ModelParsing.intOrNull(ModelParsing.value(map, 'minutesWorked')),
      status: ModelParsing.stringOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
    );
  }

  String toJson() => json.encode(toMap());
  factory StaffAttendance.fromJson(String source) => StaffAttendance.fromMap(json.decode(source) as Map<String, dynamic>);
}
