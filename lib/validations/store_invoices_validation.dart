import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/validations/validation_utils.dart';

class StoreInvoicesValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Invoice id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Invoice id is required');
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
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Invoice id is required');
      if (idError != null) {
        return idError;
      }
    }

    final storeIdError = ValidationUtils.validateRequiredInt(request, 'storeId', 'Store id is required');
    if (storeIdError != null) {
      return storeIdError;
    }

    final storeUuidError = ValidationUtils.validateRequiredUuid(request, 'storeUuid', 'Store uuid must be a valid UUID');
    if (storeUuidError != null) {
      return storeUuidError;
    }

    final clientIdError = ValidationUtils.validateRequiredInt(request, 'clientId', 'Client id is required');
    if (clientIdError != null) {
      return clientIdError;
    }

    final clientUuidError = ValidationUtils.validateRequiredUuid(request, 'clientUuid', 'Client uuid must be a valid UUID');
    if (clientUuidError != null) {
      return clientUuidError;
    }

    final invoiceNumberError = ValidationUtils.validateRequiredString(request, 'invoiceNumber', 'Invoice number is required');
    if (invoiceNumberError != null) {
      return invoiceNumberError;
    }

    final invoiceTypeError = ValidationUtils.validateRequiredEnumString(request, 'invoiceType', 'Invoice type is invalid', StoreInvoiceType.fromValue);
    if (invoiceTypeError != null) {
      return invoiceTypeError;
    }

    final itemCountError = ValidationUtils.validateRequiredInt(request, 'itemCount', 'Item count must be zero or greater', min: 0);
    if (itemCountError != null) {
      return itemCountError;
    }

    final totalAmountError = ValidationUtils.validateRequiredNum(request, 'totalAmount', 'Total amount must be zero or greater');
    if (totalAmountError != null) {
      return totalAmountError;
    }

    final paidAmountError = ValidationUtils.validateRequiredNum(request, 'paidAmount', 'Paid amount must be zero or greater');
    if (paidAmountError != null) {
      return paidAmountError;
    }

    final balanceAmountError = ValidationUtils.validateRequiredNum(request, 'balanceAmount', 'Balance amount must be zero or greater');
    if (balanceAmountError != null) {
      return balanceAmountError;
    }

    final notesError = ValidationUtils.validateRequiredString(request, 'notes', 'Invoice notes are required');
    if (notesError != null) {
      return notesError;
    }

    final issuedAtError = ValidationUtils.validateRequiredInt(request, 'issuedAt', 'Issued at timestamp is required', min: 0);
    if (issuedAtError != null) {
      return issuedAtError;
    }

    final dueAtError = ValidationUtils.validateRequiredInt(request, 'dueAt', 'Due at timestamp is required', min: 0);
    if (dueAtError != null) {
      return dueAtError;
    }

    return ValidationUtils.validateStatus(request);
  }
}