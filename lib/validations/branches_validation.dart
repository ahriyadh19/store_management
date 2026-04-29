import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class BranchesValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Branch id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Branch id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Branch id is required');
      if (idError != null) {
        return idError;
      }
    }

    final nameError = ValidationUtils.validateRequiredString(request, 'name', 'Branch name is required');
    if (nameError != null) {
      return nameError;
    }

    final descriptionError = ValidationUtils.validateRequiredString(request, 'description', 'Branch description is required');
    if (descriptionError != null) {
      return descriptionError;
    }

    final addressError = ValidationUtils.validateRequiredString(request, 'address', 'Branch address is required');
    if (addressError != null) {
      return addressError;
    }

    final phoneError = ValidationUtils.validateRequiredString(request, 'phone', 'Branch phone is required');
    if (phoneError != null) {
      return phoneError;
    }

    final emailError = ValidationUtils.validateEmail(request);
    if (emailError != null) {
      return emailError;
    }

    return ValidationUtils.validateStatus(request);
  }
}
