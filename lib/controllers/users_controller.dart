import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/users.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/users_validation.dart';

class UsersController {
  User? user;
  Request? request;
  Response? response;

  UsersController({this.user, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Map<String, dynamic> _userData(User value) {
    return value.toMap();
  }

  Response read({required Request request}) {
    try {
      final validationError = UsersValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (user == null || ControllerUtils.isSoftDeletedMap(_userData(user!))) {
        return ControllerUtils.notFound('User');
      }

      return Response(statusCode: 200, title: 'User Fetched', message: 'The user has been fetched successfully', data: _userData(user!));
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = UsersValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      user = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: User.fromMap,
      );

      return Response(statusCode: 201, title: 'User Added', message: 'The user has been added successfully', data: _userData(user!));
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = UsersValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (user == null || ControllerUtils.isSoftDeletedMap(_userData(user!))) {
        return ControllerUtils.notFound('User');
      }

      user = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: user, toMap: (model) => model.toMap(includePassword: true), fromMap: User.fromMap,
      );

      return Response(statusCode: 200, title: 'User Updated', message: 'The user has been updated successfully', data: _userData(user!));
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = UsersValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (user == null || ControllerUtils.isSoftDeletedMap(_userData(user!))) {
        return ControllerUtils.notFound('User');
      }

      final deletedUser = ControllerUtils.softDeleteModel(
        model: user!,
        toMap: (model) => model.toMap(includePassword: true),
        fromMap: User.fromMap,
      );
      user = deletedUser;
      return Response(statusCode: 200, title: 'User Deleted', message: 'The user has been deleted successfully', data: _userData(deletedUser));
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = UsersValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final users = user == null || ControllerUtils.isSoftDeletedMap(_userData(user!)) ? <Map<String, dynamic>>[] : <Map<String, dynamic>>[_userData(user!)];
      return Response(statusCode: 200, title: 'Users Fetched', message: 'The users have been fetched successfully', data: users);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}