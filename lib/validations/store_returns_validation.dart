import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class StoreReturnsValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Return id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Return id is required');
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
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Return id is required');
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

    final returnNumberError = ValidationUtils.validateRequiredString(request, 'returnNumber', 'Return number is required');
    if (returnNumberError != null) {
      return returnNumberError;
    }

    final returnTypeError = ValidationUtils.validateRequiredString(request, 'returnType', 'Return type is required');
    if (returnTypeError != null) {
      return returnTypeError;
    }

    final itemCountError = ValidationUtils.validateRequiredInt(request, 'itemCount', 'Item count is required');
    if (itemCountError != null) {
      return itemCountError;
    }

    final totalAmountError = ValidationUtils.validateRequiredNum(request, 'totalAmount', 'Total amount must be zero or greater');
    if (totalAmountError != null) {
      return totalAmountError;
    }

    final reasonError = ValidationUtils.validateRequiredString(request, 'reason', 'Return reason is required');
    if (reasonError != null) {
      return reasonError;
    }

    final transactionDateError = ValidationUtils.validateRequiredInt(request, 'transactionDate', 'Transaction date timestamp is required', min: 0);
    if (transactionDateError != null) {
      return transactionDateError;
    }

    return ValidationUtils.validateStatus(request);
  }
}