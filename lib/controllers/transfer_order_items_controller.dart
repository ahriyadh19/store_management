import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/transfer_order_item.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/transfer_order_items_validation.dart';

class TransferOrderItemsController {
  TransferOrderItem? transferOrderItem;
  Request? request;
  Response? response;

  TransferOrderItemsController({this.transferOrderItem, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = TransferOrderItemsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (transferOrderItem == null) {
        return ControllerUtils.notFound('Transfer order item');
      }

      return Response(statusCode: 200, title: 'Transfer Order Item Fetched', message: 'The transfer order item has been fetched successfully', data: transferOrderItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = TransferOrderItemsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      transferOrderItem = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: TransferOrderItem.fromMap,
      );

      return Response(statusCode: 201, title: 'Transfer Order Item Added', message: 'The transfer order item has been added successfully', data: transferOrderItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = TransferOrderItemsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (transferOrderItem == null) {
        return ControllerUtils.notFound('Transfer order item');
      }

      transferOrderItem = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: transferOrderItem, toMap: (model) => model.toMap(), fromMap: TransferOrderItem.fromMap,
      );

      return Response(statusCode: 200, title: 'Transfer Order Item Updated', message: 'The transfer order item has been updated successfully', data: transferOrderItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = TransferOrderItemsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (transferOrderItem == null) {
        return ControllerUtils.notFound('Transfer order item');
      }

      final deletedTransferOrderItem = transferOrderItem;
      transferOrderItem = null;
      return Response(statusCode: 200, title: 'Transfer Order Item Deleted', message: 'The transfer order item has been deleted successfully', data: deletedTransferOrderItem);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = TransferOrderItemsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final transferOrderItems = transferOrderItem == null ? <TransferOrderItem>[] : <TransferOrderItem>[transferOrderItem!];
      return Response(statusCode: 200, title: 'Transfer Order Items Fetched', message: 'The transfer order items have been fetched successfully', data: transferOrderItems);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
