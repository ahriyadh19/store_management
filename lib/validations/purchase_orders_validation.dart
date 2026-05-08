import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class PurchaseOrdersValidation {
  static const Set<String> _allowedStatuses = <String>{
    'draft',
    'submitted',
    'partial_received',
    'received',
    'cancelled',
  };

  static const Map<String, Set<String>> _allowedTransitions = <String, Set<String>>{
    'draft': <String>{'draft', 'submitted', 'cancelled'},
    'submitted': <String>{'submitted', 'partial_received', 'received', 'cancelled'},
    'partial_received': <String>{'partial_received', 'received', 'cancelled'},
    'received': <String>{'received'},
    'cancelled': <String>{'cancelled'},
  };

  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Purchase order id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Purchase order id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Purchase order id is required');
      if (idError != null) {
        return idError;
      }
    }

    final ownerUuidError = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (ownerUuidError != null) {
      return ownerUuidError;
    }

    final storeUuidError = ValidationUtils.validateRequiredUuid(request, 'storeUuid', 'Store uuid must be a valid UUID');
    if (storeUuidError != null) {
      return storeUuidError;
    }

    final supplierUuidError = ValidationUtils.validateRequiredUuid(request, 'supplierUuid', 'Supplier uuid must be a valid UUID');
    if (supplierUuidError != null) {
      return supplierUuidError;
    }

    final poNumberError = ValidationUtils.validateRequiredString(request, 'poNumber', 'PO number is required');
    if (poNumberError != null) {
      return poNumberError;
    }

    final orderDateError = ValidationUtils.validateRequiredInt(request, 'orderDate', 'Order date timestamp is required', min: 0);
    if (orderDateError != null) {
      return orderDateError;
    }

    final expectedDateError = ValidationUtils.validateOptionalInt(request, 'expectedDate', 'Expected date must be a non-negative timestamp', min: 0);
    if (expectedDateError != null) {
      return expectedDateError;
    }

    final statusError = ValidationUtils.validateRequiredString(request, 'status', 'Purchase order status is required');
    if (statusError != null) {
      return statusError;
    }

    final status = (request.data?['status'] as String).trim().toLowerCase();
    if (!_allowedStatuses.contains(status)) {
      return ValidationUtils.badRequest('Purchase order status is invalid');
    }

    if (requireId) {
      final transitionError = _validateTransition(request, status, 'Purchase order status transition is invalid');
      if (transitionError != null) {
        return transitionError;
      }
    }

    final currencyCodeError = ValidationUtils.validateRequiredString(request, 'currencyCode', 'Currency code is required');
    if (currencyCodeError != null) {
      return currencyCodeError;
    }

    final totalAmountError = ValidationUtils.validateRequiredNum(request, 'totalAmount', 'Total amount must be zero or greater', min: 0);
    if (totalAmountError != null) {
      return totalAmountError;
    }

    final notesError = ValidationUtils.validateRequiredString(request, 'notes', 'Purchase order notes are required');
    if (notesError != null) {
      return notesError;
    }

    final createdByUserUuidError = ValidationUtils.validateOptionalUuid(request, 'createdByUserUuid', 'Created by user uuid must be a valid UUID');
    if (createdByUserUuidError != null) {
      return createdByUserUuidError;
    }

    return null;
  }

  static Response? _validateTransition(Request request, String nextStatus, String errorMessage) {
    final previousRaw = request.data?['previousStatus'];
    if (previousRaw is! String || previousRaw.trim().isEmpty) {
      return null;
    }

    final previousStatus = previousRaw.trim().toLowerCase();
    final allowedNext = _allowedTransitions[previousStatus];
    if (allowedNext == null || !allowedNext.contains(nextStatus)) {
      return ValidationUtils.badRequest(errorMessage);
    }

    return null;
  }
}
