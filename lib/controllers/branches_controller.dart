import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/branch.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/branches_validation.dart';

class BranchesController {
  Branch? branch;
  Request? request;
  Response? response;

  BranchesController({this.branch, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = BranchesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (branch == null) {
        return ControllerUtils.notFound('Branch');
      }

      return Response(statusCode: 200, title: 'Branch Fetched', message: 'The branch has been fetched successfully', data: branch);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = BranchesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      branch = Branch(
        id: (request.data?['id'] as int?) ?? 0,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        address: request.data!['address'] as String,
        phone: request.data!['phone'] as String,
        email: request.data!['email'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Branch Added', message: 'The branch has been added successfully', data: branch);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = BranchesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (branch == null) {
        return ControllerUtils.notFound('Branch');
      }

      branch = branch?.copyWith(
        id: request.data!['id'] as int,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        address: request.data!['address'] as String,
        phone: request.data!['phone'] as String,
        email: request.data!['email'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Branch Updated', message: 'The branch has been updated successfully', data: branch);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = BranchesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (branch == null) {
        return ControllerUtils.notFound('Branch');
      }

      final deletedBranch = branch;
      branch = null;
      return Response(statusCode: 200, title: 'Branch Deleted', message: 'The branch has been deleted successfully', data: deletedBranch);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = BranchesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final branches = branch == null ? <Branch>[] : <Branch>[branch!];
      return Response(statusCode: 200, title: 'Branches Fetched', message: 'The branches have been fetched successfully', data: branches);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
