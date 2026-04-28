// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StatusInfo {

  final String name;
  final String bgColor;
  final String textColor;
  final String borderColor;
  final String icon;

  
  StatusInfo({
    required this.name,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'bgColor': bgColor,
      'textColor': textColor,
      'borderColor': borderColor,
      'icon': icon,
    };
  }

  StatusInfo copyWith({
    String? name,
    String? bgColor,
    String? textColor,
    String? borderColor,
    String? icon,
  }) {
    return StatusInfo(
      name: name ?? this.name,
      bgColor: bgColor ?? this.bgColor,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      icon: icon ?? this.icon,
    );
  }

  factory StatusInfo.fromMap(Map<String, dynamic> map) {
    return StatusInfo(
      name: map['name'] as String,
      bgColor: map['bgColor'] as String,
      textColor: map['textColor'] as String,
      borderColor: map['borderColor'] as String,
      icon: map['icon'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusInfo.fromJson(String source) => StatusInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatusInfo(name: $name, bgColor: $bgColor, textColor: $textColor, borderColor: $borderColor, icon: $icon)';
  }

  @override
  bool operator ==(covariant StatusInfo other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.bgColor == bgColor &&
      other.textColor == textColor &&
      other.borderColor == borderColor &&
      other.icon == icon;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      bgColor.hashCode ^
      textColor.hashCode ^
      borderColor.hashCode ^
      icon.hashCode;
  }
}
