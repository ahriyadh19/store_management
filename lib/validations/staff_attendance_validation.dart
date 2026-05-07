import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class StaffAttendanceValidation {
  static const Set<String> _allowedStatuses = <String>{'present', 'absent', 'late', 'half_day'};

  static Response? validateRead(Request request) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    return ValidationUtils.validateRequiredInt(request, 'id', 'Staff attendance id is required');
  }

  static Response? validateCreate(Request request) => _validateUpsert(request, requireId: false);
  static Response? validateUpdate(Request request) => _validateUpsert(request, requireId: true);
  static Response? validateDelete(Request request) => validateRead(request);
  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateUpsert(Request request, {required bool requireId}) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Staff attendance id is required');
      if (idError != null) return idError;
    }
    final owner = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (owner != null) return owner;
    final shift = ValidationUtils.validateRequiredUuid(request, 'staffShiftUuid', 'Staff shift uuid must be a valid UUID');
    if (shift != null) return shift;
    final checkIn = ValidationUtils.validateOptionalInt(request, 'checkInAt', 'Check-in timestamp must be non-negative', min: 0);
    if (checkIn != null) return checkIn;
    final checkOut = ValidationUtils.validateOptionalInt(request, 'checkOutAt', 'Check-out timestamp must be non-negative', min: 0);
    if (checkOut != null) return checkOut;
    final minutes = ValidationUtils.validateOptionalInt(request, 'minutesWorked', 'Minutes worked must be zero or greater', min: 0);
    if (minutes != null) return minutes;
    final status = ValidationUtils.validateRequiredString(request, 'status', 'Attendance status is required');
    if (status != null) return status;
    final normalizedStatus = (request.data?['status'] as String).trim().toLowerCase();
    if (!_allowedStatuses.contains(normalizedStatus)) return ValidationUtils.badRequest('Attendance status is invalid');
    return null;
  }
}
