import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class ClientsValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Client id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Client id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Client id is required');
      if (idError != null) {
        return idError;
      }
    }

    final nameError = ValidationUtils.validateRequiredString(request, 'name', 'Client name is required');
    if (nameError != null) {
      return nameError;
    }

    final descriptionError = ValidationUtils.validateRequiredString(request, 'description', 'Client description is required');
    if (descriptionError != null) {
      return descriptionError;
    }

    final emailError = ValidationUtils.validateEmail(request);
    if (emailError != null) {
      return emailError;
    }

    final phoneError = ValidationUtils.validateRequiredString(request, 'phone', 'Client phone is required');
    if (phoneError != null) {
      return phoneError;
    }

    final addressError = ValidationUtils.validateRequiredString(request, 'address', 'Client address is required');
    if (addressError != null) {
      return addressError;
    }

    final creditLimitError = ValidationUtils.validateRequiredNum(request, 'creditLimit', 'Credit limit must be provided as a non-negative number');
    if (creditLimitError != null) {
      return creditLimitError;
    }

    final currentCreditError = ValidationUtils.validateRequiredNum(request, 'currentCredit', 'Current credit must be provided as a non-negative number');
    if (currentCreditError != null) {
      return currentCreditError;
    }

    final availableCreditError = ValidationUtils.validateRequiredNum(request, 'availableCredit', 'Available credit must be provided as a non-negative number');
    if (availableCreditError != null) {
      return availableCreditError;
    }

    return ValidationUtils.validateStatus(request);
  }
}
