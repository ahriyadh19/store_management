import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class TransferOrdersValidation {
  static const Set<String> _allowedStatuses = <String>{'draft', 'approved', 'in_transit', 'partially_received', 'received', 'cancelled'};

  static Response? validateRead(Request request) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    return ValidationUtils.validateRequiredInt(request, 'id', 'Transfer order id is required');
  }

  static Response? validateCreate(Request request) => _validateUpsert(request, requireId: false);
  static Response? validateUpdate(Request request) => _validateUpsert(request, requireId: true);
  static Response? validateDelete(Request request) => validateRead(request);
  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateUpsert(Request request, {required bool requireId}) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Transfer order id is required');
      if (idError != null) return idError;
    }
    final owner = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (owner != null) return owner;
    final src = ValidationUtils.validateRequiredUuid(request, 'sourceBranchUuid', 'Source branch uuid must be a valid UUID');
    if (src != null) return src;
    final dest = ValidationUtils.validateRequiredUuid(request, 'destinationBranchUuid', 'Destination branch uuid must be a valid UUID');
    if (dest != null) return dest;
    if (request.data?['sourceBranchUuid'] == request.data?['destinationBranchUuid']) {
      return ValidationUtils.badRequest('Source and destination branches must be different');
    }
    final number = ValidationUtils.validateRequiredString(request, 'transferNumber', 'Transfer number is required');
    if (number != null) return number;
    final requestedAt = ValidationUtils.validateRequiredInt(request, 'requestedAt', 'Requested at timestamp is required', min: 0);
    if (requestedAt != null) return requestedAt;
    final shipped = ValidationUtils.validateOptionalInt(request, 'shippedAt', 'Shipped at must be a non-negative timestamp', min: 0);
    if (shipped != null) return shipped;
    final received = ValidationUtils.validateOptionalInt(request, 'receivedAt', 'Received at must be a non-negative timestamp', min: 0);
    if (received != null) return received;
    final statusError = ValidationUtils.validateRequiredString(request, 'status', 'Transfer order status is required');
    if (statusError != null) return statusError;
    final status = (request.data?['status'] as String).trim().toLowerCase();
    if (!_allowedStatuses.contains(status)) return ValidationUtils.badRequest('Transfer order status is invalid');
    return ValidationUtils.validateOptionalUuid(request, 'createdByUserUuid', 'Created by user uuid must be a valid UUID');
  }
}
