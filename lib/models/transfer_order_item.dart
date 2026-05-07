// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';

class TransferOrderItem {
  @Id()
  int id = 0;
  String uuid;
  String transferOrderUuid;
  String productUuid;
  int quantity;
  int shippedQuantity;
  int receivedQuantity;

  TransferOrderItem({
    this.id = 0,
    String? uuid,
    required this.transferOrderUuid,
    required this.productUuid,
    required this.quantity,
    this.shippedQuantity = 0,
    this.receivedQuantity = 0,
  }) : uuid = uuid ?? UUIDGenerator.generate();

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'uuid': uuid,
    'transferOrderUuid': transferOrderUuid,
    'productUuid': productUuid,
    'quantity': quantity,
    'shippedQuantity': shippedQuantity,
    'receivedQuantity': receivedQuantity,
  };

  factory TransferOrderItem.fromMap(Map<String, dynamic> map) {
    return TransferOrderItem(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      transferOrderUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'transferOrderUuid'), 'transferOrderUuid'),
      productUuid: ModelParsing.stringOrThrow(ModelParsing.value(map, 'productUuid'), 'productUuid'),
      quantity: ModelParsing.intOrThrow(ModelParsing.value(map, 'quantity'), 'quantity'),
      shippedQuantity: ModelParsing.intOrNull(ModelParsing.value(map, 'shippedQuantity')) ?? 0,
      receivedQuantity: ModelParsing.intOrNull(ModelParsing.value(map, 'receivedQuantity')) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());
  factory TransferOrderItem.fromJson(String source) => TransferOrderItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
