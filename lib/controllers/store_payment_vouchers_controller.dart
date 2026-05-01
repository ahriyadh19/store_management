import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_payment_voucher.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_payment_vouchers_validation.dart';

class StorePaymentVouchersController {
  StorePaymentVoucher? paymentVoucher;
  Request? request;
  Response? response;

  StorePaymentVouchersController({this.paymentVoucher, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StorePaymentVouchersValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (paymentVoucher == null || ControllerUtils.isSoftDeletedMap(paymentVoucher!.toMap())) {
        return ControllerUtils.notFound('Store payment voucher');
      }

      return Response(statusCode: 200, title: 'Payment Voucher Fetched', message: 'The payment voucher has been fetched successfully', data: paymentVoucher);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StorePaymentVouchersValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      paymentVoucher = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StorePaymentVoucher.fromMap,
      );

      return Response(statusCode: 201, title: 'Payment Voucher Added', message: 'The payment voucher has been added successfully', data: paymentVoucher);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StorePaymentVouchersValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (paymentVoucher == null || ControllerUtils.isSoftDeletedMap(paymentVoucher!.toMap())) {
        return ControllerUtils.notFound('Store payment voucher');
      }

      paymentVoucher = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: paymentVoucher, toMap: (model) => model.toMap(), fromMap: StorePaymentVoucher.fromMap,
      );

      return Response(statusCode: 200, title: 'Payment Voucher Updated', message: 'The payment voucher has been updated successfully', data: paymentVoucher);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StorePaymentVouchersValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (paymentVoucher == null || ControllerUtils.isSoftDeletedMap(paymentVoucher!.toMap())) {
        return ControllerUtils.notFound('Store payment voucher');
      }

      final deletedVoucher = ControllerUtils.softDeleteModel(
        model: paymentVoucher!,
        toMap: (model) => model.toMap(),
        fromMap: StorePaymentVoucher.fromMap,
      );
      paymentVoucher = deletedVoucher;
      return Response(statusCode: 200, title: 'Payment Voucher Deleted', message: 'The payment voucher has been deleted successfully', data: deletedVoucher);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StorePaymentVouchersValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final vouchers = paymentVoucher == null || ControllerUtils.isSoftDeletedMap(paymentVoucher!.toMap()) ? <StorePaymentVoucher>[] : <StorePaymentVoucher>[paymentVoucher!];
      return Response(statusCode: 200, title: 'Payment Vouchers Fetched', message: 'The payment vouchers have been fetched successfully', data: vouchers);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}