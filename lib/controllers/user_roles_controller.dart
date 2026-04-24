import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/user_roles.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/user_roles_validation.dart';

class UserRolesController {
  UserRoles? userRole;
  Request? request;
  Response? response;

  UserRolesController({this.userRole, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = UserRolesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (userRole == null) {
        return ControllerUtils.notFound('User role');
      }

      return Response(statusCode: 200, title: 'User Role Fetched', message: 'The user role has been fetched successfully', data: userRole);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = UserRolesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      userRole = UserRoles(
        id: request.data?['id'] as int?,
        userId: request.data!['userId'] as String,
        roleId: request.data!['roleId'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'User Role Added', message: 'The user role has been added successfully', data: userRole);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = UserRolesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (userRole == null) {
        return ControllerUtils.notFound('User role');
      }

      userRole = userRole?.copyWith(
        id: request.data!['id'] as int,
        userId: request.data!['userId'] as String,
        roleId: request.data!['roleId'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'User Role Updated', message: 'The user role has been updated successfully', data: userRole);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = UserRolesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (userRole == null) {
        return ControllerUtils.notFound('User role');
      }

      final deletedUserRole = userRole;
      userRole = null;
      return Response(statusCode: 200, title: 'User Role Deleted', message: 'The user role has been deleted successfully', data: deletedUserRole);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = UserRolesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final userRoles = userRole == null ? <UserRoles>[] : <UserRoles>[userRole!];
      return Response(statusCode: 200, title: 'User Roles Fetched', message: 'The user roles have been fetched successfully', data: userRoles);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}