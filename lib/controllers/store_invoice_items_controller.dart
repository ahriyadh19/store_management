import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_invoice_item.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_invoice_items_validation.dart';

class StoreInvoiceItemsController {
  StoreInvoiceItem? storeInvoiceItem;
  Request? request;
  Response? response;

  StoreInvoiceItemsController({this.storeInvoiceItem, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreInvoiceItemsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeInvoiceItem == null || ControllerUtils.isSoftDeletedMap(storeInvoiceItem!.toMap())) {
        return ControllerUtils.notFound('Store invoice item');
      }

      return Response(statusCode: 200, title: 'Store Invoice Item Fetched', message: 'The store invoice item has been fetched successfully', data: storeInvoiceItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreInvoiceItemsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      storeInvoiceItem = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StoreInvoiceItem.fromMap,
      );

      return Response(statusCode: 201, title: 'Store Invoice Item Added', message: 'The store invoice item has been added successfully', data: storeInvoiceItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreInvoiceItemsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeInvoiceItem == null || ControllerUtils.isSoftDeletedMap(storeInvoiceItem!.toMap())) {
        return ControllerUtils.notFound('Store invoice item');
      }

      storeInvoiceItem = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: storeInvoiceItem, toMap: (model) => model.toMap(), fromMap: StoreInvoiceItem.fromMap,
      );

      return Response(statusCode: 200, title: 'Store Invoice Item Updated', message: 'The store invoice item has been updated successfully', data: storeInvoiceItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreInvoiceItemsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeInvoiceItem == null || ControllerUtils.isSoftDeletedMap(storeInvoiceItem!.toMap())) {
        return ControllerUtils.notFound('Store invoice item');
      }

      final deletedStoreInvoiceItem = ControllerUtils.softDeleteModel(
        model: storeInvoiceItem!,
        toMap: (model) => model.toMap(),
        fromMap: StoreInvoiceItem.fromMap,
      );
      storeInvoiceItem = deletedStoreInvoiceItem;
      return Response(statusCode: 200, title: 'Store Invoice Item Deleted', message: 'The store invoice item has been deleted successfully', data: deletedStoreInvoiceItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreInvoiceItemsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final storeInvoiceItems = storeInvoiceItem == null || ControllerUtils.isSoftDeletedMap(storeInvoiceItem!.toMap()) ? <StoreInvoiceItem>[] : <StoreInvoiceItem>[storeInvoiceItem!];
      return Response(statusCode: 200, title: 'Store Invoice Items Fetched', message: 'The store invoice items have been fetched successfully', data: storeInvoiceItems);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
