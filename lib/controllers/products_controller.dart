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

      if (product == null || ControllerUtils.isSoftDeletedMap(product!.toMap())) {
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

      product = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: Product.fromMap,
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

      if (product == null || ControllerUtils.isSoftDeletedMap(product!.toMap())) {
        return ControllerUtils.notFound('Product');
      }

      product = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: product, toMap: (model) => model.toMap(), fromMap: Product.fromMap,
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

      if (product == null || ControllerUtils.isSoftDeletedMap(product!.toMap())) {
        return ControllerUtils.notFound('Product');
      }

      final deletedProduct = ControllerUtils.softDeleteModel(
        model: product!,
        toMap: (model) => model.toMap(),
        fromMap: Product.fromMap,
      );
      product = deletedProduct;
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

      final products = product == null || ControllerUtils.isSoftDeletedMap(product!.toMap()) ? <Product>[] : <Product>[product!];
      return Response(statusCode: 200, title: 'Products Fetched', message: 'The products have been fetched successfully', data: products);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}