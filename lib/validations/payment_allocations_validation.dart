import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class PaymentAllocationsValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Payment allocation id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Payment allocation id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Payment allocation id is required');
      if (idError != null) {
        return idError;
      }
    }

    final paymentVoucherUuidError = ValidationUtils.validateRequiredUuid(request, 'paymentVoucherUuid', 'Payment voucher uuid reference must be a valid UUID');
    if (paymentVoucherUuidError != null) {
      return paymentVoucherUuidError;
    }

    final invoiceUuidError = ValidationUtils.validateRequiredUuid(request, 'invoiceUuid', 'Invoice uuid reference must be a valid UUID');
    if (invoiceUuidError != null) {
      return invoiceUuidError;
    }

    final allocatedAmountError = ValidationUtils.validateRequiredNum(request, 'allocatedAmount', 'Allocated amount must be provided as a non-negative number');
    if (allocatedAmountError != null) {
      return allocatedAmountError;
    }

    final allocationDateError = ValidationUtils.validateRequiredInt(request, 'allocationDate', 'Allocation date must be provided as epoch milliseconds', min: 0);
    if (allocationDateError != null) {
      return allocationDateError;
    }

    return ValidationUtils.validateStatus(request);
  }
}
