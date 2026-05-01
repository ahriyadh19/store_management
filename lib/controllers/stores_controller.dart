import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/stores_validation.dart';

class StoresController {
  Store? store;
  Request? request;
  Response? response;

  StoresController({this.store, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoresValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (store == null || ControllerUtils.isSoftDeletedMap(store!.toMap())) {
        return ControllerUtils.notFound('Store');
      }

      return Response(statusCode: 200, title: 'Store Fetched', message: 'The store has been fetched successfully', data: store);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoresValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      store = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: Store.fromMap,
      );

      return Response(statusCode: 201, title: 'Store Added', message: 'The store has been added successfully', data: store);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoresValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (store == null || ControllerUtils.isSoftDeletedMap(store!.toMap())) {
        return ControllerUtils.notFound('Store');
      }

      store = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: store, toMap: (model) => model.toMap(), fromMap: Store.fromMap,
      );

      return Response(statusCode: 200, title: 'Store Updated', message: 'The store has been updated successfully', data: store);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoresValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (store == null || ControllerUtils.isSoftDeletedMap(store!.toMap())) {
        return ControllerUtils.notFound('Store');
      }

      final deletedStore = ControllerUtils.softDeleteModel(
        model: store!,
        toMap: (model) => model.toMap(),
        fromMap: Store.fromMap,
      );
      store = deletedStore;
      return Response(statusCode: 200, title: 'Store Deleted', message: 'The store has been deleted successfully', data: deletedStore);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoresValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final stores = store == null || ControllerUtils.isSoftDeletedMap(store!.toMap()) ? <Store>[] : <Store>[store!];
      return Response(statusCode: 200, title: 'Stores Fetched', message: 'The stores have been fetched successfully', data: stores);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
