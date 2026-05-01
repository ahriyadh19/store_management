import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_financial_transaction.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_financial_transactions_validation.dart';

class StoreFinancialTransactionsController {
  StoreFinancialTransaction? transaction;
  Request? request;
  Response? response;

  StoreFinancialTransactionsController({this.transaction, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreFinancialTransactionsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (transaction == null || ControllerUtils.isSoftDeletedMap(transaction!.toMap())) {
        return ControllerUtils.notFound('Store financial transaction');
      }

      return Response(statusCode: 200, title: 'Financial Transaction Fetched', message: 'The financial transaction has been fetched successfully', data: transaction);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreFinancialTransactionsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      transaction = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StoreFinancialTransaction.fromMap,
      );

      return Response(statusCode: 201, title: 'Financial Transaction Added', message: 'The financial transaction has been added successfully', data: transaction);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreFinancialTransactionsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (transaction == null || ControllerUtils.isSoftDeletedMap(transaction!.toMap())) {
        return ControllerUtils.notFound('Store financial transaction');
      }

      transaction = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: transaction, toMap: (model) => model.toMap(), fromMap: StoreFinancialTransaction.fromMap,
      );

      return Response(statusCode: 200, title: 'Financial Transaction Updated', message: 'The financial transaction has been updated successfully', data: transaction);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreFinancialTransactionsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (transaction == null || ControllerUtils.isSoftDeletedMap(transaction!.toMap())) {
        return ControllerUtils.notFound('Store financial transaction');
      }

      final deletedTransaction = ControllerUtils.softDeleteModel(
        model: transaction!,
        toMap: (model) => model.toMap(),
        fromMap: StoreFinancialTransaction.fromMap,
      );
      transaction = deletedTransaction;
      return Response(statusCode: 200, title: 'Financial Transaction Deleted', message: 'The financial transaction has been deleted successfully', data: deletedTransaction);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreFinancialTransactionsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final transactions = transaction == null || ControllerUtils.isSoftDeletedMap(transaction!.toMap()) ? <StoreFinancialTransaction>[] : <StoreFinancialTransaction>[transaction!];
      return Response(statusCode: 200, title: 'Financial Transactions Fetched', message: 'The financial transactions have been fetched successfully', data: transactions);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}