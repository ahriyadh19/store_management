import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/supplier_invoice.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/supplier_invoices_validation.dart';

class SupplierInvoicesController {
  SupplierInvoice? supplierInvoice;
  Request? request;
  Response? response;

  SupplierInvoicesController({this.supplierInvoice, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = SupplierInvoicesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (supplierInvoice == null || ControllerUtils.isSoftDeletedMap(supplierInvoice!.toMap())) {
        return ControllerUtils.notFound('Supplier invoice');
      }

      return Response(statusCode: 200, title: 'Supplier Invoice Fetched', message: 'The supplier invoice has been fetched successfully', data: supplierInvoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = SupplierInvoicesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      supplierInvoice = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: SupplierInvoice.fromMap,
      );

      return Response(statusCode: 201, title: 'Supplier Invoice Added', message: 'The supplier invoice has been added successfully', data: supplierInvoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = SupplierInvoicesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (supplierInvoice == null || ControllerUtils.isSoftDeletedMap(supplierInvoice!.toMap())) {
        return ControllerUtils.notFound('Supplier invoice');
      }

      supplierInvoice = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: supplierInvoice, toMap: (model) => model.toMap(), fromMap: SupplierInvoice.fromMap,
      );

      return Response(statusCode: 200, title: 'Supplier Invoice Updated', message: 'The supplier invoice has been updated successfully', data: supplierInvoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = SupplierInvoicesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (supplierInvoice == null || ControllerUtils.isSoftDeletedMap(supplierInvoice!.toMap())) {
        return ControllerUtils.notFound('Supplier invoice');
      }

      final deletedSupplierInvoice = ControllerUtils.softDeleteModel(
        model: supplierInvoice!,
        toMap: (model) => model.toMap(),
        fromMap: SupplierInvoice.fromMap,
      );
      supplierInvoice = deletedSupplierInvoice;
      return Response(statusCode: 200, title: 'Supplier Invoice Deleted', message: 'The supplier invoice has been deleted successfully', data: deletedSupplierInvoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = SupplierInvoicesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final supplierInvoices = supplierInvoice == null || ControllerUtils.isSoftDeletedMap(supplierInvoice!.toMap()) ? <SupplierInvoice>[] : <SupplierInvoice>[supplierInvoice!];
      return Response(statusCode: 200, title: 'Supplier Invoices Fetched', message: 'The supplier invoices have been fetched successfully', data: supplierInvoices);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
