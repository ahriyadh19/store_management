import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/inventory_transaction.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/inventory_transactions_validation.dart';

class InventoryTransactionsController {
  InventoryTransaction? inventoryTransaction;
  Request? request;
  Response? response;

  InventoryTransactionsController({this.inventoryTransaction, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = InventoryTransactionsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (inventoryTransaction == null || ControllerUtils.isSoftDeletedMap(inventoryTransaction!.toMap())) {
        return ControllerUtils.notFound('Inventory transaction');
      }

      return Response(statusCode: 200, title: 'Inventory Transaction Fetched', message: 'The inventory transaction has been fetched successfully', data: inventoryTransaction);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = InventoryTransactionsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      inventoryTransaction = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: InventoryTransaction.fromMap,
      );

      return Response(statusCode: 201, title: 'Inventory Transaction Added', message: 'The inventory transaction has been added successfully', data: inventoryTransaction);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = InventoryTransactionsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (inventoryTransaction == null || ControllerUtils.isSoftDeletedMap(inventoryTransaction!.toMap())) {
        return ControllerUtils.notFound('Inventory transaction');
      }

      inventoryTransaction = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: inventoryTransaction, toMap: (model) => model.toMap(), fromMap: InventoryTransaction.fromMap,
      );

      return Response(statusCode: 200, title: 'Inventory Transaction Updated', message: 'The inventory transaction has been updated successfully', data: inventoryTransaction);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = InventoryTransactionsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (inventoryTransaction == null || ControllerUtils.isSoftDeletedMap(inventoryTransaction!.toMap())) {
        return ControllerUtils.notFound('Inventory transaction');
      }

      final deletedInventoryTransaction = ControllerUtils.softDeleteModel(
        model: inventoryTransaction!,
        toMap: (model) => model.toMap(),
        fromMap: InventoryTransaction.fromMap,
      );
      inventoryTransaction = deletedInventoryTransaction;
      return Response(statusCode: 200, title: 'Inventory Transaction Deleted', message: 'The inventory transaction has been deleted successfully', data: deletedInventoryTransaction);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = InventoryTransactionsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final inventoryTransactions = inventoryTransaction == null || ControllerUtils.isSoftDeletedMap(inventoryTransaction!.toMap()) ? <InventoryTransaction>[] : <InventoryTransaction>[inventoryTransaction!];
      return Response(statusCode: 200, title: 'Inventory Transactions Fetched', message: 'The inventory transactions have been fetched successfully', data: inventoryTransactions);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
