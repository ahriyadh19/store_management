import 'package:store_management/models/company_products.dart';
import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/company_products_validation.dart';

class CompanyProductsController {
  CompanyProducts? companyProduct;
  Request? request;
  Response? response;

  CompanyProductsController({this.companyProduct, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = CompanyProductsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (companyProduct == null) {
        return ControllerUtils.notFound('Company product');
      }

      return Response(statusCode: 200, title: 'Product Fetched', message: 'The product has been fetched successfully', data: companyProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = CompanyProductsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      companyProduct = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: CompanyProducts.fromMap,
      );

      return Response(statusCode: 201, title: 'Product Added', message: 'The product has been added successfully', data: companyProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = CompanyProductsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (companyProduct == null) {
        return ControllerUtils.notFound('Company product');
      }

      companyProduct = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: companyProduct, toMap: (model) => model.toMap(), fromMap: CompanyProducts.fromMap,
      );

      return Response(statusCode: 200, title: 'Product Updated', message: 'The product has been updated successfully', data: companyProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

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
