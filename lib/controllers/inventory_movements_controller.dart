import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/inventory_movement.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/inventory_movements_validation.dart';

class InventoryMovementsController {
  InventoryMovement? inventoryMovement;
  Request? request;
  Response? response;

  InventoryMovementsController({this.inventoryMovement, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = InventoryMovementsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (inventoryMovement == null) {
        return ControllerUtils.notFound('Inventory movement');
      }

      return Response(statusCode: 200, title: 'Inventory Movement Fetched', message: 'The inventory movement has been fetched successfully', data: inventoryMovement);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = InventoryMovementsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      inventoryMovement = InventoryMovement(
        id: (request.data?['id'] as int?) ?? 0,
        companyProductUuid: request.data!['companyProductUuid'] as String,
        productUuid: request.data!['productUuid'] as String,
        movementType: InventoryMovementType.fromValue(request.data!['movementType'] as String),
        quantityDelta: request.data!['quantityDelta'] as int,
        balanceAfter: request.data!['balanceAfter'] as int,
        unitCost: ModelParsing.decimalOrNull(request.data!['unitCost']),
        referenceType: InventoryReferenceType.fromValue(request.data!['referenceType'] as String),
        referenceUuid: request.data?['referenceUuid'] as String?,
        note: request.data!['note'] as String,
        createdByUserUuid: request.data?['createdByUserUuid'] as String?,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Inventory Movement Added', message: 'The inventory movement has been added successfully', data: inventoryMovement);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = InventoryMovementsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (inventoryMovement == null) {
        return ControllerUtils.notFound('Inventory movement');
      }

      inventoryMovement = inventoryMovement?.copyWith(
        id: request.data!['id'] as int,
        companyProductUuid: request.data!['companyProductUuid'] as String,
        productUuid: request.data!['productUuid'] as String,
        movementType: InventoryMovementType.fromValue(request.data!['movementType'] as String),
        quantityDelta: request.data!['quantityDelta'] as int,
        balanceAfter: request.data!['balanceAfter'] as int,
        unitCost: ModelParsing.decimalOrNull(request.data!['unitCost']),
        referenceType: InventoryReferenceType.fromValue(request.data!['referenceType'] as String),
        referenceUuid: request.data?['referenceUuid'] as String?,
        note: request.data!['note'] as String,
        createdByUserUuid: request.data?['createdByUserUuid'] as String?,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Inventory Movement Updated', message: 'The inventory movement has been updated successfully', data: inventoryMovement);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = InventoryMovementsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (inventoryMovement == null) {
        return ControllerUtils.notFound('Inventory movement');
      }

      final deletedInventoryMovement = inventoryMovement;
      inventoryMovement = null;
      return Response(statusCode: 200, title: 'Inventory Movement Deleted', message: 'The inventory movement has been deleted successfully', data: deletedInventoryMovement);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = InventoryMovementsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final inventoryMovements = inventoryMovement == null ? <InventoryMovement>[] : <InventoryMovement>[inventoryMovement!];
      return Response(statusCode: 200, title: 'Inventory Movements Fetched', message: 'The inventory movements have been fetched successfully', data: inventoryMovements);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
