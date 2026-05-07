import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/inventory_batch.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/inventory_batches_validation.dart';

class InventoryBatchesController {
  InventoryBatch? inventoryBatch;
  Request? request;
  Response? response;

  InventoryBatchesController({this.inventoryBatch, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = InventoryBatchesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (inventoryBatch == null || ControllerUtils.isSoftDeletedMap(inventoryBatch!.toMap())) {
        return ControllerUtils.notFound('Inventory batch');
      }

      return Response(statusCode: 200, title: 'Inventory Batch Fetched', message: 'The inventory batch has been fetched successfully', data: inventoryBatch);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = InventoryBatchesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      inventoryBatch = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: InventoryBatch.fromMap,
      );

      return Response(statusCode: 201, title: 'Inventory Batch Added', message: 'The inventory batch has been added successfully', data: inventoryBatch);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = InventoryBatchesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (inventoryBatch == null || ControllerUtils.isSoftDeletedMap(inventoryBatch!.toMap())) {
        return ControllerUtils.notFound('Inventory batch');
      }

      inventoryBatch = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: inventoryBatch, toMap: (model) => model.toMap(), fromMap: InventoryBatch.fromMap,
      );

      return Response(statusCode: 200, title: 'Inventory Batch Updated', message: 'The inventory batch has been updated successfully', data: inventoryBatch);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = InventoryBatchesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (inventoryBatch == null || ControllerUtils.isSoftDeletedMap(inventoryBatch!.toMap())) {
        return ControllerUtils.notFound('Inventory batch');
      }

      final deletedInventoryBatch = ControllerUtils.softDeleteModel(
        model: inventoryBatch!,
        toMap: (model) => model.toMap(),
        fromMap: InventoryBatch.fromMap,
      );
      inventoryBatch = deletedInventoryBatch;
      return Response(statusCode: 200, title: 'Inventory Batch Deleted', message: 'The inventory batch has been deleted successfully', data: deletedInventoryBatch);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = InventoryBatchesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final inventoryBatches = inventoryBatch == null || ControllerUtils.isSoftDeletedMap(inventoryBatch!.toMap()) ? <InventoryBatch>[] : <InventoryBatch>[inventoryBatch!];
      return Response(statusCode: 200, title: 'Inventory Batches Fetched', message: 'The inventory batches have been fetched successfully', data: inventoryBatches);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
