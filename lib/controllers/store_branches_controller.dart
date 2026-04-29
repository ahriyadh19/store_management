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

      if (storeBranches == null) {
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

      final now = DateTime.now();
      storeBranches = StoreBranches(
        id: (request.data?['id'] as int?) ?? 0,
        storeUuid: request.data!['storeUuid'] as String,
        branchUuid: request.data!['branchUuid'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
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

      if (storeBranches == null) {
        return ControllerUtils.notFound('Store branch');
      }

      storeBranches = storeBranches?.copyWith(
        id: request.data!['id'] as int,
        storeUuid: request.data!['storeUuid'] as String,
        branchUuid: request.data!['branchUuid'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
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

      if (storeBranches == null) {
        return ControllerUtils.notFound('Store branch');
      }

      final deletedStoreBranches = storeBranches;
      storeBranches = null;
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

      final storeBranchList = storeBranches == null ? <StoreBranches>[] : <StoreBranches>[storeBranches!];
      return Response(statusCode: 200, title: 'Store Branches Fetched', message: 'The store branches have been fetched successfully', data: storeBranchList);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
