import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_invoice.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_invoices_validation.dart';

class StoreInvoicesController {
  StoreInvoice? invoice;
  Request? request;
  Response? response;

  StoreInvoicesController({this.invoice, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreInvoicesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (invoice == null) {
        return ControllerUtils.notFound('Store invoice');
      }

      return Response(statusCode: 200, title: 'Invoice Fetched', message: 'The invoice has been fetched successfully', data: invoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreInvoicesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      invoice = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StoreInvoice.fromMap,
      );

      return Response(statusCode: 201, title: 'Invoice Added', message: 'The invoice has been added successfully', data: invoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreInvoicesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (invoice == null) {
        return ControllerUtils.notFound('Store invoice');
      }

      invoice = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: invoice, toMap: (model) => model.toMap(), fromMap: StoreInvoice.fromMap,
      );

      return Response(statusCode: 200, title: 'Invoice Updated', message: 'The invoice has been updated successfully', data: invoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreInvoicesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (invoice == null) {
        return ControllerUtils.notFound('Store invoice');
      }

      final deletedInvoice = invoice;
      invoice = null;
      return Response(statusCode: 200, title: 'Invoice Deleted', message: 'The invoice has been deleted successfully', data: deletedInvoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreInvoicesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final invoices = invoice == null ? <StoreInvoice>[] : <StoreInvoice>[invoice!];
      return Response(statusCode: 200, title: 'Invoices Fetched', message: 'The invoices have been fetched successfully', data: invoices);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}