import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_branches.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_branches_validation.dart';

class StoreBranchesController {
  StoreBranches? storeBranches;
  Request? request;
  Response? response;

  StoreBranchesController({this.storeBranches, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreBranchesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeBranches == null || ControllerUtils.isSoftDeletedMap(storeBranches!.toMap())) {
        return ControllerUtils.notFound('Store branch');
      }

      return Response(statusCode: 200, title: 'Store Branch Fetched', message: 'The store branch has been fetched successfully', data: storeBranches);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreBranchesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      storeBranches = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StoreBranches.fromMap,
      );

      return Response(statusCode: 201, title: 'Store Branch Added', message: 'The store branch has been added successfully', data: storeBranches);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreBranchesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeBranches == null || ControllerUtils.isSoftDeletedMap(storeBranches!.toMap())) {
        return ControllerUtils.notFound('Store branch');
      }

      storeBranches = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: storeBranches, toMap: (model) => model.toMap(), fromMap: StoreBranches.fromMap,
      );

      return Response(statusCode: 200, title: 'Store Branch Updated', message: 'The store branch has been updated successfully', data: storeBranches);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreBranchesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeBranches == null || ControllerUtils.isSoftDeletedMap(storeBranches!.toMap())) {
        return ControllerUtils.notFound('Store branch');
      }

      final deletedStoreBranches = ControllerUtils.softDeleteModel(
        model: storeBranches!,
        toMap: (model) => model.toMap(),
        fromMap: StoreBranches.fromMap,
      );
      storeBranches = deletedStoreBranches;
      return Response(statusCode: 200, title: 'Store Branch Deleted', message: 'The store branch has been deleted successfully', data: deletedStoreBranches);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreBranchesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final storeBranchList = storeBranches == null || ControllerUtils.isSoftDeletedMap(storeBranches!.toMap()) ? <StoreBranches>[] : <StoreBranches>[storeBranches!];
      return Response(statusCode: 200, title: 'Store Branches Fetched', message: 'The store branches have been fetched successfully', data: storeBranchList);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
