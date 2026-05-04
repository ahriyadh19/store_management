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
    }

    return null;
  }

  static DateTime? dateTimeOrNullFromMillisecondsSinceEpoch(dynamic value) {
    final parsedValue = intOrNull(value);
    if (parsedValue == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(parsedValue);
  }

  static DateTime dateTimeFromMillisecondsSinceEpoch(dynamic value, String fieldName) {
    return DateTime.fromMillisecondsSinceEpoch(intOrThrow(value, fieldName));
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
      return Decimal.tryParse(value);
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
    return parser(stringOrThrow(value, fieldName).trim().toLowerCase());
  }

  static String _camelToSnake(String value) {
    return value.replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}');
  }
}
