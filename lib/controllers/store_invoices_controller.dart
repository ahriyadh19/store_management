import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/models/store_invoice.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_invoices_validation.dart';

class StoreInvoicesController {
  StoreInvoice? invoice;
  Request? request;
  Response? response;

  StoreInvoicesController({this.invoice, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreInvoicesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (invoice == null) {
        return ControllerUtils.notFound('Store invoice');
      }

      return Response(statusCode: 200, title: 'Invoice Fetched', message: 'The invoice has been fetched successfully', data: invoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreInvoicesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      invoice = StoreInvoice(
        id: (request.data?['id'] as int?) ?? 0,
        storeUuid: request.data!['storeUuid'] as String,
        clientUuid: request.data!['clientUuid'] as String,
        invoiceNumber: request.data!['invoiceNumber'] as String,
        invoiceType: StoreInvoiceType.fromValue(request.data!['invoiceType'] as String),
        itemCount: request.data!['itemCount'] as int,
        totalAmount: ModelParsing.decimalOrThrow(request.data!['totalAmount'], 'totalAmount'),
        paidAmount: ModelParsing.decimalOrThrow(request.data!['paidAmount'], 'paidAmount'),
        balanceAmount: ModelParsing.decimalOrThrow(request.data!['balanceAmount'], 'balanceAmount'),
        notes: request.data!['notes'] as String,
        issuedAt: DateTime.fromMillisecondsSinceEpoch(request.data!['issuedAt'] as int),
        dueAt: DateTime.fromMillisecondsSinceEpoch(request.data!['dueAt'] as int),
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Invoice Added', message: 'The invoice has been added successfully', data: invoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreInvoicesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (invoice == null) {
        return ControllerUtils.notFound('Store invoice');
      }

      invoice = invoice?.copyWith(
        id: request.data!['id'] as int,
        storeUuid: request.data!['storeUuid'] as String,
        clientUuid: request.data!['clientUuid'] as String,
        invoiceNumber: request.data!['invoiceNumber'] as String,
        invoiceType: StoreInvoiceType.fromValue(request.data!['invoiceType'] as String),
        itemCount: request.data!['itemCount'] as int,
        totalAmount: ModelParsing.decimalOrThrow(request.data!['totalAmount'], 'totalAmount'),
        paidAmount: ModelParsing.decimalOrThrow(request.data!['paidAmount'], 'paidAmount'),
        balanceAmount: ModelParsing.decimalOrThrow(request.data!['balanceAmount'], 'balanceAmount'),
        notes: request.data!['notes'] as String,
        issuedAt: DateTime.fromMillisecondsSinceEpoch(request.data!['issuedAt'] as int),
        dueAt: DateTime.fromMillisecondsSinceEpoch(request.data!['dueAt'] as int),
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Invoice Updated', message: 'The invoice has been updated successfully', data: invoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreInvoicesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (invoice == null) {
        return ControllerUtils.notFound('Store invoice');
      }

      final deletedInvoice = invoice;
      invoice = null;
      return Response(statusCode: 200, title: 'Invoice Deleted', message: 'The invoice has been deleted successfully', data: deletedInvoice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreInvoicesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final invoices = invoice == null ? <StoreInvoice>[] : <StoreInvoice>[invoice!];
      return Response(statusCode: 200, title: 'Invoices Fetched', message: 'The invoices have been fetched successfully', data: invoices);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}