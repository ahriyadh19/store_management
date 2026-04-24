// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Request {
  final String title;
  final String message;
  final Map<String, dynamic>? data;

  const Request({
    required this.title,
    required this.message,
    this.data,
  });

  Request copyWith({
    String? title,
    String? message,
    Map<String, dynamic>? data,
  }) {
    return Request(
      title: title ?? this.title,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'message': message,
      'data': data,
    };
  }

  factory Request.fromMap(Map<String, dynamic> map) {
    return Request(
      title: map['title'] as String,
      message: map['message'] as String,
      data: map['data'] != null ? Map<String, dynamic>.from((map['data'] as Map<String, dynamic>)) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Request.fromJson(String source) => Request.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Request(title: $title, message: $message, data: $data)';

  @override
  bool operator ==(covariant Request other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.message == message &&
      mapEquals(other.data, data);
  }

  @override
  int get hashCode => title.hashCode ^ message.hashCode ^ data.hashCode;
}
