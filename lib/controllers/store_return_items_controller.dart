import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_return_item.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_return_items_validation.dart';

class StoreReturnItemsController {
  StoreReturnItem? storeReturnItem;
  Request? request;
  Response? response;

  StoreReturnItemsController({this.storeReturnItem, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreReturnItemsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturnItem == null || ControllerUtils.isSoftDeletedMap(storeReturnItem!.toMap())) {
        return ControllerUtils.notFound('Store return item');
      }

      return Response(statusCode: 200, title: 'Store Return Item Fetched', message: 'The store return item has been fetched successfully', data: storeReturnItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreReturnItemsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      storeReturnItem = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StoreReturnItem.fromMap,
      );

      return Response(statusCode: 201, title: 'Store Return Item Added', message: 'The store return item has been added successfully', data: storeReturnItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreReturnItemsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturnItem == null || ControllerUtils.isSoftDeletedMap(storeReturnItem!.toMap())) {
        return ControllerUtils.notFound('Store return item');
      }

      storeReturnItem = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: storeReturnItem, toMap: (model) => model.toMap(), fromMap: StoreReturnItem.fromMap,
      );

      return Response(statusCode: 200, title: 'Store Return Item Updated', message: 'The store return item has been updated successfully', data: storeReturnItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreReturnItemsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturnItem == null || ControllerUtils.isSoftDeletedMap(storeReturnItem!.toMap())) {
        return ControllerUtils.notFound('Store return item');
      }

      final deletedStoreReturnItem = ControllerUtils.softDeleteModel(
        model: storeReturnItem!,
        toMap: (model) => model.toMap(),
        fromMap: StoreReturnItem.fromMap,
      );
      storeReturnItem = deletedStoreReturnItem;
      return Response(statusCode: 200, title: 'Store Return Item Deleted', message: 'The store return item has been deleted successfully', data: deletedStoreReturnItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreReturnItemsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final storeReturnItems = storeReturnItem == null || ControllerUtils.isSoftDeletedMap(storeReturnItem!.toMap()) ? <StoreReturnItem>[] : <StoreReturnItem>[storeReturnItem!];
      return Response(statusCode: 200, title: 'Store Return Items Fetched', message: 'The store return items have been fetched successfully', data: storeReturnItems);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
