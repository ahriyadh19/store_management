import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/models/payment_allocation.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/payment_allocations_validation.dart';

class PaymentAllocationsController {
  PaymentAllocation? paymentAllocation;
  Request? request;
  Response? response;

  PaymentAllocationsController({this.paymentAllocation, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = PaymentAllocationsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (paymentAllocation == null) {
        return ControllerUtils.notFound('Payment allocation');
      }

      return Response(statusCode: 200, title: 'Payment Allocation Fetched', message: 'The payment allocation has been fetched successfully', data: paymentAllocation);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = PaymentAllocationsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      paymentAllocation = PaymentAllocation(
        id: (request.data?['id'] as int?) ?? 0,
        paymentVoucherUuid: request.data!['paymentVoucherUuid'] as String,
        invoiceUuid: request.data!['invoiceUuid'] as String,
        allocatedAmount: ModelParsing.decimalOrThrow(request.data!['allocatedAmount'], 'allocatedAmount'),
        allocationDate: DateTime.fromMillisecondsSinceEpoch(request.data!['allocationDate'] as int),
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Payment Allocation Added', message: 'The payment allocation has been added successfully', data: paymentAllocation);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = PaymentAllocationsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (paymentAllocation == null) {
        return ControllerUtils.notFound('Payment allocation');
      }

      paymentAllocation = paymentAllocation?.copyWith(
        id: request.data!['id'] as int,
        paymentVoucherUuid: request.data!['paymentVoucherUuid'] as String,
        invoiceUuid: request.data!['invoiceUuid'] as String,
        allocatedAmount: ModelParsing.decimalOrThrow(request.data!['allocatedAmount'], 'allocatedAmount'),
        allocationDate: DateTime.fromMillisecondsSinceEpoch(request.data!['allocationDate'] as int),
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Payment Allocation Updated', message: 'The payment allocation has been updated successfully', data: paymentAllocation);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = PaymentAllocationsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (paymentAllocation == null) {
        return ControllerUtils.notFound('Payment allocation');
      }

      final deletedPaymentAllocation = paymentAllocation;
      paymentAllocation = null;
      return Response(statusCode: 200, title: 'Payment Allocation Deleted', message: 'The payment allocation has been deleted successfully', data: deletedPaymentAllocation);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = PaymentAllocationsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final paymentAllocations = paymentAllocation == null ? <PaymentAllocation>[] : <PaymentAllocation>[paymentAllocation!];
      return Response(statusCode: 200, title: 'Payment Allocations Fetched', message: 'The payment allocations have been fetched successfully', data: paymentAllocations);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
