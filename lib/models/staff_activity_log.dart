// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class StaffActivityLog {
  @Id()
  int id = 0;
  String uuid;
  String ownerUuid;
  String? branchUuid;
  String? userUuid;
  String action;
  String entityType;
  String? entityUuid;
  Map<String, dynamic> metadataJson;
  DateTime createdAt;

  StaffActivityLog({
    this.id = 0,
    String? uuid,
    required this.ownerUuid,
    this.branchUuid,
    this.userUuid,
    required this.action,
    required this.entityType,
    this.entityUuid,
    required this.metadataJson,
    required this.createdAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'uuid': uuid,
    'ownerUuid': ownerUuid,
    'branchUuid': branchUuid,
    'userUuid': userUuid,
    'action': action,
    'entityType': entityType,
    'entityUuid': entityUuid,
    'metadataJson': metadataJson,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };

  factory StaffActivityLog.fromMap(Map<String, dynamic> map) {
    final nowMillis = DateTime.now().millisecondsSinceEpoch;
    final metadataValue = ModelParsing.value(map, 'metadataJson');
    final metadata = metadataValue is Map ? Map<String, dynamic>.from(metadataValue) : <String, dynamic>{};

    return StaffActivityLog(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'ownerUuid'), 'ownerUuid'),
      branchUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'branchUuid')),
      userUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'userUuid')),
      action: ModelParsing.stringOrThrow(ModelParsing.value(map, 'action'), 'action'),
      entityType: ModelParsing.stringOrThrow(ModelParsing.value(map, 'entityType'), 'entityType'),
      entityUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'entityUuid')),
      metadataJson: metadata,
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
    );
  }

  String toJson() => json.encode(toMap());
  factory StaffActivityLog.fromJson(String source) => StaffActivityLog.fromMap(json.decode(source) as Map<String, dynamic>);
}
