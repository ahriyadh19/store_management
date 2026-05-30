// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class AccessPermission extends AuditedSyncModel {
  String ownerUuid;
  String? pageUuid;
  String key;
  String action;
  String description;

  AccessPermission({
    super.id = 0,
    super.uuid,
    this.ownerUuid = '',
    this.pageUuid,
    required this.key,
    this.action = 'view',
    this.description = '',
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  AccessPermission copyWith({
    int? id,
    String? uuid,
    String? ownerUuid,
    String? pageUuid,
    bool clearPageUuid = false,
    String? key,
    String? action,
    String? description,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return AccessPermission(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      ownerUuid: ownerUuid ?? this.ownerUuid,
      pageUuid: clearPageUuid ? null : (pageUuid ?? this.pageUuid),
      key: key ?? this.key,
      action: action ?? this.action,
      description: description ?? this.description,
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
      'ownerUuid': ownerUuid,
      'pageUuid': pageUuid,
      'key': key,
      'action': action,
      'description': description,
      ...auditedSyncMap(),
    };
  }

  factory AccessPermission.fromMap(Map<String, dynamic> map) {
    return AccessPermission(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'ownerUuid')) ?? '',
      pageUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'pageUuid')),
      key: ModelParsing.stringOrThrow(ModelParsing.value(map, 'key'), 'key'),
      action:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'action')) ??
          'view',
      description:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'description')) ??
          '',
      status: ModelParsing.intOrThrow(
        ModelParsing.value(map, 'status'),
        'status',
      ),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'createdAt'),
        'createdAt',
      ),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'updatedAt'),
        'updatedAt',
      ),
      synced:
          ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'deletedAt'),
      ),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'syncedAt'),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AccessPermission.fromJson(String source) =>
      AccessPermission.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AccessPermission(id: $id, uuid: $uuid, ownerUuid: $ownerUuid, pageUuid: $pageUuid, key: $key, action: $action, description: $description, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    ownerUuid,
    pageUuid,
    key,
    action,
    description,
  ];
}
