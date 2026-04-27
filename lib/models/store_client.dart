// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/services/uuid.dart';

class StoreClient {
  int? id;
  String uuid;
  int storeId;
  String storeUuid;
  int clientId;
  String clientUuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  StoreClient({String? uuid, this.id, required this.storeId, required this.storeUuid, required this.clientId, required this.clientUuid, required this.status, required this.createdAt, required this.updatedAt})
    : uuid = uuid ?? UUIDGenerator.generate();

  StoreClient copyWith({int? id, String? uuid, int? storeId, String? storeUuid, int? clientId, String? clientUuid, int? status, DateTime? createdAt, DateTime? updatedAt}) {
    return StoreClient(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      storeId: storeId ?? this.storeId,
      storeUuid: storeUuid ?? this.storeUuid,
      clientId: clientId ?? this.clientId,
      clientUuid: clientUuid ?? this.clientUuid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'storeId': storeId,
      'storeUuid': storeUuid,
      'clientId': clientId,
      'clientUuid': clientUuid,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory StoreClient.fromMap(Map<String, dynamic> map) {
    return StoreClient(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] as String,
      storeId: map['storeId'] as int,
      storeUuid: map['storeUuid'] as String,
      clientId: map['clientId'] as int,
      clientUuid: map['clientUuid'] as String,
      status: map['status'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreClient.fromJson(String source) => StoreClient.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreClient(id: $id, uuid: $uuid, storeId: $storeId, storeUuid: $storeUuid, clientId: $clientId, clientUuid: $clientUuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant StoreClient other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.storeId == storeId &&
        other.storeUuid == storeUuid &&
        other.clientId == clientId &&
        other.clientUuid == clientUuid &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ uuid.hashCode ^ storeId.hashCode ^ storeUuid.hashCode ^ clientId.hashCode ^ clientUuid.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
