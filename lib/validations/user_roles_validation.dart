import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class UserRolesValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'User role id is required');
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

    return ValidationUtils.validateRequiredInt(request, 'id', 'User role id is required');
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
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'User role id is required');
      if (idError != null) {
        return idError;
      }
    }

    final userIdError = ValidationUtils.validateRequiredInt(request, 'userId', 'User id reference must be a valid integer');
    if (userIdError != null) {
      return userIdError;
    }

    final userUuidError = ValidationUtils.validateRequiredUuid(request, 'userUuid', 'User uuid reference must be a valid UUID');
    if (userUuidError != null) {
      return userUuidError;
    }

    final roleIdError = ValidationUtils.validateRequiredInt(request, 'roleId', 'Role id reference must be a valid integer');
    if (roleIdError != null) {
      return roleIdError;
    }

    final roleUuidError = ValidationUtils.validateRequiredUuid(request, 'roleUuid', 'Role uuid reference must be a valid UUID');
    if (roleUuidError != null) {
      return roleUuidError;
    }

    return ValidationUtils.validateStatus(request);
  }
}