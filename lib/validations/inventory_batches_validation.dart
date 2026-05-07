import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class InventoryBatchesValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Inventory batch id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Inventory batch id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Inventory batch id is required');
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

    final supplierUuidError = ValidationUtils.validateOptionalUuid(request, 'supplierUuid', 'Supplier uuid must be a valid UUID');
    if (supplierUuidError != null) {
      return supplierUuidError;
    }

    final productUuidError = ValidationUtils.validateRequiredUuid(request, 'productUuid', 'Product uuid must be a valid UUID');
    if (productUuidError != null) {
      return productUuidError;
    }

    final supplierInvoiceUuidError = ValidationUtils.validateOptionalUuid(request, 'supplierInvoiceUuid', 'Supplier invoice uuid must be a valid UUID');
    if (supplierInvoiceUuidError != null) {
      return supplierInvoiceUuidError;
    }

    final receivedAtError = ValidationUtils.validateRequiredInt(request, 'receivedAt', 'Received date timestamp is required', min: 0);
    if (receivedAtError != null) {
      return receivedAtError;
    }

    final expiryDateError = ValidationUtils.validateOptionalInt(request, 'expiryDate', 'Expiry date must be a non-negative timestamp', min: 0);
    if (expiryDateError != null) {
      return expiryDateError;
    }

    final unitCostError = ValidationUtils.validateRequiredNum(request, 'unitCost', 'Unit cost must be zero or greater', min: 0);
    if (unitCostError != null) {
      return unitCostError;
    }

    final initialQuantityError = ValidationUtils.validateRequiredInt(request, 'initialQuantity', 'Initial quantity must be greater than zero', min: 1);
    if (initialQuantityError != null) {
      return initialQuantityError;
    }

    final remainingQuantityError = ValidationUtils.validateRequiredInt(request, 'remainingQuantity', 'Remaining quantity must be zero or greater', min: 0);
    if (remainingQuantityError != null) {
      return remainingQuantityError;
    }

    final statusError = ValidationUtils.validateStatus(request);
    if (statusError != null) {
      return statusError;
    }

    final initialQuantity = request.data?['initialQuantity'] as int;
    final remainingQuantity = request.data?['remainingQuantity'] as int;
    if (remainingQuantity > initialQuantity) {
      return ValidationUtils.badRequest('Remaining quantity cannot exceed initial quantity');
    }

    return null;
  }
}
