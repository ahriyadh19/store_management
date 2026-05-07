import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class PurchaseOrderItemsValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Purchase order item id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Purchase order item id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Purchase order item id is required');
      if (idError != null) {
        return idError;
      }
    }

    final purchaseOrderUuidError = ValidationUtils.validateRequiredUuid(request, 'purchaseOrderUuid', 'Purchase order uuid must be a valid UUID');
    if (purchaseOrderUuidError != null) {
      return purchaseOrderUuidError;
    }

    final productUuidError = ValidationUtils.validateRequiredUuid(request, 'productUuid', 'Product uuid must be a valid UUID');
    if (productUuidError != null) {
      return productUuidError;
    }

    final supplierProductOfferUuidError = ValidationUtils.validateOptionalUuid(request, 'supplierProductOfferUuid', 'Supplier product offer uuid must be a valid UUID');
    if (supplierProductOfferUuidError != null) {
      return supplierProductOfferUuidError;
    }

    final quantityError = ValidationUtils.validateRequiredInt(request, 'quantity', 'Quantity must be greater than zero', min: 1);
    if (quantityError != null) {
      return quantityError;
    }

    final unitCostError = ValidationUtils.validateRequiredNum(request, 'unitCost', 'Unit cost must be zero or greater', min: 0);
    if (unitCostError != null) {
      return unitCostError;
    }

    final discountAmount = request.data?['discountAmount'];
    if (discountAmount != null && (discountAmount is! num || discountAmount < 0)) {
      return ValidationUtils.badRequest('Discount amount must be zero or greater');
    }

    final lineTotalError = ValidationUtils.validateRequiredNum(request, 'lineTotal', 'Line total must be zero or greater', min: 0);
    if (lineTotalError != null) {
      return lineTotalError;
    }

    final receivedQuantityError = ValidationUtils.validateOptionalInt(request, 'receivedQuantity', 'Received quantity must be zero or greater', min: 0);
    if (receivedQuantityError != null) {
      return receivedQuantityError;
    }

    final quantity = request.data?['quantity'] as int;
    final receivedQuantity = request.data?['receivedQuantity'];
    if (receivedQuantity is int && receivedQuantity > quantity) {
      return ValidationUtils.badRequest('Received quantity cannot exceed ordered quantity');
    }

    return null;
  }
}
