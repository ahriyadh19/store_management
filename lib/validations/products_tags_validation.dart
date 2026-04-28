import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class ProductsTagsValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Product tag id is required');
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

    return ValidationUtils.validateRequiredInt(request, 'id', 'Product tag id is required');
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
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Product tag id is required');
      if (idError != null) {
        return idError;
      }
    }

    final productUuidError = ValidationUtils.validateRequiredUuid(request, 'productUuid', 'Product uuid reference must be a valid UUID');
    if (productUuidError != null) {
      return productUuidError;
    }

    final tagUuidError = ValidationUtils.validateRequiredUuid(request, 'tagUuid', 'Tag uuid reference must be a valid UUID');
    if (tagUuidError != null) {
      return tagUuidError;
    }

    return ValidationUtils.validateStatus(request);
  }
}