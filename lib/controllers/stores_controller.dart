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

      if (store == null) {
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

      store = Store(
        id: (request.data?['id'] as int?) ?? 0,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        address: request.data!['address'] as String,
        phone: request.data!['phone'] as String,
        email: request.data!['email'] as String,
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

      if (store == null) {
        return ControllerUtils.notFound('Store');
      }

      store = store?.copyWith(
        id: request.data!['id'] as int,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        address: request.data!['address'] as String,
        phone: request.data!['phone'] as String,
        email: request.data!['email'] as String,
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

      if (store == null) {
        return ControllerUtils.notFound('Store');
      }

      final deletedStore = store;
      store = null;
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

      final stores = store == null ? <Store>[] : <Store>[store!];
      return Response(statusCode: 200, title: 'Stores Fetched', message: 'The stores have been fetched successfully', data: stores);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
