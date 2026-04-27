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

      if (productTag == null) {
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

      final now = DateTime.now();
      productTag = ProductsTags(
        id: request.data?['id'] as int?,
        productId: request.data!['productId'] as int,
        productUuid: request.data!['productUuid'] as String,
        tagId: request.data!['tagId'] as int,
        tagUuid: request.data!['tagUuid'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
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

      if (productTag == null) {
        return ControllerUtils.notFound('Product tag');
      }

      productTag = productTag?.copyWith(
        id: request.data!['id'] as int,
        productId: request.data!['productId'] as int,
        productUuid: request.data!['productUuid'] as String,
        tagId: request.data!['tagId'] as int,
        tagUuid: request.data!['tagUuid'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
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

      if (productTag == null) {
        return ControllerUtils.notFound('Product tag');
      }

      final deletedProductTag = productTag;
      productTag = null;
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

      final productTags = productTag == null ? <ProductsTags>[] : <ProductsTags>[productTag!];
      return Response(statusCode: 200, title: 'Product Tags Fetched', message: 'The product tags have been fetched successfully', data: productTags);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}