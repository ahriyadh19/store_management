import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/branch_price.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/branch_prices_validation.dart';

class BranchPricesController {
  BranchPrice? branchPrice;
  Request? request;
  Response? response;

  BranchPricesController({this.branchPrice, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = BranchPricesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (branchPrice == null || ControllerUtils.isSoftDeletedMap(branchPrice!.toMap())) {
        return ControllerUtils.notFound('Branch price');
      }

      return Response(statusCode: 200, title: 'Branch Price Fetched', message: 'The branch price has been fetched successfully', data: branchPrice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = BranchPricesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      branchPrice = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: BranchPrice.fromMap,
      );

      return Response(statusCode: 201, title: 'Branch Price Added', message: 'The branch price has been added successfully', data: branchPrice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = BranchPricesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (branchPrice == null || ControllerUtils.isSoftDeletedMap(branchPrice!.toMap())) {
        return ControllerUtils.notFound('Branch price');
      }

      branchPrice = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: branchPrice, toMap: (model) => model.toMap(), fromMap: BranchPrice.fromMap,
      );

      return Response(statusCode: 200, title: 'Branch Price Updated', message: 'The branch price has been updated successfully', data: branchPrice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = BranchPricesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (branchPrice == null || ControllerUtils.isSoftDeletedMap(branchPrice!.toMap())) {
        return ControllerUtils.notFound('Branch price');
      }

      final deletedBranchPrice = ControllerUtils.softDeleteModel(
        model: branchPrice!,
        toMap: (model) => model.toMap(),
        fromMap: BranchPrice.fromMap,
      );
      branchPrice = deletedBranchPrice;
      return Response(statusCode: 200, title: 'Branch Price Deleted', message: 'The branch price has been deleted successfully', data: deletedBranchPrice);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = BranchPricesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final branchPrices = branchPrice == null || ControllerUtils.isSoftDeletedMap(branchPrice!.toMap()) ? <BranchPrice>[] : <BranchPrice>[branchPrice!];
      return Response(statusCode: 200, title: 'Branch Prices Fetched', message: 'The branch prices have been fetched successfully', data: branchPrices);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
