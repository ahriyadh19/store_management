import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/transfer_order.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/transfer_orders_validation.dart';

class TransferOrdersController {
  TransferOrder? transferOrder;
  Request? request;
  Response? response;

  TransferOrdersController({this.transferOrder, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = TransferOrdersValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (transferOrder == null || ControllerUtils.isSoftDeletedMap(transferOrder!.toMap())) {
        return ControllerUtils.notFound('Transfer order');
      }

      return Response(statusCode: 200, title: 'Transfer Order Fetched', message: 'The transfer order has been fetched successfully', data: transferOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = TransferOrdersValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      transferOrder = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: TransferOrder.fromMap,
      );

      return Response(statusCode: 201, title: 'Transfer Order Added', message: 'The transfer order has been added successfully', data: transferOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final effectiveRequest = _withPreviousStatus(request, transferOrder?.status);
      final validationError = TransferOrdersValidation.validateUpdate(effectiveRequest);
      if (validationError != null) {
        return validationError;
      }

      if (transferOrder == null || ControllerUtils.isSoftDeletedMap(transferOrder!.toMap())) {
        return ControllerUtils.notFound('Transfer order');
      }

      transferOrder = ControllerUtils.hydrateModelFromRequest(data: effectiveRequest.data!, existingModel: transferOrder, toMap: (model) => model.toMap(), fromMap: TransferOrder.fromMap,
      );

      return Response(statusCode: 200, title: 'Transfer Order Updated', message: 'The transfer order has been updated successfully', data: transferOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = TransferOrdersValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (transferOrder == null || ControllerUtils.isSoftDeletedMap(transferOrder!.toMap())) {
        return ControllerUtils.notFound('Transfer order');
      }

      final deletedTransferOrder = ControllerUtils.softDeleteModel(
        model: transferOrder!,
        toMap: (model) => model.toMap(),
        fromMap: TransferOrder.fromMap,
      );
      transferOrder = deletedTransferOrder;
      return Response(statusCode: 200, title: 'Transfer Order Deleted', message: 'The transfer order has been deleted successfully', data: deletedTransferOrder);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = TransferOrdersValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final transferOrders = transferOrder == null || ControllerUtils.isSoftDeletedMap(transferOrder!.toMap()) ? <TransferOrder>[] : <TransferOrder>[transferOrder!];
      return Response(statusCode: 200, title: 'Transfer Orders Fetched', message: 'The transfer orders have been fetched successfully', data: transferOrders);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Request _withPreviousStatus(Request request, String? currentStatus) {
    final incomingStatus = request.data?['status'];
    if (incomingStatus is! String || currentStatus == null) {
      return request;
    }

    return request.copyWith(data: <String, dynamic>{...request.data!, 'previousStatus': currentStatus});
  }
}
