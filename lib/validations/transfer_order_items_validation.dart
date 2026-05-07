import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class TransferOrderItemsValidation {
  static Response? validateRead(Request request) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    return ValidationUtils.validateRequiredInt(request, 'id', 'Transfer order item id is required');
  }

  static Response? validateCreate(Request request) => _validateUpsert(request, requireId: false);
  static Response? validateUpdate(Request request) => _validateUpsert(request, requireId: true);
  static Response? validateDelete(Request request) => validateRead(request);
  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateUpsert(Request request, {required bool requireId}) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Transfer order item id is required');
      if (idError != null) return idError;
    }
    final order = ValidationUtils.validateRequiredUuid(request, 'transferOrderUuid', 'Transfer order uuid must be a valid UUID');
    if (order != null) return order;
    final product = ValidationUtils.validateRequiredUuid(request, 'productUuid', 'Product uuid must be a valid UUID');
    if (product != null) return product;
    final qty = ValidationUtils.validateRequiredInt(request, 'quantity', 'Quantity must be greater than zero', min: 1);
    if (qty != null) return qty;
    final shipped = ValidationUtils.validateOptionalInt(request, 'shippedQuantity', 'Shipped quantity must be zero or greater', min: 0);
    if (shipped != null) return shipped;
    final received = ValidationUtils.validateOptionalInt(request, 'receivedQuantity', 'Received quantity must be zero or greater', min: 0);
    if (received != null) return received;
    return null;
  }
}
