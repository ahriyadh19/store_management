import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/purchase_order_item.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/purchase_order_items_validation.dart';

class PurchaseOrderItemsController {
  PurchaseOrderItem? purchaseOrderItem;
  Request? request;
  Response? response;

  PurchaseOrderItemsController({this.purchaseOrderItem, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = PurchaseOrderItemsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (purchaseOrderItem == null) {
        return ControllerUtils.notFound('Purchase order item');
      }

      return Response(statusCode: 200, title: 'Purchase Order Item Fetched', message: 'The purchase order item has been fetched successfully', data: purchaseOrderItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = PurchaseOrderItemsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      purchaseOrderItem = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: PurchaseOrderItem.fromMap,
      );

      return Response(statusCode: 201, title: 'Purchase Order Item Added', message: 'The purchase order item has been added successfully', data: purchaseOrderItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = PurchaseOrderItemsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (purchaseOrderItem == null) {
        return ControllerUtils.notFound('Purchase order item');
      }

      purchaseOrderItem = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: purchaseOrderItem, toMap: (model) => model.toMap(), fromMap: PurchaseOrderItem.fromMap,
      );

      return Response(statusCode: 200, title: 'Purchase Order Item Updated', message: 'The purchase order item has been updated successfully', data: purchaseOrderItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = PurchaseOrderItemsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (purchaseOrderItem == null) {
        return ControllerUtils.notFound('Purchase order item');
      }

      final deletedPurchaseOrderItem = purchaseOrderItem;
      purchaseOrderItem = null;
      return Response(statusCode: 200, title: 'Purchase Order Item Deleted', message: 'The purchase order item has been deleted successfully', data: deletedPurchaseOrderItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = PurchaseOrderItemsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final purchaseOrderItems = purchaseOrderItem == null ? <PurchaseOrderItem>[] : <PurchaseOrderItem>[purchaseOrderItem!];
      return Response(statusCode: 200, title: 'Purchase Order Items Fetched', message: 'The purchase order items have been fetched successfully', data: purchaseOrderItems);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
