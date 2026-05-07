import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class BranchProductsValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Branch product id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Branch product id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Branch product id is required');
      if (idError != null) {
        return idError;
      }
    }

    final branchUuidError = ValidationUtils.validateRequiredUuid(request, 'branchUuid', 'Branch uuid reference must be a valid UUID');
    if (branchUuidError != null) {
      return branchUuidError;
    }

    final supplierProductUuidError = ValidationUtils.validateRequiredUuid(
      request,
      'supplierProductUuid',
      'Supplier product uuid reference must be a valid UUID',
    );
    if (supplierProductUuidError != null) {
      return supplierProductUuidError;
    }

    final productUuidError = ValidationUtils.validateRequiredUuid(request, 'productUuid', 'Product uuid reference must be a valid UUID');
    if (productUuidError != null) {
      return productUuidError;
    }

    final stockError = ValidationUtils.validateRequiredInt(request, 'stock', 'Stock must be provided as a non-negative integer', min: 0);
    if (stockError != null) {
      return stockError;
    }

    final reservedQuantityError = ValidationUtils.validateOptionalInt(
      request,
      'reservedQuantity',
      'Reserved quantity must be provided as a non-negative integer',
      min: 0,
    );
    if (reservedQuantityError != null) {
      return reservedQuantityError;
    }

    final reorderLevelError = ValidationUtils.validateOptionalInt(request, 'reorderLevel', 'Reorder level must be provided as a non-negative integer', min: 0);
    if (reorderLevelError != null) {
      return reorderLevelError;
    }

    final lastMovementAtError = ValidationUtils.validateOptionalInt(
      request,
      'lastMovementAt',
      'Last movement timestamp must be provided as epoch milliseconds',
      min: 0,
    );
    if (lastMovementAtError != null) {
      return lastMovementAtError;
    }

    return ValidationUtils.validateStatus(request);
  }
}
