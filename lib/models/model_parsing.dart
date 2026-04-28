import 'package:decimal/decimal.dart';
import 'package:store_management/models/model_enums.dart';

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
    if (value is! String) {
      throw FormatException('Invalid string value for $fieldName: $value');
    }

    return StorePaymentMethod.fromValue(value);
  }

  static StoreInvoiceType invoiceTypeFromValue(dynamic value, String fieldName) {
    if (value is! String) {
      throw FormatException('Invalid string value for $fieldName: $value');
    }

    return StoreInvoiceType.fromValue(value);
  }

  static StoreReturnType returnTypeFromValue(dynamic value, String fieldName) {
    if (value is! String) {
      throw FormatException('Invalid string value for $fieldName: $value');
    }

    return StoreReturnType.fromValue(value);
  }

  static FinancialTransactionType financialTransactionTypeFromValue(dynamic value, String fieldName) {
    if (value is! String) {
      throw FormatException('Invalid string value for $fieldName: $value');
    }

    return FinancialTransactionType.fromValue(value);
  }

  static FinancialSourceType financialSourceTypeFromValue(dynamic value, String fieldName) {
    if (value is! String) {
      throw FormatException('Invalid string value for $fieldName: $value');
    }

    return FinancialSourceType.fromValue(value);
  }

  static LedgerEntryType ledgerEntryTypeFromValue(dynamic value, String fieldName) {
    if (value is! String) {
      throw FormatException('Invalid string value for $fieldName: $value');
    }

    return LedgerEntryType.fromValue(value);
  }

  static InventoryMovementType inventoryMovementTypeFromValue(dynamic value, String fieldName) {
    if (value is! String) {
      throw FormatException('Invalid string value for $fieldName: $value');
    }

    return InventoryMovementType.fromValue(value);
  }

  static InventoryReferenceType inventoryReferenceTypeFromValue(dynamic value, String fieldName) {
    if (value is! String) {
      throw FormatException('Invalid string value for $fieldName: $value');
    }

    return InventoryReferenceType.fromValue(value);
  }
}