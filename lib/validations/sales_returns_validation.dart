import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class SalesReturnsValidation {
  static const Set<String> _allowedStatuses = <String>{'draft', 'approved', 'refunded', 'cancelled'};

  static Response? validateRead(Request request) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    return ValidationUtils.validateRequiredInt(request, 'id', 'Sales return id is required');
  }

  static Response? validateCreate(Request request) => _validateUpsert(request, requireId: false);
  static Response? validateUpdate(Request request) => _validateUpsert(request, requireId: true);
  static Response? validateDelete(Request request) => validateRead(request);
  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateUpsert(Request request, {required bool requireId}) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Sales return id is required');
      if (idError != null) return idError;
    }
    final owner = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (owner != null) return owner;
    final invoice = ValidationUtils.validateRequiredUuid(request, 'salesInvoiceUuid', 'Sales invoice uuid must be a valid UUID');
    if (invoice != null) return invoice;
    final number = ValidationUtils.validateRequiredString(request, 'returnNumber', 'Return number is required');
    if (number != null) return number;
    final date = ValidationUtils.validateRequiredInt(request, 'returnDate', 'Return date timestamp is required', min: 0);
    if (date != null) return date;
    final reason = ValidationUtils.validateRequiredString(request, 'reason', 'Return reason is required');
    if (reason != null) return reason;
    final amount = ValidationUtils.validateRequiredNum(request, 'refundAmount', 'Refund amount must be zero or greater', min: 0);
    if (amount != null) return amount;
    final statusError = ValidationUtils.validateRequiredString(request, 'status', 'Sales return status is required');
    if (statusError != null) return statusError;
    final status = (request.data?['status'] as String).trim().toLowerCase();
    if (!_allowedStatuses.contains(status)) return ValidationUtils.badRequest('Sales return status is invalid');
    return ValidationUtils.validateOptionalUuid(request, 'createdByUserUuid', 'Created by user uuid must be a valid UUID');
  }
}
