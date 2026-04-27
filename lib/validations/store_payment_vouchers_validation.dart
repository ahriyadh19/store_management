import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class StorePaymentVouchersValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Payment voucher id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Payment voucher id is required');
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
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Payment voucher id is required');
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

    final voucherNumberError = ValidationUtils.validateRequiredString(request, 'voucherNumber', 'Voucher number is required');
    if (voucherNumberError != null) {
      return voucherNumberError;
    }

    final payeeNameError = ValidationUtils.validateRequiredString(request, 'payeeName', 'Payee name is required');
    if (payeeNameError != null) {
      return payeeNameError;
    }

    final amountError = ValidationUtils.validateRequiredNum(request, 'amount', 'Amount must be zero or greater');
    if (amountError != null) {
      return amountError;
    }

    final paymentMethodError = ValidationUtils.validateRequiredString(request, 'paymentMethod', 'Payment method is required');
    if (paymentMethodError != null) {
      return paymentMethodError;
    }

    final referenceNumberError = ValidationUtils.validateRequiredString(request, 'referenceNumber', 'Reference number is required');
    if (referenceNumberError != null) {
      return referenceNumberError;
    }

    final descriptionError = ValidationUtils.validateRequiredString(request, 'description', 'Description is required');
    if (descriptionError != null) {
      return descriptionError;
    }

    final transactionDateError = ValidationUtils.validateRequiredInt(request, 'transactionDate', 'Transaction date timestamp is required', min: 0);
    if (transactionDateError != null) {
      return transactionDateError;
    }

    return ValidationUtils.validateStatus(request);
  }
}