import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/roles.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/roles_validation.dart';

class RolesController {
  Roles? role;
  Request? request;
  Response? response;

  RolesController({this.role, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = RolesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (role == null) {
        return ControllerUtils.notFound('Role');
      }

      return Response(statusCode: 200, title: 'Role Fetched', message: 'The role has been fetched successfully', data: role);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = RolesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      role = Roles(
        id: request.data?['id'] as int?,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Role Added', message: 'The role has been added successfully', data: role);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = RolesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (role == null) {
        return ControllerUtils.notFound('Role');
      }

      role = role?.copyWith(
        id: request.data!['id'] as int,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Role Updated', message: 'The role has been updated successfully', data: role);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = RolesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (role == null) {
        return ControllerUtils.notFound('Role');
      }

      final deletedRole = role;
      role = null;
      return Response(statusCode: 200, title: 'Role Deleted', message: 'The role has been deleted successfully', data: deletedRole);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = RolesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final roles = role == null ? <Roles>[] : <Roles>[role!];
      return Response(statusCode: 200, title: 'Roles Fetched', message: 'The roles have been fetched successfully', data: roles);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}