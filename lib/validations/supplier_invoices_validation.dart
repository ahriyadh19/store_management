import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class SupplierInvoicesValidation {
  static const Set<String> _allowedStatuses = <String>{
    'draft',
    'open',
    'partially_paid',
    'paid',
    'cancelled',
  };

  static const Map<String, Set<String>> _allowedTransitions = <String, Set<String>>{
    'draft': <String>{'draft', 'open', 'cancelled'},
    'open': <String>{'open', 'partially_paid', 'paid', 'cancelled'},
    'partially_paid': <String>{'partially_paid', 'paid', 'cancelled'},
    'paid': <String>{'paid'},
    'cancelled': <String>{'cancelled'},
  };

  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Supplier invoice id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Supplier invoice id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Supplier invoice id is required');
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

    final purchaseOrderUuidError = ValidationUtils.validateOptionalUuid(request, 'purchaseOrderUuid', 'Purchase order uuid must be a valid UUID');
    if (purchaseOrderUuidError != null) {
      return purchaseOrderUuidError;
    }

    final invoiceNumberError = ValidationUtils.validateRequiredString(request, 'supplierInvoiceNumber', 'Supplier invoice number is required');
    if (invoiceNumberError != null) {
      return invoiceNumberError;
    }

    final invoiceDateError = ValidationUtils.validateRequiredInt(request, 'invoiceDate', 'Invoice date timestamp is required', min: 0);
    if (invoiceDateError != null) {
      return invoiceDateError;
    }

    final dueDateError = ValidationUtils.validateOptionalInt(request, 'dueDate', 'Due date must be a non-negative timestamp', min: 0);
    if (dueDateError != null) {
      return dueDateError;
    }

    final currencyCodeError = ValidationUtils.validateRequiredString(request, 'currencyCode', 'Currency code is required');
    if (currencyCodeError != null) {
      return currencyCodeError;
    }

    final subtotalError = ValidationUtils.validateRequiredNum(request, 'subtotal', 'Subtotal amount must be zero or greater', min: 0);
    if (subtotalError != null) {
      return subtotalError;
    }

    final totalAmountError = ValidationUtils.validateRequiredNum(request, 'totalAmount', 'Total amount must be zero or greater', min: 0);
    if (totalAmountError != null) {
      return totalAmountError;
    }

    final taxAmount = request.data?['taxAmount'];
    if (taxAmount != null && (taxAmount is! num || taxAmount < 0)) {
      return ValidationUtils.badRequest('Tax amount must be zero or greater');
    }

    final statusError = ValidationUtils.validateRequiredString(request, 'status', 'Supplier invoice status is required');
    if (statusError != null) {
      return statusError;
    }

    final status = (request.data?['status'] as String).trim().toLowerCase();
    if (!_allowedStatuses.contains(status)) {
      return ValidationUtils.badRequest('Supplier invoice status is invalid');
    }

    if (requireId) {
      final transitionError = _validateTransition(request, status, 'Supplier invoice status transition is invalid');
      if (transitionError != null) {
        return transitionError;
      }
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

