// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/models/base_model.dart';
import 'package:store_management/models/model_parsing.dart';

class User extends AuditedSyncModel {
  String name;
  String email;
  String password;
  String username;

  User({
    super.id = 0,
    required this.name,
    required this.email,
    this.password = '',
    required this.username,
    super.uuid,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.synced = false,
    super.deletedAt,
    super.syncedAt,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? username,
    String? uuid,
    int? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
    DateTime? deletedAt,
    DateTime? syncedAt,
  }) {
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
      'name': name,
      'email': email,
      'username': username,
      ...auditedSyncMap(),
      if (includePassword) 'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    final email =
        ModelParsing.stringOrNull(ModelParsing.value(map, 'email')) ?? '';
    final username =
        ModelParsing.stringOrNull(ModelParsing.value(map, 'username')) ??
        (email.contains('@') ? email.split('@').first : 'user');
    final name =
        ModelParsing.stringOrNull(ModelParsing.value(map, 'name')) ?? username;
    final nowMillis = DateTime.now().millisecondsSinceEpoch;

    return User(
      id: ModelParsing.intOrNull(ModelParsing.value(map, 'id')) ?? 0,
      name: name,
      email: email,
      password:
          ModelParsing.stringOrNull(ModelParsing.value(map, 'password')) ?? '',
      username: username,
      uuid: ModelParsing.uuidOrGenerate(ModelParsing.value(map, 'uuid')),
      status: ModelParsing.intOrNull(ModelParsing.value(map, 'status')) ?? 1,
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'createdAt') ?? nowMillis,
        'createdAt',
      ),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(
        ModelParsing.value(map, 'updatedAt') ?? nowMillis,
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

  String toJson({bool includePassword = false}) =>
      json.encode(toMap(includePassword: includePassword));

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: ***, username: $username, uuid: $uuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, synced: $synced, deletedAt: $deletedAt, syncedAt: $syncedAt)';
  }

  @override
  List<Object?> get props => <Object?>[
    ...auditedSyncProps,
    name,
    email,
    password,
    username,
  ];
}
