import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/products_tags.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/products_tags_validation.dart';

class ProductsTagsController {
  ProductsTags? productTag;
  Request? request;
  Response? response;

  ProductsTagsController({this.productTag, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = ProductsTagsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (productTag == null || ControllerUtils.isSoftDeletedMap(productTag!.toMap())) {
        return ControllerUtils.notFound('Product tag');
      }

      return Response(statusCode: 200, title: 'Product Tag Fetched', message: 'The product tag has been fetched successfully', data: productTag);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = ProductsTagsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      productTag = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: ProductsTags.fromMap,
      );

      return Response(statusCode: 201, title: 'Product Tag Added', message: 'The product tag has been added successfully', data: productTag);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = ProductsTagsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (productTag == null || ControllerUtils.isSoftDeletedMap(productTag!.toMap())) {
        return ControllerUtils.notFound('Product tag');
      }

      productTag = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: productTag, toMap: (model) => model.toMap(), fromMap: ProductsTags.fromMap,
      );

      return Response(statusCode: 200, title: 'Product Tag Updated', message: 'The product tag has been updated successfully', data: productTag);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = ProductsTagsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (productTag == null || ControllerUtils.isSoftDeletedMap(productTag!.toMap())) {
        return ControllerUtils.notFound('Product tag');
      }

      final deletedProductTag = ControllerUtils.softDeleteModel(
        model: productTag!,
        toMap: (model) => model.toMap(),
        fromMap: ProductsTags.fromMap,
      );
      productTag = deletedProductTag;
      return Response(statusCode: 200, title: 'Product Tag Deleted', message: 'The product tag has been deleted successfully', data: deletedProductTag);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = ProductsTagsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final productTags = productTag == null || ControllerUtils.isSoftDeletedMap(productTag!.toMap()) ? <ProductsTags>[] : <ProductsTags>[productTag!];
      return Response(statusCode: 200, title: 'Product Tags Fetched', message: 'The product tags have been fetched successfully', data: productTags);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}