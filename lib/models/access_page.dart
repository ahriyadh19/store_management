// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox_compat.dart';
import 'package:store_management/services/uuid.dart';

class AccessPage {
  @Id()
  int id = 0;
  String uuid;
  String ownerUuid;
  String key;
  String title;
  String routeKey;
  String module;
  String description;
  String icon;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  AccessPage({
    this.id = 0,
    String? uuid,
    this.ownerUuid = '',
    required this.key,
    required this.title,
    this.routeKey = '',
    this.module = '',
    this.description = '',
    this.icon = '',
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  }) : uuid = uuid ?? UUIDGenerator.generate();

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
      'id': id,
      'uuid': uuid,
      'ownerUuid': ownerUuid,
      'key': key,
      'title': title,
      'routeKey': routeKey,
      'module': module,
      'description': description,
      'icon': icon,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
    };
  }

  factory AccessPage.fromMap(Map<String, dynamic> map) {
    return AccessPage(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid: ModelParsing.stringOrNull(ModelParsing.value(map, 'ownerUuid')) ?? '',
      key: ModelParsing.stringOrThrow(ModelParsing.value(map, 'key'), 'key'),
      title: ModelParsing.stringOrThrow(ModelParsing.value(map, 'title'), 'title'),
      routeKey: ModelParsing.stringOrNull(ModelParsing.value(map, 'routeKey')) ?? '',
      module: ModelParsing.stringOrNull(ModelParsing.value(map, 'module')) ?? '',
      description: ModelParsing.stringOrNull(ModelParsing.value(map, 'description')) ?? '',
      icon: ModelParsing.stringOrNull(ModelParsing.value(map, 'icon')) ?? '',
      status: ModelParsing.intOrThrow(ModelParsing.value(map, 'status'), 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt'), 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt'), 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson() => json.encode(toMap());

  factory AccessPage.fromJson(String source) => AccessPage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AccessPage(id: $id, uuid: $uuid, ownerUuid: $ownerUuid, key: $key, title: $title, routeKey: $routeKey, module: $module, description: $description, icon: $icon, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant AccessPage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.ownerUuid == ownerUuid &&
        other.key == key &&
        other.title == title &&
        other.routeKey == routeKey &&
        other.module == module &&
        other.description == description &&
        other.icon == icon &&
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
        ownerUuid.hashCode ^
        key.hashCode ^
        title.hashCode ^
        routeKey.hashCode ^
        module.hashCode ^
        description.hashCode ^
        icon.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}