import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/inventory_movement.dart';
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

      if (inventoryMovement == null || ControllerUtils.isSoftDeletedMap(inventoryMovement!.toMap())) {
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

      inventoryMovement = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: InventoryMovement.fromMap,
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

      if (inventoryMovement == null || ControllerUtils.isSoftDeletedMap(inventoryMovement!.toMap())) {
        return ControllerUtils.notFound('Inventory movement');
      }

      inventoryMovement = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: inventoryMovement, toMap: (model) => model.toMap(), fromMap: InventoryMovement.fromMap,
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

      if (inventoryMovement == null || ControllerUtils.isSoftDeletedMap(inventoryMovement!.toMap())) {
        return ControllerUtils.notFound('Inventory movement');
      }

      final deletedInventoryMovement = ControllerUtils.softDeleteModel(
        model: inventoryMovement!,
        toMap: (model) => model.toMap(),
        fromMap: InventoryMovement.fromMap,
      );
      inventoryMovement = deletedInventoryMovement;
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

      final inventoryMovements = inventoryMovement == null || ControllerUtils.isSoftDeletedMap(inventoryMovement!.toMap()) ? <InventoryMovement>[] : <InventoryMovement>[inventoryMovement!];
      return Response(statusCode: 200, title: 'Inventory Movements Fetched', message: 'The inventory movements have been fetched successfully', data: inventoryMovements);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
