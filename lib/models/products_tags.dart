// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class ProductsTags extends AuditedSyncModel {
  String productUuid;
  String tagUuid;
  ProductsTags({
    super.id = 0,
    super.uuid,
    required this.productUuid,
    required this.tagUuid,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  ProductsTags copyWith({
    int? id,
    String? uuid,
    String? productUuid,
    String? tagUuid,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
    return ProductsTags(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      productUuid: productUuid ?? this.productUuid,
      tagUuid: tagUuid ?? this.tagUuid,
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
      'productUuid': productUuid,
      'tagUuid': tagUuid,
      ...auditedSyncMap(),
    };
  }

  factory ProductsTags.fromMap(Map<String, dynamic> map) {
    return ProductsTags(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      productUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'productUuid'),
        'productUuid',
      ),
      tagUuid: ModelParsing.stringOrThrow(
        ModelParsing.value(map, 'tagUuid'),
        'tagUuid',
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

  factory ProductsTags.fromJson(String source) =>
      ProductsTags.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductsTags(id: $id, uuid: $uuid, productUuid: $productUuid, tagUuid: $tagUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    productUuid,
    tagUuid,
  ];
}
