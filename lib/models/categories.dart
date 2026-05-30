// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class Categories extends AuditedSyncModel {
  static const Object _unset = Object();

  String name;
  String description;
  String? parentUuid;

  Categories({
    super.id = 0,
    super.uuid,
    required this.name,
    required this.description,
    required super.status,
    this.parentUuid,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  Categories copyWith({
    int? id,
    String? uuid,
    String? name,
    String? description,
    int? status,
    Object? parentUuid = _unset,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return Categories(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      parentUuid: identical(parentUuid, _unset)
          ? this.parentUuid
          : parentUuid as String?,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'parentUuid': parentUuid,
      ...auditedSyncMap(),
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      name: ModelParsing.stringOrThrow(ModelParsing.value(map, 'name'), 'name'),
      description: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'description'),
        'description',
      ),
      status: ModelParsing.intOrThrow(
        ModelParsing.value(map, 'status'),
        'status',
      ),
      parentUuid: ModelParsing.stringOrNull(
        ModelParsing.value(map, 'parentUuid'),
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

  factory Categories.fromJson(String source) =>
      Categories.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Categories(id: $id, uuid: $uuid, name: $name, description: $description, status: $status, parentUuid: $parentUuid, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    name,
    description,
    parentUuid,
  ];
}
