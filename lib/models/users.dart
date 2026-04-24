// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:store_management/services/uuid.dart';

class User {
  int? id;
  String name;
  String email;
  String password;
  String username;
  String uuid;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  User({this.id, required this.name, required this.email, required this.password, required this.username, String? uuid, required this.status, required this.createdAt, required this.updatedAt})
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
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      email: map['email'] as String,
      password: (map['password'] as String?) ?? '',
      username: map['username'] as String,
      uuid: map['uuid'] as String,
      status: map['status'] as int,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
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
