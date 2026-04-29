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

      if (storeClient == null) {
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

      final now = DateTime.now();
      storeClient = StoreClient(
        id: (request.data?['id'] as int?) ?? 0,
        storeUuid: request.data!['storeUuid'] as String,
        clientUuid: request.data!['clientUuid'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
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

      if (storeClient == null) {
        return ControllerUtils.notFound('Store client');
      }

      storeClient = storeClient?.copyWith(
        id: request.data!['id'] as int,
        storeUuid: request.data!['storeUuid'] as String,
        clientUuid: request.data!['clientUuid'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
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

      if (storeClient == null) {
        return ControllerUtils.notFound('Store client');
      }

      final deletedStoreClient = storeClient;
      storeClient = null;
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

      final storeClients = storeClient == null ? <StoreClient>[] : <StoreClient>[storeClient!];
      return Response(statusCode: 200, title: 'Store Clients Fetched', message: 'The store clients have been fetched successfully', data: storeClients);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
