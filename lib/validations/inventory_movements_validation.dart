import 'package:store_management/models/model_enums.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class InventoryMovementsValidation {
  static Response? validateRead(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Inventory movement id is required');
  }

  static Response? validateCreate(Request request) => _validateCreateOrUpdate(request, requireId: false);

  static Response? validateUpdate(Request request) => _validateCreateOrUpdate(request, requireId: true);

  static Response? validateDelete(Request request) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    return ValidationUtils.validateRequiredInt(request, 'id', 'Inventory movement id is required');
  }

  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateCreateOrUpdate(Request request, {required bool requireId}) {
    final metadataError = ValidationUtils.validateRequestMetadata(request);
    if (metadataError != null) {
      return metadataError;
    }

    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Inventory movement id is required');
      if (idError != null) {
        return idError;
      }
    }

    final companyProductUuidError = ValidationUtils.validateRequiredUuid(request, 'companyProductUuid', 'Company product uuid reference must be a valid UUID');
    if (companyProductUuidError != null) {
      return companyProductUuidError;
    }

    final productUuidError = ValidationUtils.validateRequiredUuid(request, 'productUuid', 'Product uuid reference must be a valid UUID');
    if (productUuidError != null) {
      return productUuidError;
    }

    final movementTypeError = ValidationUtils.validateRequiredEnumString(request, 'movementType', 'Movement type must be a supported inventory movement value', (value) => InventoryMovementType.fromValue(value));
    if (movementTypeError != null) {
      return movementTypeError;
    }

    final quantityDelta = request.data?['quantityDelta'];
    if (quantityDelta is! int || quantityDelta == 0) {
      return ValidationUtils.badRequest('Quantity delta must be provided as a non-zero integer');
    }

    final balanceAfterError = ValidationUtils.validateRequiredInt(request, 'balanceAfter', 'Balance after must be provided as a non-negative integer', min: 0);
    if (balanceAfterError != null) {
      return balanceAfterError;
    }

    final unitCost = request.data?['unitCost'];
    if (unitCost != null) {
      final unitCostError = ValidationUtils.validateRequiredNum(request, 'unitCost', 'Unit cost must be provided as a non-negative number');
      if (unitCostError != null) {
        return unitCostError;
      }
    }

    final referenceTypeError = ValidationUtils.validateRequiredEnumString(request, 'referenceType', 'Reference type must be a supported inventory reference value', (value) => InventoryReferenceType.fromValue(value));
    if (referenceTypeError != null) {
      return referenceTypeError;
    }

    final referenceUuidError = ValidationUtils.validateOptionalUuid(request, 'referenceUuid', 'Reference uuid must be a valid UUID');
    if (referenceUuidError != null) {
      return referenceUuidError;
    }

    final inventoryHolderTypeError = ValidationUtils.validateOptionalEnumString(
      request,
      'inventoryHolderType',
      'Inventory holder type must be a supported inventory holder value',
      (value) => InventoryHolderType.fromValue(value),
    );
    if (inventoryHolderTypeError != null) {
      return inventoryHolderTypeError;
    }

    final inventoryHolderUuidError = ValidationUtils.validateOptionalUuid(request, 'inventoryHolderUuid', 'Inventory holder uuid must be a valid UUID');
    if (inventoryHolderUuidError != null) {
      return inventoryHolderUuidError;
    }

    final hasInventoryHolderType = request.data?['inventoryHolderType'] != null;
    final hasInventoryHolderUuid = request.data?['inventoryHolderUuid'] != null;
    if (hasInventoryHolderType != hasInventoryHolderUuid) {
      return ValidationUtils.badRequest('Inventory holder type and inventory holder uuid must be provided together');
    }

    final counterpartyHolderTypeError = ValidationUtils.validateOptionalEnumString(
      request,
      'counterpartyHolderType',
      'Counterparty holder type must be a supported inventory holder value',
      (value) => InventoryHolderType.fromValue(value),
    );
    if (counterpartyHolderTypeError != null) {
      return counterpartyHolderTypeError;
    }

    final counterpartyHolderUuidError = ValidationUtils.validateOptionalUuid(request, 'counterpartyHolderUuid', 'Counterparty holder uuid must be a valid UUID');
    if (counterpartyHolderUuidError != null) {
      return counterpartyHolderUuidError;
    }

    final hasCounterpartyHolderType = request.data?['counterpartyHolderType'] != null;
    final hasCounterpartyHolderUuid = request.data?['counterpartyHolderUuid'] != null;
    if (hasCounterpartyHolderType != hasCounterpartyHolderUuid) {
      return ValidationUtils.badRequest('Counterparty holder type and counterparty holder uuid must be provided together');
    }

    final transactionUuidError = ValidationUtils.validateOptionalUuid(request, 'transactionUuid', 'Transaction uuid must be a valid UUID');
    if (transactionUuidError != null) {
      return transactionUuidError;
    }

    final noteError = ValidationUtils.validateRequiredString(request, 'note', 'Inventory movement note is required');
    if (noteError != null) {
      return noteError;
    }

    return ValidationUtils.validateOptionalUuid(request, 'createdByUserUuid', 'Created-by user uuid must be a valid UUID');
  }
}
