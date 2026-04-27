class ModelParsing {
  static int? intOrNull(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static int intOrThrow(dynamic value, String fieldName) {
    final parsedValue = intOrNull(value);
    if (parsedValue == null) {
      throw FormatException('Invalid integer value for $fieldName: $value');
    }

    return parsedValue;
  }

  static double? doubleOrNull(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }

  static double doubleOrThrow(dynamic value, String fieldName) {
    final parsedValue = doubleOrNull(value);
    if (parsedValue == null) {
      throw FormatException('Invalid double value for $fieldName: $value');
    }

    return parsedValue;
  }

  static DateTime dateTimeFromMillisecondsSinceEpoch(dynamic value, String fieldName) {
    return DateTime.fromMillisecondsSinceEpoch(intOrThrow(value, fieldName));
  }
}