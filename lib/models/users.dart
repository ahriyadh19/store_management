// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/objectbox.g.dart';
import 'package:store_management/services/uuid.dart';
class User {
  @Id()
  int id = 0;
  String name;
  String email;
  String password;
  String username;
  String uuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  bool synced;
  DateTime? deletedAt;
  DateTime? syncedAt;

  User({
    this.id = 0,
    required this.name,
    required this.email,
    this.password = '',
    required this.username,
    String? uuid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.synced = false,
    this.deletedAt,
    this.syncedAt,
  })
    : uuid = uuid ?? UUIDGenerator.generate();

  User copyWith({int? id, String? name, String? email, String? password, String? username, String? uuid, int? status, DateTime? createdAt, DateTime? updatedAt, bool? synced, DateTime? deletedAt, DateTime? syncedAt}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      uuid: uuid ?? this.uuid,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
      deletedAt: deletedAt ?? this.deletedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toMap({bool includePassword = false}) {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'uuid': uuid,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'synced': synced,
      'deletedAt': deletedAt?.millisecondsSinceEpoch,
      'syncedAt': syncedAt?.millisecondsSinceEpoch,
      if (includePassword) 'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    final email = ModelParsing.stringOrNull(ModelParsing.value(map, 'email')) ?? '';
    final username = ModelParsing.stringOrNull(ModelParsing.value(map, 'username')) ?? (email.contains('@') ? email.split('@').first : 'user');
    final name = ModelParsing.stringOrNull(ModelParsing.value(map, 'name')) ?? username;
    final nowMillis = DateTime.now().millisecondsSinceEpoch;

    return User(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      name: name,
      email: email,
      password: ModelParsing.stringOrNull(ModelParsing.value(map, 'password')) ?? '',
      username: username,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      status: ModelParsing.intOrNull(ModelParsing.value(map, 'status')) ?? 1,
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'createdAt') ?? nowMillis, 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(ModelParsing.value(map, 'updatedAt') ?? nowMillis, 'updatedAt'),
      synced: ModelParsing.boolOrNull(ModelParsing.value(map, 'synced')) ?? false,
      deletedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'deletedAt')),
      syncedAt: ModelParsing.dateTimeOrNullFromMillisecondsSinceEpoch(ModelParsing.value(map, 'syncedAt')),
    );
  }

  String toJson({bool includePassword = false}) => json.encode(toMap(includePassword: includePassword));

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: ***, username: $username, uuid: $uuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.username == username &&
        other.uuid == uuid &&
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
        name.hashCode ^
        email.hashCode ^
        password.hashCode ^
        username.hashCode ^
        uuid.hashCode ^
        status.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        synced.hashCode ^
        deletedAt.hashCode ^
        syncedAt.hashCode;
  }
}

