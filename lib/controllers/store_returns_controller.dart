import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_return.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_returns_validation.dart';

class StoreReturnsController {
  StoreReturn? storeReturn;
  Request? request;
  Response? response;

  StoreReturnsController({this.storeReturn, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreReturnsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturn == null) {
        return ControllerUtils.notFound('Store return');
      }

      return Response(statusCode: 200, title: 'Return Fetched', message: 'The return has been fetched successfully', data: storeReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreReturnsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      storeReturn = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StoreReturn.fromMap,
      );

      return Response(statusCode: 201, title: 'Return Added', message: 'The return has been added successfully', data: storeReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreReturnsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturn == null) {
        return ControllerUtils.notFound('Store return');
      }

      storeReturn = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: storeReturn, toMap: (model) => model.toMap(), fromMap: StoreReturn.fromMap,
      );

      return Response(statusCode: 200, title: 'Return Updated', message: 'The return has been updated successfully', data: storeReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreReturnsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturn == null) {
        return ControllerUtils.notFound('Store return');
      }

      final deletedReturn = storeReturn;
      storeReturn = null;
      return Response(statusCode: 200, title: 'Return Deleted', message: 'The return has been deleted successfully', data: deletedReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreReturnsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final returns = storeReturn == null ? <StoreReturn>[] : <StoreReturn>[storeReturn!];
      return Response(statusCode: 200, title: 'Returns Fetched', message: 'The returns have been fetched successfully', data: returns);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}