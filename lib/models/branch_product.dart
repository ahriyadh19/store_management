// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class BranchProduct {
	static const Object _unset = Object();

	@Id()
	int id = 0;
	String uuid;
	String branchUuid;
	String companyProductUuid;
	String productUuid;
	int stock;
	int reservedQuantity;
	int? reorderLevel;
	DateTime? lastMovementAt;
	int status;
	DateTime createdAt;
	DateTime updatedAt;
	bool synced;
	DateTime? deletedAt;
	DateTime? syncedAt;

	BranchProduct({
		this.id = 0,
		String? uuid,
		required this.branchUuid,
		required this.companyProductUuid,
		required this.productUuid,
		required this.stock,
		this.reservedQuantity = 0,
		this.reorderLevel,
		this.lastMovementAt,
		required this.status,
		required this.createdAt,
		required this.updatedAt,
		this.synced = false,
		this.deletedAt,
		this.syncedAt,
	}) : uuid = uuid ?? UUIDGenerator.generate();

	BranchProduct copyWith({
		int? id,
		String? uuid,
		String? branchUuid,
		String? companyProductUuid,
		String? productUuid,
		int? stock,
		int? reservedQuantity,
		Object? reorderLevel = _unset,
		Object? lastMovementAt = _unset,
		int? status,
		DateTime? createdAt,
		DateTime? updatedAt,
		bool? synced,
		DateTime? deletedAt,
		DateTime? syncedAt,
	}) {
		return BranchProduct(
			id: id ?? this.id,
			uuid: uuid ?? this.uuid,
			branchUuid: branchUuid ?? this.branchUuid,
			companyProductUuid: companyProductUuid ?? this.companyProductUuid,
			productUuid: productUuid ?? this.productUuid,
			stock: stock ?? this.stock,
			reservedQuantity: reservedQuantity ?? this.reservedQuantity,
			reorderLevel: identical(reorderLevel, _unset) ? this.reorderLevel : reorderLevel as int?,
			lastMovementAt: identical(lastMovementAt, _unset) ? this.lastMovementAt : lastMovementAt as DateTime?,
			status: status ?? this.status,
			createdAt: createdAt ?? this.createdAt,
			updatedAt: updatedAt ?? this.updatedAt,
			synced: synced ?? this.synced,
			deletedAt: deletedAt ?? this.deletedAt,
			syncedAt: syncedAt ?? this.syncedAt,
		);
	}

	int get availableQuantity => stock - reservedQuantity;

	bool get isLowStock => reorderLevel != null && availableQuantity <= reorderLevel!;

	Map<String, dynamic> toMap() {
		return <String, dynamic>{
			'id': id,
			'uuid': uuid,
			'branchUuid': branchUuid,
			'companyProductUuid': companyProductUuid,
			'productUuid': productUuid,
			'stock': stock,
			'reservedQuantity': reservedQuantity,
			'reorderLevel': reorderLevel,
			'lastMovementAt': lastMovementAt?.millisecondsSinceEpoch,
			'status': status,
			'createdAt': createdAt.millisecondsSinceEpoch,
			'updatedAt': updatedAt.millisecondsSinceEpoch,
			'synced': synced,
			'deletedAt': deletedAt?.millisecondsSinceEpoch,
			'syncedAt': syncedAt?.millisecondsSinceEpoch,
		};
	}

	factory BranchProduct.fromMap(Map<String, dynamic> map) {
		return BranchProduct(
			id: ModelParsing.intOrNull(map['id']) ?? 0,
			uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      branchUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'branchUuid'), 'branchUuid'),
      companyProductUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'companyProductUuid'), 'companyProductUuid'),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
			stock: ModelParsing.intOrThrow(map['stock'], 'stock'),
      reservedQuantity: ModelParsing.intOrNull(ModelParsing.value(map, 'reservedQuantity')) ?? 0,
      reorderLevel: ModelParsing.intOrNull(ModelParsing.value(map, 'reorderLevel')),
      lastMovementAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'lastMovementAt')),
			status: ModelParsing.intOrThrow(map['status'], 'status'),
			createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'] ?? map['created_at'], 'createdAt'),
			updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'] ?? map['updated_at'], 'updatedAt'),
			synced: ModelParsing.boolOrNull(map['synced']) ?? false,
			deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['deletedAt'] ?? map['deleted_at']),
			syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(map['syncedAt'] ?? map['synced_at']),
		);
	}

	String toJson() => json.encode(toMap());

	factory BranchProduct.fromJson(String source) => BranchProduct.fromMap(json.decode(source) as Map<String, dynamic>);

	@override
	String toString() {
		return 'BranchProduct(id: $id, uuid: $uuid, branchUuid: $branchUuid, companyProductUuid: $companyProductUuid, productUuid: $productUuid, stock: $stock, reservedQuantity: $reservedQuantity, reorderLevel: $reorderLevel, lastMovementAt: $lastMovementAt, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
	}

	@override
	bool operator ==(covariant BranchProduct other) {
		if (identical(this, other)) return true;

		return other.id == id &&
				other.uuid == uuid &&
				other.branchUuid == branchUuid &&
				other.companyProductUuid == companyProductUuid &&
				other.productUuid == productUuid &&
				other.stock == stock &&
				other.reservedQuantity == reservedQuantity &&
				other.reorderLevel == reorderLevel &&
				other.lastMovementAt == lastMovementAt &&
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
				branchUuid.hashCode ^
				companyProductUuid.hashCode ^
				productUuid.hashCode ^
				stock.hashCode ^
				reservedQuantity.hashCode ^
				reorderLevel.hashCode ^
				lastMovementAt.hashCode ^
				status.hashCode ^
				createdAt.hashCode ^
				updatedAt.hashCode ^
				synced.hashCode ^
				deletedAt.hashCode ^
				syncedAt.hashCode;
	}
}