import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/models/store_return_item.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_return_items_validation.dart';

class StoreReturnItemsController {
  StoreReturnItem? storeReturnItem;
  Request? request;
  Response? response;

  StoreReturnItemsController({this.storeReturnItem, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreReturnItemsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturnItem == null) {
        return ControllerUtils.notFound('Store return item');
      }

      return Response(statusCode: 200, title: 'Store Return Item Fetched', message: 'The store return item has been fetched successfully', data: storeReturnItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreReturnItemsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      storeReturnItem = StoreReturnItem(
        id: (request.data?['id'] as int?) ?? 0,
        returnUuid: request.data!['returnUuid'] as String,
        invoiceItemUuid: request.data?['invoiceItemUuid'] as String?,
        companyProductUuid: request.data!['companyProductUuid'] as String,
        productUuid: request.data!['productUuid'] as String,
        quantity: request.data!['quantity'] as int,
        unitPrice: ModelParsing.decimalOrThrow(request.data!['unitPrice'], 'unitPrice'),
        lineTotal: ModelParsing.decimalOrThrow(request.data!['lineTotal'], 'lineTotal'),
        reason: request.data!['reason'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Store Return Item Added', message: 'The store return item has been added successfully', data: storeReturnItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreReturnItemsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturnItem == null) {
        return ControllerUtils.notFound('Store return item');
      }

      storeReturnItem = storeReturnItem?.copyWith(
        id: request.data!['id'] as int,
        returnUuid: request.data!['returnUuid'] as String,
        invoiceItemUuid: request.data?['invoiceItemUuid'] as String?,
        companyProductUuid: request.data!['companyProductUuid'] as String,
        productUuid: request.data!['productUuid'] as String,
        quantity: request.data!['quantity'] as int,
        unitPrice: ModelParsing.decimalOrThrow(request.data!['unitPrice'], 'unitPrice'),
        lineTotal: ModelParsing.decimalOrThrow(request.data!['lineTotal'], 'lineTotal'),
        reason: request.data!['reason'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Store Return Item Updated', message: 'The store return item has been updated successfully', data: storeReturnItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreReturnItemsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturnItem == null) {
        return ControllerUtils.notFound('Store return item');
      }

      final deletedStoreReturnItem = storeReturnItem;
      storeReturnItem = null;
      return Response(statusCode: 200, title: 'Store Return Item Deleted', message: 'The store return item has been deleted successfully', data: deletedStoreReturnItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreReturnItemsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final storeReturnItems = storeReturnItem == null ? <StoreReturnItem>[] : <StoreReturnItem>[storeReturnItem!];
      return Response(statusCode: 200, title: 'Store Return Items Fetched', message: 'The store return items have been fetched successfully', data: storeReturnItems);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
