import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/sales_order.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/sales_orders_validation.dart';

class SalesOrdersController {
  SalesOrder? salesOrder;
  Request? request;
  Response? response;

  SalesOrdersController({this.salesOrder, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = SalesOrdersValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (salesOrder == null || ControllerUtils.isSoftDeletedMap(salesOrder!.toMap())) {
        return ControllerUtils.notFound('Sales order');
      }

      return Response(statusCode: 200, title: 'Sales Order Fetched', message: 'The sales order has been fetched successfully', data: salesOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = SalesOrdersValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      salesOrder = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: SalesOrder.fromMap,
      );

      return Response(statusCode: 201, title: 'Sales Order Added', message: 'The sales order has been added successfully', data: salesOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = SalesOrdersValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (salesOrder == null || ControllerUtils.isSoftDeletedMap(salesOrder!.toMap())) {
        return ControllerUtils.notFound('Sales order');
      }

      salesOrder = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: salesOrder, toMap: (model) => model.toMap(), fromMap: SalesOrder.fromMap,
      );

      return Response(statusCode: 200, title: 'Sales Order Updated', message: 'The sales order has been updated successfully', data: salesOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = SalesOrdersValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (salesOrder == null || ControllerUtils.isSoftDeletedMap(salesOrder!.toMap())) {
        return ControllerUtils.notFound('Sales order');
      }

      final deletedSalesOrder = ControllerUtils.softDeleteModel(
        model: salesOrder!,
        toMap: (model) => model.toMap(),
        fromMap: SalesOrder.fromMap,
      );
      salesOrder = deletedSalesOrder;
      return Response(statusCode: 200, title: 'Sales Order Deleted', message: 'The sales order has been deleted successfully', data: deletedSalesOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = SalesOrdersValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final salesOrders = salesOrder == null || ControllerUtils.isSoftDeletedMap(salesOrder!.toMap()) ? <SalesOrder>[] : <SalesOrder>[salesOrder!];
      return Response(statusCode: 200, title: 'Sales Orders Fetched', message: 'The sales orders have been fetched successfully', data: salesOrders);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
