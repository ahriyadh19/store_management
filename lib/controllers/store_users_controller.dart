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

      if (storeUser == null || ControllerUtils.isSoftDeletedMap(storeUser!.toMap())) {
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

      storeUser = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StoreUser.fromMap,
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

      if (storeUser == null || ControllerUtils.isSoftDeletedMap(storeUser!.toMap())) {
        return ControllerUtils.notFound('Store user');
      }

      storeUser = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: storeUser, toMap: (model) => model.toMap(), fromMap: StoreUser.fromMap,
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

      if (storeUser == null || ControllerUtils.isSoftDeletedMap(storeUser!.toMap())) {
        return ControllerUtils.notFound('Store user');
      }

      final deletedStoreUser = ControllerUtils.softDeleteModel(
        model: storeUser!,
        toMap: (model) => model.toMap(),
        fromMap: StoreUser.fromMap,
      );
      storeUser = deletedStoreUser;
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

      final storeUsers = storeUser == null || ControllerUtils.isSoftDeletedMap(storeUser!.toMap()) ? <StoreUser>[] : <StoreUser>[storeUser!];
      return Response(statusCode: 200, title: 'Store Users Fetched', message: 'The store users have been fetched successfully', data: storeUsers);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
