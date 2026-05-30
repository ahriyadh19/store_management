// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class StoreBranches extends AuditedSyncModel {
  String storeUuid;
  String branchUuid;

  StoreBranches({
    super.id = 0,
    super.uuid,
    required this.storeUuid,
    required this.branchUuid,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  StoreBranches copyWith({
    int? id,
    String? uuid,
    String? storeUuid,
    String? branchUuid,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return StoreBranches(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeUuid: storeUuid ?? this.storeUuid,
      branchUuid: branchUuid ?? this.branchUuid,
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
      'storeUuid': storeUuid,
      'branchUuid': branchUuid,
      ...auditedSyncMap(),
    };
  }

  factory StoreBranches.fromMap(Map<String, dynamic> map) {
    return StoreBranches(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      storeUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'storeUuid'),
        'storeUuid',
      ),
      branchUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'branchUuid'),
        'branchUuid',
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

  factory StoreBranches.fromJson(String source) =>
      StoreBranches.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreBranches(id: $id, uuid: $uuid, storeUuid: $storeUuid, branchUuid: $branchUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    storeUuid,
    branchUuid,
  ];
}
