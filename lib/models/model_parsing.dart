import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/services/uuid.dart';

class ModelParsing {
  static dynamic value(Map<String, dynamic> map, String key) {
    if (map.containsKey(key)) {
      return map[key];
    }

    final snakeCaseKey = _camelToSnake(key);
    if (snakeCaseKey != key && map.containsKey(snakeCaseKey)) {
      return map[snakeCaseKey];
    }

    return null;
  }

  static String? stringOrNull(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }

    return value.toString();
  }

  static String stringOrThrow(dynamic value, String fieldName) {
    final parsedValue = stringOrNull(value);
    if (parsedValue == null) {
      throw FormatException('Invalid string value for $fieldName: $value');
    }

    return parsedValue;
  }

  static String uuidOrGenerate(dynamic value) {
    return stringOrNull(value) ?? UUIDGenerator.generate();
  }

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
      final normalized = value.trim();
      if (normalized.isEmpty) {
        return null;
      }

      return int.tryParse(normalized) ?? int.tryParse(normalized.replaceAll(',', ''));
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
      final normalized = value.trim();
      if (normalized.isEmpty) {
        return null;
      }

      return double.tryParse(normalized) ?? double.tryParse(normalized.replaceAll(',', ''));
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

  static bool? boolOrNull(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized.isEmpty) {
        return null;
      }
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
      if (normalized == 'yes' || normalized == 'y') {
        return true;
      }
      if (normalized == 'no' || normalized == 'n') {
        return false;
      }
    }

    return null;
  }

  static DateTime? dateTimeOrNullFromMillisecondsSinceEpoch(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    final parsedValue = intOrNull(value);
    if (parsedValue != null) {
      // ERP integrations commonly send epoch seconds while internal models use milliseconds.
      final epochMillis = parsedValue.abs() < 100000000000 ? parsedValue * 1000 : parsedValue;
      return DateTime.fromMillisecondsSinceEpoch(epochMillis);
    }

    if (value is String) {
      final normalized = value.trim();
      if (normalized.isEmpty) {
        return null;
      }

      return DateTime.tryParse(normalized);
    }

    return null;
  }

  static DateTime dateTimeOrThrow(dynamic value, String fieldName) {
    final parsedValue = dateTimeOrNullFromMillisecondsSinceEpoch(value);
    if (parsedValue == null) {
      throw FormatException('Invalid date value for $fieldName: $value');
    }

    return parsedValue;
  }

  static DateTime dateTimeFromMillisecondsSinceEpoch(dynamic value, String fieldName) {
    return dateTimeOrThrow(value, fieldName);
  }

  static String dateTimeToIso8601Utc(DateTime value) {
    return value.toUtc().toIso8601String();
  }

  static String? dateTimeOrNullToIso8601Utc(DateTime? value) {
    return value == null ? null : dateTimeToIso8601Utc(value);
  }

  static Decimal? decimalOrNull(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Decimal) {
      return value;
    }

    if (value is int) {
      return Decimal.fromInt(value);
    }

    if (value is num) {
      return Decimal.parse(value.toString());
    }

    if (value is String) {
      final normalized = value.trim();
      if (normalized.isEmpty) {
        return null;
      }

      final compact = normalized.replaceAll(' ', '');
      final stripSymbol = compact.replaceAll(RegExp(r'[^0-9,.-]'), '');

      // Handle common ERP money formats like "1,234.56" and "1234,56".
      final normalizedDecimal = stripSymbol.contains(',') && !stripSymbol.contains('.') ? stripSymbol.replaceAll(',', '.') : stripSymbol.replaceAll(',', '');

      return Decimal.tryParse(normalizedDecimal);
    }

    return null;
  }

  static Decimal decimalOrThrow(dynamic value, String fieldName) {
    final parsedValue = decimalOrNull(value);
    if (parsedValue == null) {
      throw FormatException('Invalid decimal value for $fieldName: $value');
    }

    return parsedValue;
  }

  static RecordStatus recordStatusFromCode(dynamic value, String fieldName) {
    return RecordStatus.fromCode(intOrThrow(value, fieldName));
  }

  static StorePaymentMethod paymentMethodFromValue(dynamic value, String fieldName) {
    return _enumFromString(value, fieldName, StorePaymentMethod.fromValue);
  }

  static StoreInvoiceType invoiceTypeFromValue(dynamic value, String fieldName) {
    return _enumFromString(value, fieldName, StoreInvoiceType.fromValue);
  }

  static StoreReturnType returnTypeFromValue(dynamic value, String fieldName) {
    return _enumFromString(value, fieldName, StoreReturnType.fromValue);
  }

  static FinancialTransactionType financialTransactionTypeFromValue(dynamic value, String fieldName) {
    return _enumFromString(value, fieldName, FinancialTransactionType.fromValue);
  }

  static FinancialSourceType financialSourceTypeFromValue(dynamic value, String fieldName) {
    return _enumFromString(value, fieldName, FinancialSourceType.fromValue);
  }

  static LedgerEntryType ledgerEntryTypeFromValue(dynamic value, String fieldName) {
    return _enumFromString(value, fieldName, LedgerEntryType.fromValue);
  }

  static InventoryMovementType inventoryMovementTypeFromValue(dynamic value, String fieldName) {
    return _enumFromString(value, fieldName, InventoryMovementType.fromValue);
  }

  static InventoryReferenceType inventoryReferenceTypeFromValue(dynamic value, String fieldName) {
    return _enumFromString(value, fieldName, InventoryReferenceType.fromValue);
  }

  static InventoryHolderType inventoryHolderTypeFromValue(dynamic value, String fieldName) {
    return _enumFromString(value, fieldName, InventoryHolderType.fromValue);
  }

  static T _enumFromString<T>(dynamic value, String fieldName, T Function(String value) parser) {
    final normalized = stringOrThrow(value, fieldName).trim().toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
    return parser(normalized);
  }

  static String _camelToSnake(String value) {
    return value.replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}');
  }
}
