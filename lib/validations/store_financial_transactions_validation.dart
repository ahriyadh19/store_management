import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class StoreFinancialTransactionsValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Financial transaction id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Financial transaction id is required');
  }

  static Response? validateAll(Request request) {
    return ValidationUtils.validateRequestMetadata(request);
  }

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Financial transaction id is required');
      if (idError != null) {
        return idError;
      }
    }

    final storeIdError = ValidationUtils.validateRequiredInt(request, 'storeId', 'Store id is required');
    if (storeIdError != null) {
      return storeIdError;
    }

    final storeUuidError = ValidationUtils.validateRequiredUuid(request, 'storeUuid', 'Store uuid must be a valid UUID');
    if (storeUuidError != null) {
      return storeUuidError;
    }

    final clientIdError = ValidationUtils.validateRequiredInt(request, 'clientId', 'Client id is required');
    if (clientIdError != null) {
      return clientIdError;
    }

    final clientUuidError = ValidationUtils.validateRequiredUuid(request, 'clientUuid', 'Client uuid must be a valid UUID');
    if (clientUuidError != null) {
      return clientUuidError;
    }

    final transactionNumberError = ValidationUtils.validateRequiredString(request, 'transactionNumber', 'Transaction number is required');
    if (transactionNumberError != null) {
      return transactionNumberError;
    }

    final transactionTypeError = ValidationUtils.validateRequiredString(request, 'transactionType', 'Transaction type is required');
    if (transactionTypeError != null) {
      return transactionTypeError;
    }

    final sourceTypeError = ValidationUtils.validateRequiredString(request, 'sourceType', 'Source type is required');
    if (sourceTypeError != null) {
      return sourceTypeError;
    }

    final sourceIdError = ValidationUtils.validateRequiredInt(request, 'sourceId', 'Source id is required');
    if (sourceIdError != null) {
      return sourceIdError;
    }

    final sourceUuidError = ValidationUtils.validateRequiredUuid(request, 'sourceUuid', 'Source uuid must be a valid UUID');
    if (sourceUuidError != null) {
      return sourceUuidError;
    }

    final amountError = ValidationUtils.validateRequiredNum(request, 'amount', 'Amount must be zero or greater');
    if (amountError != null) {
      return amountError;
    }

    final entryTypeError = ValidationUtils.validateRequiredString(request, 'entryType', 'Entry type is required');
    if (entryTypeError != null) {
      return entryTypeError;
    }

    final descriptionError = ValidationUtils.validateRequiredString(request, 'description', 'Description is required');
    if (descriptionError != null) {
      return descriptionError;
    }

    final transactionDateError = ValidationUtils.validateRequiredInt(request, 'transactionDate', 'Transaction date timestamp is required', min: 0);
    if (transactionDateError != null) {
      return transactionDateError;
    }

    return ValidationUtils.validateStatus(request);
  }
}