// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Response {
  final int statusCode;
  final String title;
  final String message;
  final dynamic data;

  const Response({required this.statusCode, required this.title, required this.message, this.data});

  Response copyWith({int? statusCode, String? title, String? message, dynamic data}) {
    return Response(statusCode: statusCode ?? this.statusCode, title: title ?? this.title, message: message ?? this.message, data: data ?? this.data);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'statusCode': statusCode, 'title': title, 'message': message, 'data': data};
  }

  factory Response.fromMap(Map<String, dynamic> map) {
    return Response(statusCode: map['statusCode'] as int, title: map['title'] as String, message: map['message'] as String, data: map['data'] as dynamic);
  }

  String toJson() => json.encode(toMap());

  factory Response.fromJson(String source) => Response.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Response(statusCode: $statusCode, title: $title, message: $message, data: $data)';
  }

  @override
  bool operator ==(covariant Response other) {
    if (identical(this, other)) return true;

    return other.statusCode == statusCode && other.title == title && other.message == message && other.data == data;
  }

  @override
  int get hashCode {
    return statusCode.hashCode ^ title.hashCode ^ message.hashCode ^ data.hashCode;
  }
}
