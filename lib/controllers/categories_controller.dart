import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/categories.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/categories_validation.dart';

class CategoriesController {
  Categories? category;
  Request? request;
  Response? response;

  CategoriesController({this.category, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = CategoriesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (category == null) {
        return ControllerUtils.notFound('Category');
      }

      return Response(statusCode: 200, title: 'Category Fetched', message: 'The category has been fetched successfully', data: category);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = CategoriesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      category = Categories(
        id: request.data?['id'] as int?,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        status: request.data!['status'] as int,
        parentUuid: request.data?['parentUuid'] as String?,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Category Added', message: 'The category has been added successfully', data: category);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = CategoriesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (category == null) {
        return ControllerUtils.notFound('Category');
      }

      category = category?.copyWith(
        id: request.data!['id'] as int,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        status: request.data!['status'] as int,
        parentUuid: request.data?['parentUuid'],
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Category Updated', message: 'The category has been updated successfully', data: category);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = CategoriesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (category == null) {
        return ControllerUtils.notFound('Category');
      }

      final deletedCategory = category;
      category = null;
      return Response(statusCode: 200, title: 'Category Deleted', message: 'The category has been deleted successfully', data: deletedCategory);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = CategoriesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final categories = category == null ? <Categories>[] : <Categories>[category!];
      return Response(statusCode: 200, title: 'Categories Fetched', message: 'The categories have been fetched successfully', data: categories);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}