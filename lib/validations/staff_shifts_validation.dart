import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class StaffShiftsValidation {
  static const Set<String> _allowedStatuses = <String>{'scheduled', 'in_progress', 'completed', 'cancelled'};

  static Response? validateRead(Request request) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    return ValidationUtils.validateRequiredInt(request, 'id', 'Staff shift id is required');
  }

  static Response? validateCreate(Request request) => _validateUpsert(request, requireId: false);
  static Response? validateUpdate(Request request) => _validateUpsert(request, requireId: true);
  static Response? validateDelete(Request request) => validateRead(request);
  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateUpsert(Request request, {required bool requireId}) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Staff shift id is required');
      if (idError != null) return idError;
    }
    final owner = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (owner != null) return owner;
    final branch = ValidationUtils.validateRequiredUuid(request, 'branchUuid', 'Branch uuid must be a valid UUID');
    if (branch != null) return branch;
    final user = ValidationUtils.validateRequiredUuid(request, 'userUuid', 'User uuid must be a valid UUID');
    if (user != null) return user;
    final shiftDate = ValidationUtils.validateRequiredInt(request, 'shiftDate', 'Shift date timestamp is required', min: 0);
    if (shiftDate != null) return shiftDate;
    final startAt = ValidationUtils.validateRequiredInt(request, 'startAt', 'Start at timestamp is required', min: 0);
    if (startAt != null) return startAt;
    final endAt = ValidationUtils.validateOptionalInt(request, 'endAt', 'End at must be a non-negative timestamp', min: 0);
    if (endAt != null) return endAt;
    final status = ValidationUtils.validateRequiredString(request, 'status', 'Staff shift status is required');
    if (status != null) return status;
    final normalizedStatus = (request.data?['status'] as String).trim().toLowerCase();
    if (!_allowedStatuses.contains(normalizedStatus)) return ValidationUtils.badRequest('Staff shift status is invalid');
    return null;
  }
}
