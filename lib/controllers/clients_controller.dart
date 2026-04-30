import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/client.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/clients_validation.dart';

class ClientsController {
  Client? client;
  Request? request;
  Response? response;

  ClientsController({this.client, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = ClientsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (client == null) {
        return ControllerUtils.notFound('Client');
      }

      return Response(statusCode: 200, title: 'Client Fetched', message: 'The client has been fetched successfully', data: client);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = ClientsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      client = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: Client.fromMap,
      );

      return Response(statusCode: 201, title: 'Client Added', message: 'The client has been added successfully', data: client);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = ClientsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (client == null) {
        return ControllerUtils.notFound('Client');
      }

      client = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: client, toMap: (model) => model.toMap(), fromMap: Client.fromMap,
      );

      return Response(statusCode: 200, title: 'Client Updated', message: 'The client has been updated successfully', data: client);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = ClientsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (client == null) {
        return ControllerUtils.notFound('Client');
      }

      final deletedClient = client;
      client = null;
      return Response(statusCode: 200, title: 'Client Deleted', message: 'The client has been deleted successfully', data: deletedClient);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = ClientsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final clients = client == null ? <Client>[] : <Client>[client!];
      return Response(statusCode: 200, title: 'Clients Fetched', message: 'The clients have been fetched successfully', data: clients);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
