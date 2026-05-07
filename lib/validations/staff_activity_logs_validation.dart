import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class StaffActivityLogsValidation {
  static Response? validateRead(Request request) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    return ValidationUtils.validateRequiredInt(request, 'id', 'Staff activity log id is required');
  }

  static Response? validateCreate(Request request) => _validateUpsert(request, requireId: false);
  static Response? validateUpdate(Request request) => _validateUpsert(request, requireId: true);
  static Response? validateDelete(Request request) => validateRead(request);
  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateUpsert(Request request, {required bool requireId}) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Staff activity log id is required');
      if (idError != null) return idError;
    }
    final owner = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (owner != null) return owner;
    final branch = ValidationUtils.validateOptionalUuid(request, 'branchUuid', 'Branch uuid must be a valid UUID');
    if (branch != null) return branch;
    final user = ValidationUtils.validateOptionalUuid(request, 'userUuid', 'User uuid must be a valid UUID');
    if (user != null) return user;
    final action = ValidationUtils.validateRequiredString(request, 'action', 'Action is required');
    if (action != null) return action;
    final entityType = ValidationUtils.validateRequiredString(request, 'entityType', 'Entity type is required');
    if (entityType != null) return entityType;
    final entityUuid = ValidationUtils.validateOptionalUuid(request, 'entityUuid', 'Entity uuid must be a valid UUID');
    if (entityUuid != null) return entityUuid;
    final metadataJson = request.data?['metadataJson'];
    if (metadataJson != null && metadataJson is! Map) {
      return ValidationUtils.badRequest('metadataJson must be an object');
    }
    return null;
  }
}
