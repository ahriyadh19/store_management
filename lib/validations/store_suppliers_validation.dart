import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class StoreSuppliersValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Store supplier id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Store supplier id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Store supplier id is required');
      if (idError != null) {
        return idError;
      }
    }

    final storeUuidError = ValidationUtils.validateRequiredUuid(request, 'storeUuid', 'Store uuid reference must be a valid UUID');
    if (storeUuidError != null) {
      return storeUuidError;
    }

    final supplierUuidError = ValidationUtils.validateRequiredUuid(request, 'supplierUuid', 'Supplier uuid reference must be a valid UUID');
    if (supplierUuidError != null) {
      return supplierUuidError;
    }

    return ValidationUtils.validateStatus(request);
  }
}