import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/model_parsing.dart';
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

      if (storeInvoiceItem == null) {
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

      final now = DateTime.now();
      storeInvoiceItem = StoreInvoiceItem(
        id: (request.data?['id'] as int?) ?? 0,
        invoiceUuid: request.data!['invoiceUuid'] as String,
        companyProductUuid: request.data!['companyProductUuid'] as String,
        productUuid: request.data!['productUuid'] as String,
        quantity: request.data!['quantity'] as int,
        unitPrice: ModelParsing.decimalOrThrow(request.data!['unitPrice'], 'unitPrice'),
        discountAmount: ModelParsing.decimalOrThrow(request.data!['discountAmount'], 'discountAmount'),
        taxAmount: ModelParsing.decimalOrThrow(request.data!['taxAmount'], 'taxAmount'),
        lineTotal: ModelParsing.decimalOrThrow(request.data!['lineTotal'], 'lineTotal'),
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
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

      if (storeInvoiceItem == null) {
        return ControllerUtils.notFound('Store invoice item');
      }

      storeInvoiceItem = storeInvoiceItem?.copyWith(
        id: request.data!['id'] as int,
        invoiceUuid: request.data!['invoiceUuid'] as String,
        companyProductUuid: request.data!['companyProductUuid'] as String,
        productUuid: request.data!['productUuid'] as String,
        quantity: request.data!['quantity'] as int,
        unitPrice: ModelParsing.decimalOrThrow(request.data!['unitPrice'], 'unitPrice'),
        discountAmount: ModelParsing.decimalOrThrow(request.data!['discountAmount'], 'discountAmount'),
        taxAmount: ModelParsing.decimalOrThrow(request.data!['taxAmount'], 'taxAmount'),
        lineTotal: ModelParsing.decimalOrThrow(request.data!['lineTotal'], 'lineTotal'),
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
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

      if (storeInvoiceItem == null) {
        return ControllerUtils.notFound('Store invoice item');
      }

      final deletedStoreInvoiceItem = storeInvoiceItem;
      storeInvoiceItem = null;
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

      final storeInvoiceItems = storeInvoiceItem == null ? <StoreInvoiceItem>[] : <StoreInvoiceItem>[storeInvoiceItem!];
      return Response(statusCode: 200, title: 'Store Invoice Items Fetched', message: 'The store invoice items have been fetched successfully', data: storeInvoiceItems);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
