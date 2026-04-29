import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class StoreUsersValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Store user id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Store user id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Store user id is required');
      if (idError != null) {
        return idError;
      }
    }

    final storeUuidError = ValidationUtils.validateRequiredUuid(request, 'storeUuid', 'Store uuid reference must be a valid UUID');
    if (storeUuidError != null) {
      return storeUuidError;
    }

    final userUuidError = ValidationUtils.validateRequiredUuid(request, 'userUuid', 'User uuid reference must be a valid UUID');
    if (userUuidError != null) {
      return userUuidError;
    }

    final userRoleUuidError = ValidationUtils.validateRequiredUuid(request, 'userRoleUuid', 'User role uuid reference must be a valid UUID');
    if (userRoleUuidError != null) {
      return userRoleUuidError;
    }

    return ValidationUtils.validateStatus(request);
  }
}
