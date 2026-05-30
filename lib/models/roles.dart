// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class Roles extends AuditedSyncModel {
  String ownerUuid;
  String name;
  String description;
  Map<String, dynamic> permissionsJson;

  Roles({
    super.id = 0,
    super.uuid,
    this.ownerUuid = '',
    required this.name,
    required this.description,
    this.permissionsJson = const <String, dynamic>{},
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Roles copyWith({
    int? id,
    String? uuid,
    String? ownerUuid,
    String? name,
    String? description,
    Map<String, dynamic>? permissionsJson,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return Roles(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      ownerUuid: ownerUuid ?? this.ownerUuid,
      name: name ?? this.name,
      description: description ?? this.description,
      permissionsJson: permissionsJson ?? this.permissionsJson,
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
      'name': name,
      'description': description,
      'permissionsJson': permissionsJson,
      ...auditedSyncMap(),
    };
  }

  factory Roles.fromMap(Map<String, dynamic> map) {
    return Roles(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      ownerUuid:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'ownerUuid')) ?? '',
      name: ModelParsing.stringOrThrow(ModelParsing.value(map, 'name'), 'name'),
      description: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'description'),
        'description',
      ),
      permissionsJson: _parsePermissionsJson(
        ModelParsing.value(map, 'permissionsJson'),
      ),
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

  factory Roles.fromJson(String source) =>
      Roles.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Roles(id: $id, uuid: $uuid, ownerUuid: $ownerUuid, name: $name, description: $description, permissionsJson: $permissionsJson, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    ownerUuid,
    name,
    description,
    permissionsJson,
  ];
}

Map<String, dynamic> _parsePermissionsJson(dynamic raw) {
  if (raw == null) {
    return const <String, dynamic>{};
  }

  if (raw is Map<String, dynamic>) {
    return Map<String, dynamic>.from(raw);
  }

  if (raw is Map) {
    return Map<String, dynamic>.from(raw);
  }

  if (raw is String) {
    final normalized = raw.trim();
    if (normalized.isEmpty) {
      return const <String, dynamic>{};
    }

    try {
      final decoded = json.decode(normalized);
      if (decoded is Map<String, dynamic>) {
        return Map<String, dynamic>.from(decoded);
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      // Fall back to an empty map when invalid JSON is provided.
    }
  }

  return const <String, dynamic>{};
}
