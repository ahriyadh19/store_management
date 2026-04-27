import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
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

      if (transaction == null) {
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

      final now = DateTime.now();
      transaction = StoreFinancialTransaction(
        id: request.data?['id'] as int?,
        storeId: request.data!['storeId'] as int,
        storeUuid: request.data!['storeUuid'] as String,
        clientId: request.data!['clientId'] as int,
        clientUuid: request.data!['clientUuid'] as String,
        transactionNumber: request.data!['transactionNumber'] as String,
        transactionType: FinancialTransactionType.fromValue(request.data!['transactionType'] as String),
        sourceType: FinancialSourceType.fromValue(request.data!['sourceType'] as String),
        sourceId: request.data!['sourceId'] as int,
        sourceUuid: request.data!['sourceUuid'] as String,
        amount: ModelParsing.decimalOrThrow(request.data!['amount'], 'amount'),
        entryType: LedgerEntryType.fromValue(request.data!['entryType'] as String),
        description: request.data!['description'] as String,
        transactionDate: DateTime.fromMillisecondsSinceEpoch(request.data!['transactionDate'] as int),
        status: RecordStatus.fromCode(request.data!['status'] as int),
        createdAt: now,
        updatedAt: now,
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

      if (transaction == null) {
        return ControllerUtils.notFound('Store financial transaction');
      }

      transaction = transaction?.copyWith(
        id: request.data!['id'] as int,
        storeId: request.data!['storeId'] as int,
        storeUuid: request.data!['storeUuid'] as String,
        clientId: request.data!['clientId'] as int,
        clientUuid: request.data!['clientUuid'] as String,
        transactionNumber: request.data!['transactionNumber'] as String,
        transactionType: FinancialTransactionType.fromValue(request.data!['transactionType'] as String),
        sourceType: FinancialSourceType.fromValue(request.data!['sourceType'] as String),
        sourceId: request.data!['sourceId'] as int,
        sourceUuid: request.data!['sourceUuid'] as String,
        amount: ModelParsing.decimalOrThrow(request.data!['amount'], 'amount'),
        entryType: LedgerEntryType.fromValue(request.data!['entryType'] as String),
        description: request.data!['description'] as String,
        transactionDate: DateTime.fromMillisecondsSinceEpoch(request.data!['transactionDate'] as int),
        status: RecordStatus.fromCode(request.data!['status'] as int),
        updatedAt: DateTime.now(),
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

      if (transaction == null) {
        return ControllerUtils.notFound('Store financial transaction');
      }

      final deletedTransaction = transaction;
      transaction = null;
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

      final transactions = transaction == null ? <StoreFinancialTransaction>[] : <StoreFinancialTransaction>[transaction!];
      return Response(statusCode: 200, title: 'Financial Transactions Fetched', message: 'The financial transactions have been fetched successfully', data: transactions);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}