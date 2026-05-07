import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class InventoryTransactionsValidation {
  static const Set<String> _allowedHolderTypes = <String>{'store', 'branch'};
  static const Set<String> _allowedTransactionTypes = <String>{
    'in',
    'out',
    'transfer_out',
    'transfer_in',
    'adjustment',
    'sale',
    'sale_return',
    'purchase',
    'supplier_return',
  };

  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Inventory transaction id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Inventory transaction id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Inventory transaction id is required');
      if (idError != null) {
        return idError;
      }
    }

    final ownerUuidError = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (ownerUuidError != null) {
      return ownerUuidError;
    }

    final productUuidError = ValidationUtils.validateRequiredUuid(request, 'productUuid', 'Product uuid must be a valid UUID');
    if (productUuidError != null) {
      return productUuidError;
    }

    final batchUuidError = ValidationUtils.validateOptionalUuid(request, 'batchUuid', 'Batch uuid must be a valid UUID');
    if (batchUuidError != null) {
      return batchUuidError;
    }

    final holderTypeError = ValidationUtils.validateRequiredString(request, 'holderType', 'Holder type is required');
    if (holderTypeError != null) {
      return holderTypeError;
    }

    final holderType = (request.data?['holderType'] as String).trim().toLowerCase();
    if (!_allowedHolderTypes.contains(holderType)) {
      return ValidationUtils.badRequest('Holder type is invalid');
    }

    final holderUuidError = ValidationUtils.validateRequiredUuid(request, 'holderUuid', 'Holder uuid must be a valid UUID');
    if (holderUuidError != null) {
      return holderUuidError;
    }

    final transactionTypeError = ValidationUtils.validateRequiredString(request, 'transactionType', 'Transaction type is required');
    if (transactionTypeError != null) {
      return transactionTypeError;
    }

    final transactionType = (request.data?['transactionType'] as String).trim().toLowerCase();
    if (!_allowedTransactionTypes.contains(transactionType)) {
      return ValidationUtils.badRequest('Transaction type is invalid');
    }

    final quantityError = ValidationUtils.validateRequiredInt(request, 'quantity', 'Quantity is required', min: -9223372036854775807);
    if (quantityError != null) {
      return quantityError;
    }

    final quantity = request.data?['quantity'] as int;
    if (quantity == 0) {
      return ValidationUtils.badRequest('Quantity cannot be zero');
    }

    final unitCost = request.data?['unitCost'];
    if (unitCost != null && (unitCost is! num || unitCost < 0)) {
      return ValidationUtils.badRequest('Unit cost must be zero or greater');
    }

    final unitPrice = request.data?['unitPrice'];
    if (unitPrice != null && (unitPrice is! num || unitPrice < 0)) {
      return ValidationUtils.badRequest('Unit price must be zero or greater');
    }

    final referenceTypeError = ValidationUtils.validateRequiredString(request, 'referenceType', 'Reference type is required');
    if (referenceTypeError != null) {
      return referenceTypeError;
    }

    final referenceUuidError = ValidationUtils.validateOptionalUuid(request, 'referenceUuid', 'Reference uuid must be a valid UUID');
    if (referenceUuidError != null) {
      return referenceUuidError;
    }

    final linkedUuidError = ValidationUtils.validateOptionalUuid(request, 'linkedTransactionUuid', 'Linked transaction uuid must be a valid UUID');
    if (linkedUuidError != null) {
      return linkedUuidError;
    }

    final staffUuidError = ValidationUtils.validateOptionalUuid(request, 'staffUserUuid', 'Staff user uuid must be a valid UUID');
    if (staffUuidError != null) {
      return staffUuidError;
    }

    final occurredAtError = ValidationUtils.validateRequiredInt(request, 'occurredAt', 'Occurred at timestamp is required', min: 0);
    if (occurredAtError != null) {
      return occurredAtError;
    }

    final noteError = ValidationUtils.validateRequiredString(request, 'note', 'Transaction note is required');
    if (noteError != null) {
      return noteError;
    }

    return null;
  }
}
