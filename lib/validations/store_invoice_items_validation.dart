import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class StoreInvoiceItemsValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Store invoice item id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Store invoice item id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Store invoice item id is required');
      if (idError != null) {
        return idError;
      }
    }

    final invoiceUuidError = ValidationUtils.validateRequiredUuid(request, 'invoiceUuid', 'Invoice uuid reference must be a valid UUID');
    if (invoiceUuidError != null) {
      return invoiceUuidError;
    }

    final supplierProductUuidError = ValidationUtils.validateRequiredUuid(request, 'supplierProductUuid', 'Supplier product uuid reference must be a valid UUID');
    if (supplierProductUuidError != null) {
      return supplierProductUuidError;
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

    final discountAmountError = ValidationUtils.validateRequiredNum(request, 'discountAmount', 'Discount amount must be provided as a non-negative number');
    if (discountAmountError != null) {
      return discountAmountError;
    }

    final taxAmountError = ValidationUtils.validateRequiredNum(request, 'taxAmount', 'Tax amount must be provided as a non-negative number');
    if (taxAmountError != null) {
      return taxAmountError;
    }

    final lineTotalError = ValidationUtils.validateRequiredNum(request, 'lineTotal', 'Line total must be provided as a non-negative number');
    if (lineTotalError != null) {
      return lineTotalError;
    }

    return ValidationUtils.validateStatus(request);
  }
}
