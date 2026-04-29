import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class StoreReturnItemsValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Store return item id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Store return item id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Store return item id is required');
      if (idError != null) {
        return idError;
      }
    }

    final returnUuidError = ValidationUtils.validateRequiredUuid(request, 'returnUuid', 'Return uuid reference must be a valid UUID');
    if (returnUuidError != null) {
      return returnUuidError;
    }

    final invoiceItemUuidError = ValidationUtils.validateOptionalUuid(request, 'invoiceItemUuid', 'Invoice item uuid reference must be a valid UUID');
    if (invoiceItemUuidError != null) {
      return invoiceItemUuidError;
    }

    final companyProductUuidError = ValidationUtils.validateRequiredUuid(request, 'companyProductUuid', 'Company product uuid reference must be a valid UUID');
    if (companyProductUuidError != null) {
      return companyProductUuidError;
    }

    final productUuidError = ValidationUtils.validateRequiredUuid(request, 'productUuid', 'Product uuid reference must be a valid UUID');
    if (productUuidError != null) {
      return productUuidError;
    }

    final quantityError = ValidationUtils.validateRequiredInt(request, 'quantity', 'Quantity must be provided as a positive integer');
    if (quantityError != null) {
      return quantityError;
    }

    final unitPriceError = ValidationUtils.validateRequiredNum(request, 'unitPrice', 'Unit price must be provided as a non-negative number');
    if (unitPriceError != null) {
      return unitPriceError;
    }

    final lineTotalError = ValidationUtils.validateRequiredNum(request, 'lineTotal', 'Line total must be provided as a non-negative number');
    if (lineTotalError != null) {
      return lineTotalError;
    }

    final reasonError = ValidationUtils.validateRequiredString(request, 'reason', 'Return reason is required');
    if (reasonError != null) {
      return reasonError;
    }

    return ValidationUtils.validateStatus(request);
  }
}
