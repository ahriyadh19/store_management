import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class CategoriesValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Category id is required');
  }

  static Response? validateCreate(Request request) {
    return _validateCreateOrUpdate(request, requireId: false);
  }

  static Response? validateUpdate(Request request) {
    return _validateCreateOrUpdate(request, requireId: true);
  }

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Category id is required');
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
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Category id is required');
      if (idError != null) {
        return idError;
      }
    }

    final nameError = ValidationUtils.validateRequiredString(request, 'name', 'Category name is required');
    if (nameError != null) {
      return nameError;
    }

    final descriptionError = ValidationUtils.validateRequiredString(request, 'description', 'Category description is required');
    if (descriptionError != null) {
      return descriptionError;
    }

    final statusError = ValidationUtils.validateStatus(request);
    if (statusError != null) {
      return statusError;
    }

    return ValidationUtils.validateOptionalUuid(request, 'parentUuid', 'Parent uuid must be provided as a valid UUID');
  }
}