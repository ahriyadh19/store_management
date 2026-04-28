import 'package:store_management/models/company_products.dart';
import 'package:store_management/models/model_parsing.dart';
import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/company_products_validation.dart';

class CompanyProductsController {
  // This class is responsible for managing the state of company products.
  // It can include methods for adding, updating, and deleting products,
  // as well as fetching product data from a database or API.

  CompanyProducts? companyProduct;
  Request? request;
  Response? response;

  CompanyProductsController({this.companyProduct, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  // Example method to fetch products
  Response read({required Request request}) {
    try {
      final validationError = CompanyProductsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (companyProduct == null) {
        return ControllerUtils.notFound('Company product');
      }

      // Code to fetch products from the database or API
      return Response(statusCode: 200, title: 'Product Fetched', message: 'The product has been fetched successfully', data: companyProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  // Example method to add a new product
  Response create({required Request request}) {
    try {
      final validationError = CompanyProductsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      companyProduct = CompanyProducts(
        id: request.data?['id'] as int?,
        companyId: request.data!['companyId'] as int,
        companyUuid: request.data!['companyUuid'] as String,
        productId: request.data!['productId'] as int,
        productUuid: request.data!['productUuid'] as String,
        price: ModelParsing.decimalOrThrow(request.data!['price'], 'price'),
        costPrice: ModelParsing.decimalOrNull(request.data!['costPrice']),
        description: request.data!['description'] as String,
        sku: request.data!['sku'] as String?,
        barcode: request.data!['barcode'] as String?,
        stock: request.data!['stock'] as int,
        reorderLevel: ModelParsing.intOrNull(request.data!['reorderLevel']),
        reorderQuantity: ModelParsing.intOrNull(request.data!['reorderQuantity']),
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Product Added', message: 'The product has been added successfully', data: companyProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  // Example method to update an existing product
  Response update({required Request request}) {
    try {
      final validationError = CompanyProductsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (companyProduct == null) {
        return ControllerUtils.notFound('Company product');
      }

      companyProduct = companyProduct?.copyWith(
        id: request.data!['id'] as int,
        companyId: request.data!['companyId'] as int,
        companyUuid: request.data!['companyUuid'] as String,
        productId: request.data!['productId'] as int,
        productUuid: request.data!['productUuid'] as String,
        price: ModelParsing.decimalOrThrow(request.data!['price'], 'price'),
        costPrice: ModelParsing.decimalOrNull(request.data!['costPrice']),
        description: request.data!['description'] as String,
        sku: request.data!['sku'] as String?,
        barcode: request.data!['barcode'] as String?,
        stock: request.data!['stock'] as int,
        reorderLevel: ModelParsing.intOrNull(request.data!['reorderLevel']),
        reorderQuantity: ModelParsing.intOrNull(request.data!['reorderQuantity']),
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Product Updated', message: 'The product has been updated successfully', data: companyProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  // Example method to delete a product
  Response delete({required Request request}) {
    try {
      final validationError = CompanyProductsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (companyProduct == null) {
        return ControllerUtils.notFound('Company product');
      }

      final deletedProduct = companyProduct;
      companyProduct = null;
      return Response(statusCode: 200, title: 'Product Deleted', message: 'The product has been deleted successfully', data: deletedProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  // Example method to fetch all products
  Response all({required Request request}) {
    try {
      final validationError = CompanyProductsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final products = companyProduct == null ? <CompanyProducts>[] : <CompanyProducts>[companyProduct!];
      return Response(statusCode: 200, title: 'Products Fetched', message: 'The products have been fetched successfully', data: products);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  // Example method to sell a product
  Response sell({required Request request}) {
    try {
      final validationError = CompanyProductsValidation.validateSell(request);
      if (validationError != null) {
        return validationError;
      }

      if (companyProduct == null) {
        return ControllerUtils.notFound('Company product');
      }

      final int quantity = request.data!['quantity'] as int;

      companyProduct = companyProduct?.copyWith(stock: companyProduct!.stock - quantity, updatedAt: DateTime.now());
      return Response(statusCode: 200, title: 'Product Sold', message: 'The product has been sold successfully', data: companyProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  // Example method to restock a product
  Response restock({required Request request}) {
    try {
      final validationError = CompanyProductsValidation.validateRestock(request);
      if (validationError != null) {
        return validationError;
      }

      if (companyProduct == null) {
        return ControllerUtils.notFound('Company product');
      }

      final int quantity = request.data!['quantity'] as int;
      companyProduct = companyProduct?.copyWith(stock: companyProduct!.stock + quantity, updatedAt: DateTime.now());
      return Response(statusCode: 200, title: 'Product Restocked', message: 'The product has been restocked successfully', data: companyProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
