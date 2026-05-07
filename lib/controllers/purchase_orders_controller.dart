import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/purchase_order.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/purchase_orders_validation.dart';

class PurchaseOrdersController {
  PurchaseOrder? purchaseOrder;
  Request? request;
  Response? response;

  PurchaseOrdersController({this.purchaseOrder, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = PurchaseOrdersValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (purchaseOrder == null || ControllerUtils.isSoftDeletedMap(purchaseOrder!.toMap())) {
        return ControllerUtils.notFound('Purchase order');
      }

      return Response(statusCode: 200, title: 'Purchase Order Fetched', message: 'The purchase order has been fetched successfully', data: purchaseOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = PurchaseOrdersValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      purchaseOrder = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: PurchaseOrder.fromMap,
      );

      return Response(statusCode: 201, title: 'Purchase Order Added', message: 'The purchase order has been added successfully', data: purchaseOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = PurchaseOrdersValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (purchaseOrder == null || ControllerUtils.isSoftDeletedMap(purchaseOrder!.toMap())) {
        return ControllerUtils.notFound('Purchase order');
      }

      purchaseOrder = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: purchaseOrder, toMap: (model) => model.toMap(), fromMap: PurchaseOrder.fromMap,
      );

      return Response(statusCode: 200, title: 'Purchase Order Updated', message: 'The purchase order has been updated successfully', data: purchaseOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = PurchaseOrdersValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (purchaseOrder == null || ControllerUtils.isSoftDeletedMap(purchaseOrder!.toMap())) {
        return ControllerUtils.notFound('Purchase order');
      }

      final deletedPurchaseOrder = ControllerUtils.softDeleteModel(
        model: purchaseOrder!,
        toMap: (model) => model.toMap(),
        fromMap: PurchaseOrder.fromMap,
      );
      purchaseOrder = deletedPurchaseOrder;
      return Response(statusCode: 200, title: 'Purchase Order Deleted', message: 'The purchase order has been deleted successfully', data: deletedPurchaseOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = PurchaseOrdersValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final purchaseOrders = purchaseOrder == null || ControllerUtils.isSoftDeletedMap(purchaseOrder!.toMap()) ? <PurchaseOrder>[] : <PurchaseOrder>[purchaseOrder!];
      return Response(statusCode: 200, title: 'Purchase Orders Fetched', message: 'The purchase orders have been fetched successfully', data: purchaseOrders);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
