import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
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

      if (paymentVoucher == null) {
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

      final now = DateTime.now();
      paymentVoucher = StorePaymentVoucher(
        id: request.data?['id'] as int?,
        storeId: request.data!['storeId'] as int,
        storeUuid: request.data!['storeUuid'] as String,
        clientId: request.data!['clientId'] as int,
        clientUuid: request.data!['clientUuid'] as String,
        voucherNumber: request.data!['voucherNumber'] as String,
        payeeName: request.data!['payeeName'] as String,
        amount: ModelParsing.decimalOrThrow(request.data!['amount'], 'amount'),
        paymentMethod: StorePaymentMethod.fromValue(request.data!['paymentMethod'] as String),
        referenceNumber: request.data!['referenceNumber'] as String,
        description: request.data!['description'] as String,
        transactionDate: DateTime.fromMillisecondsSinceEpoch(request.data!['transactionDate'] as int),
        status: RecordStatus.fromCode(request.data!['status'] as int),
        createdAt: now,
        updatedAt: now,
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

      if (paymentVoucher == null) {
        return ControllerUtils.notFound('Store payment voucher');
      }

      paymentVoucher = paymentVoucher?.copyWith(
        id: request.data!['id'] as int,
        storeId: request.data!['storeId'] as int,
        storeUuid: request.data!['storeUuid'] as String,
        clientId: request.data!['clientId'] as int,
        clientUuid: request.data!['clientUuid'] as String,
        voucherNumber: request.data!['voucherNumber'] as String,
        payeeName: request.data!['payeeName'] as String,
        amount: ModelParsing.decimalOrThrow(request.data!['amount'], 'amount'),
        paymentMethod: StorePaymentMethod.fromValue(request.data!['paymentMethod'] as String),
        referenceNumber: request.data!['referenceNumber'] as String,
        description: request.data!['description'] as String,
        transactionDate: DateTime.fromMillisecondsSinceEpoch(request.data!['transactionDate'] as int),
        status: RecordStatus.fromCode(request.data!['status'] as int),
        updatedAt: DateTime.now(),
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

      if (paymentVoucher == null) {
        return ControllerUtils.notFound('Store payment voucher');
      }

      final deletedVoucher = paymentVoucher;
      paymentVoucher = null;
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

      final vouchers = paymentVoucher == null ? <StorePaymentVoucher>[] : <StorePaymentVoucher>[paymentVoucher!];
      return Response(statusCode: 200, title: 'Payment Vouchers Fetched', message: 'The payment vouchers have been fetched successfully', data: vouchers);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}