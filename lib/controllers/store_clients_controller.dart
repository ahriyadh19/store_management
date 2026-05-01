import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_client.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_clients_validation.dart';

class StoreClientsController {
  StoreClient? storeClient;
  Request? request;
  Response? response;

  StoreClientsController({this.storeClient, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreClientsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeClient == null || ControllerUtils.isSoftDeletedMap(storeClient!.toMap())) {
        return ControllerUtils.notFound('Store client');
      }

      return Response(statusCode: 200, title: 'Store Client Fetched', message: 'The store client has been fetched successfully', data: storeClient);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreClientsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      storeClient = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StoreClient.fromMap,
      );

      return Response(statusCode: 201, title: 'Store Client Added', message: 'The store client has been added successfully', data: storeClient);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreClientsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeClient == null || ControllerUtils.isSoftDeletedMap(storeClient!.toMap())) {
        return ControllerUtils.notFound('Store client');
      }

      storeClient = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: storeClient, toMap: (model) => model.toMap(), fromMap: StoreClient.fromMap,
      );

      return Response(statusCode: 200, title: 'Store Client Updated', message: 'The store client has been updated successfully', data: storeClient);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreClientsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeClient == null || ControllerUtils.isSoftDeletedMap(storeClient!.toMap())) {
        return ControllerUtils.notFound('Store client');
      }

      final deletedStoreClient = ControllerUtils.softDeleteModel(
        model: storeClient!,
        toMap: (model) => model.toMap(),
        fromMap: StoreClient.fromMap,
      );
      storeClient = deletedStoreClient;
      return Response(statusCode: 200, title: 'Store Client Deleted', message: 'The store client has been deleted successfully', data: deletedStoreClient);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreClientsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final storeClients = storeClient == null || ControllerUtils.isSoftDeletedMap(storeClient!.toMap()) ? <StoreClient>[] : <StoreClient>[storeClient!];
      return Response(statusCode: 200, title: 'Store Clients Fetched', message: 'The store clients have been fetched successfully', data: storeClients);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
