import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/sales_return.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/sales_returns_validation.dart';

class SalesReturnsController {
  SalesReturn? salesReturn;
  Request? request;
  Response? response;

  SalesReturnsController({this.salesReturn, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = SalesReturnsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (salesReturn == null || ControllerUtils.isSoftDeletedMap(salesReturn!.toMap())) {
        return ControllerUtils.notFound('Sales return');
      }

      return Response(statusCode: 200, title: 'Sales Return Fetched', message: 'The sales return has been fetched successfully', data: salesReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = SalesReturnsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      salesReturn = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: SalesReturn.fromMap,
      );

      return Response(statusCode: 201, title: 'Sales Return Added', message: 'The sales return has been added successfully', data: salesReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = SalesReturnsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (salesReturn == null || ControllerUtils.isSoftDeletedMap(salesReturn!.toMap())) {
        return ControllerUtils.notFound('Sales return');
      }

      salesReturn = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: salesReturn, toMap: (model) => model.toMap(), fromMap: SalesReturn.fromMap,
      );

      return Response(statusCode: 200, title: 'Sales Return Updated', message: 'The sales return has been updated successfully', data: salesReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = SalesReturnsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (salesReturn == null || ControllerUtils.isSoftDeletedMap(salesReturn!.toMap())) {
        return ControllerUtils.notFound('Sales return');
      }

      final deletedSalesReturn = ControllerUtils.softDeleteModel(
        model: salesReturn!,
        toMap: (model) => model.toMap(),
        fromMap: SalesReturn.fromMap,
      );
      salesReturn = deletedSalesReturn;
      return Response(statusCode: 200, title: 'Sales Return Deleted', message: 'The sales return has been deleted successfully', data: deletedSalesReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = SalesReturnsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final salesReturns = salesReturn == null || ControllerUtils.isSoftDeletedMap(salesReturn!.toMap()) ? <SalesReturn>[] : <SalesReturn>[salesReturn!];
      return Response(statusCode: 200, title: 'Sales Returns Fetched', message: 'The sales returns have been fetched successfully', data: salesReturns);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
