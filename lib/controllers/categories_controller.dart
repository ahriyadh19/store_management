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

      if (category == null || ControllerUtils.isSoftDeletedMap(category!.toMap())) {
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

      category = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: Categories.fromMap,
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

      if (category == null || ControllerUtils.isSoftDeletedMap(category!.toMap())) {
        return ControllerUtils.notFound('Category');
      }

      category = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: category, toMap: (model) => model.toMap(), fromMap: Categories.fromMap,
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

      if (category == null || ControllerUtils.isSoftDeletedMap(category!.toMap())) {
        return ControllerUtils.notFound('Category');
      }

      final deletedCategory = ControllerUtils.softDeleteModel(
        model: category!,
        toMap: (model) => model.toMap(),
        fromMap: Categories.fromMap,
      );
      category = deletedCategory;
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

      final categories = category == null || ControllerUtils.isSoftDeletedMap(category!.toMap()) ? <Categories>[] : <Categories>[category!];
      return Response(statusCode: 200, title: 'Categories Fetched', message: 'The categories have been fetched successfully', data: categories);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}