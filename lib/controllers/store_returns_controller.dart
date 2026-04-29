import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/models/store_return.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_returns_validation.dart';

class StoreReturnsController {
  StoreReturn? storeReturn;
  Request? request;
  Response? response;

  StoreReturnsController({this.storeReturn, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreReturnsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturn == null) {
        return ControllerUtils.notFound('Store return');
      }

      return Response(statusCode: 200, title: 'Return Fetched', message: 'The return has been fetched successfully', data: storeReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreReturnsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      storeReturn = StoreReturn(
        id: (request.data?['id'] as int?) ?? 0,
        storeUuid: request.data!['storeUuid'] as String,
        clientUuid: request.data!['clientUuid'] as String,
        returnNumber: request.data!['returnNumber'] as String,
        returnType: StoreReturnType.fromValue(request.data!['returnType'] as String),
        itemCount: request.data!['itemCount'] as int,
        totalAmount: ModelParsing.decimalOrThrow(request.data!['totalAmount'], 'totalAmount'),
        reason: request.data!['reason'] as String,
        transactionDate: DateTime.fromMillisecondsSinceEpoch(request.data!['transactionDate'] as int),
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Return Added', message: 'The return has been added successfully', data: storeReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreReturnsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturn == null) {
        return ControllerUtils.notFound('Store return');
      }

      storeReturn = storeReturn?.copyWith(
        id: request.data!['id'] as int,
        storeUuid: request.data!['storeUuid'] as String,
        clientUuid: request.data!['clientUuid'] as String,
        returnNumber: request.data!['returnNumber'] as String,
        returnType: StoreReturnType.fromValue(request.data!['returnType'] as String),
        itemCount: request.data!['itemCount'] as int,
        totalAmount: ModelParsing.decimalOrThrow(request.data!['totalAmount'], 'totalAmount'),
        reason: request.data!['reason'] as String,
        transactionDate: DateTime.fromMillisecondsSinceEpoch(request.data!['transactionDate'] as int),
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Return Updated', message: 'The return has been updated successfully', data: storeReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreReturnsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeReturn == null) {
        return ControllerUtils.notFound('Store return');
      }

      final deletedReturn = storeReturn;
      storeReturn = null;
      return Response(statusCode: 200, title: 'Return Deleted', message: 'The return has been deleted successfully', data: deletedReturn);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreReturnsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final returns = storeReturn == null ? <StoreReturn>[] : <StoreReturn>[storeReturn!];
      return Response(statusCode: 200, title: 'Returns Fetched', message: 'The returns have been fetched successfully', data: returns);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}