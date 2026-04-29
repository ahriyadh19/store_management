import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_user.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_users_validation.dart';

class StoreUsersController {
  StoreUser? storeUser;
  Request? request;
  Response? response;

  StoreUsersController({this.storeUser, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreUsersValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeUser == null) {
        return ControllerUtils.notFound('Store user');
      }

      return Response(statusCode: 200, title: 'Store User Fetched', message: 'The store user has been fetched successfully', data: storeUser);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreUsersValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      storeUser = StoreUser(
        id: (request.data?['id'] as int?) ?? 0,
        storeUuid: request.data!['storeUuid'] as String,
        userUuid: request.data!['userUuid'] as String,
        userRoleUuid: request.data!['userRoleUuid'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Store User Added', message: 'The store user has been added successfully', data: storeUser);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreUsersValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeUser == null) {
        return ControllerUtils.notFound('Store user');
      }

      storeUser = storeUser?.copyWith(
        id: request.data!['id'] as int,
        storeUuid: request.data!['storeUuid'] as String,
        userUuid: request.data!['userUuid'] as String,
        userRoleUuid: request.data!['userRoleUuid'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Store User Updated', message: 'The store user has been updated successfully', data: storeUser);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreUsersValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeUser == null) {
        return ControllerUtils.notFound('Store user');
      }

      final deletedStoreUser = storeUser;
      storeUser = null;
      return Response(statusCode: 200, title: 'Store User Deleted', message: 'The store user has been deleted successfully', data: deletedStoreUser);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreUsersValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final storeUsers = storeUser == null ? <StoreUser>[] : <StoreUser>[storeUser!];
      return Response(statusCode: 200, title: 'Store Users Fetched', message: 'The store users have been fetched successfully', data: storeUsers);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
