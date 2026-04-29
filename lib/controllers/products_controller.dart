import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/product.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/products_validation.dart';

class ProductsController {
  Product? product;
  Request? request;
  Response? response;

  ProductsController({this.product, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = ProductsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (product == null) {
        return ControllerUtils.notFound('Product');
      }

      return Response(statusCode: 200, title: 'Product Fetched', message: 'The product has been fetched successfully', data: product);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = ProductsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      product = Product(
        id: (request.data?['id'] as int?) ?? 0,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Product Added', message: 'The product has been added successfully', data: product);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = ProductsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (product == null) {
        return ControllerUtils.notFound('Product');
      }

      product = product?.copyWith(
        id: request.data!['id'] as int,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Product Updated', message: 'The product has been updated successfully', data: product);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = ProductsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (product == null) {
        return ControllerUtils.notFound('Product');
      }

      final deletedProduct = product;
      product = null;
      return Response(statusCode: 200, title: 'Product Deleted', message: 'The product has been deleted successfully', data: deletedProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = ProductsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final products = product == null ? <Product>[] : <Product>[product!];
      return Response(statusCode: 200, title: 'Products Fetched', message: 'The products have been fetched successfully', data: products);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}