// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class AccessPage extends AuditedSyncModel {
  String ownerUuid;
  String key;
  String title;
  String routeKey;
  String module;
  String description;
  String icon;

  AccessPage({
    super.id = 0,
    super.uuid,
    this.ownerUuid = '',
    required this.key,
    required this.title,
    this.routeKey = '',
    this.module = '',
    this.description = '',
    this.icon = '',
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  AccessPage copyWith({
    int? id,
    String? uuid,
    String? ownerUuid,
    String? key,
    String? title,
    String? routeKey,
    String? module,
    String? description,
    String? icon,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return AccessPage(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      ownerUuid: ownerUuid ?? this.ownerUuid,
      key: key ?? this.key,
      title: title ?? this.title,
      routeKey: routeKey ?? this.routeKey,
      module: module ?? this.module,
      description: description ?? this.description,
      icon: icon ?? this.icon,
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
      'key': key,
      'title': title,
      'routeKey': routeKey,
      'module': module,
      'description': description,
      'icon': icon,
      ...auditedSyncMap(),
    };
  }

  factory AccessPage.fromMap(Map<String, dynamic> map) {
    return AccessPage(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'ownerUuid')) ?? '',
      key: ModelParsing.stringOrThrow(ModelParsing.value(map, 'key'), 'key'),
      title: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'title'),
        'title',
      ),
      routeKey:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'routeKey')) ?? '',
      module:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'module')) ?? '',
      description:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'description')) ??
          '',
      icon: ModelParsing.stringOrNull(ModelParsing.value(map, 'icon')) ?? '',
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

  factory AccessPage.fromJson(String source) =>
      AccessPage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AccessPage(id: $id, uuid: $uuid, ownerUuid: $ownerUuid, key: $key, title: $title, routeKey: $routeKey, module: $module, description: $description, icon: $icon, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    ownerUuid,
    key,
    title,
    routeKey,
    module,
    description,
    icon,
  ];
}
