import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/sales_invoice.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/sales_invoices_validation.dart';

class SalesInvoicesController {
  SalesInvoice? salesInvoice;
  Request? request;
  Response? response;

  SalesInvoicesController({this.salesInvoice, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = SalesInvoicesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (salesInvoice == null || ControllerUtils.isSoftDeletedMap(salesInvoice!.toMap())) {
        return ControllerUtils.notFound('Sales invoice');
      }

      return Response(statusCode: 200, title: 'Sales Invoice Fetched', message: 'The sales invoice has been fetched successfully', data: salesInvoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = SalesInvoicesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      salesInvoice = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: SalesInvoice.fromMap,
      );

      return Response(statusCode: 201, title: 'Sales Invoice Added', message: 'The sales invoice has been added successfully', data: salesInvoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = SalesInvoicesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (salesInvoice == null || ControllerUtils.isSoftDeletedMap(salesInvoice!.toMap())) {
        return ControllerUtils.notFound('Sales invoice');
      }

      salesInvoice = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: salesInvoice, toMap: (model) => model.toMap(), fromMap: SalesInvoice.fromMap,
      );

      return Response(statusCode: 200, title: 'Sales Invoice Updated', message: 'The sales invoice has been updated successfully', data: salesInvoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = SalesInvoicesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (salesInvoice == null || ControllerUtils.isSoftDeletedMap(salesInvoice!.toMap())) {
        return ControllerUtils.notFound('Sales invoice');
      }

      final deletedSalesInvoice = ControllerUtils.softDeleteModel(
        model: salesInvoice!,
        toMap: (model) => model.toMap(),
        fromMap: SalesInvoice.fromMap,
      );
      salesInvoice = deletedSalesInvoice;
      return Response(statusCode: 200, title: 'Sales Invoice Deleted', message: 'The sales invoice has been deleted successfully', data: deletedSalesInvoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = SalesInvoicesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final salesInvoices = salesInvoice == null || ControllerUtils.isSoftDeletedMap(salesInvoice!.toMap()) ? <SalesInvoice>[] : <SalesInvoice>[salesInvoice!];
      return Response(statusCode: 200, title: 'Sales Invoices Fetched', message: 'The sales invoices have been fetched successfully', data: salesInvoices);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
