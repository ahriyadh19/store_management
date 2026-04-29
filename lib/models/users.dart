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

  User({this.id = 0, required this.name, required this.email, this.password = '', required this.username, String? uuid, required this.status, required this.createdAt, required this.updatedAt})
    : uuid = uuid ?? UUIDGenerator.generate();

  User copyWith({int? id, String? name, String? email, String? password, String? username, String? uuid, int? status, DateTime? createdAt, DateTime? updatedAt}) {
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
      if (includePassword) 'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: ModelParsing.intOrNull(map['id']) ?? 0,
      name: ModelParsing.stringOrThrow(map['name'], 'name'),
      email: ModelParsing.stringOrThrow(map['email'], 'email'),
      password: ModelParsing.stringOrNull(map['password']) ?? '',
      username: ModelParsing.stringOrThrow(map['username'], 'username'),
      uuid: ModelParsing.uuidOrGenerate(map['uuid']),
      status: ModelParsing.intOrThrow(map['status'], 'status'),
      createdAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['createdAt'], 'createdAt'),
      updatedAt: ModelParsing.dateTimeFromMillisecondsSinceEpoch(map['updatedAt'], 'updatedAt'),
    );
  }

  String toJson({bool includePassword = false}) => json.encode(toMap(includePassword: includePassword));

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: ***, username: $username, uuid: $uuid, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
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
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ password.hashCode ^ username.hashCode ^ uuid.hashCode ^ status.hashCode ^ createdAt.hashCode ^ updatedAt.hashCode;
  }
}
