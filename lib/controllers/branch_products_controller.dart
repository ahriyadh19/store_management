import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/branch_product.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/branch_products_validation.dart';

class BranchProductsController {
  BranchProduct? branchProduct;
  Request? request;
  Response? response;

  BranchProductsController({this.branchProduct, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = BranchProductsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (branchProduct == null || ControllerUtils.isSoftDeletedMap(branchProduct!.toMap())) {
        return ControllerUtils.notFound('Branch product');
      }

      return Response(statusCode: 200, title: 'Branch Product Fetched', message: 'The branch product has been fetched successfully', data: branchProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = BranchProductsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      branchProduct = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: BranchProduct.fromMap);

      return Response(statusCode: 201, title: 'Branch Product Added', message: 'The branch product has been added successfully', data: branchProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = BranchProductsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (branchProduct == null || ControllerUtils.isSoftDeletedMap(branchProduct!.toMap())) {
        return ControllerUtils.notFound('Branch product');
      }

      branchProduct = ControllerUtils.hydrateModelFromRequest(
        data: request.data!,
        existingModel: branchProduct,
        toMap: (model) => model.toMap(),
        fromMap: BranchProduct.fromMap,
      );

      return Response(statusCode: 200, title: 'Branch Product Updated', message: 'The branch product has been updated successfully', data: branchProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = BranchProductsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (branchProduct == null || ControllerUtils.isSoftDeletedMap(branchProduct!.toMap())) {
        return ControllerUtils.notFound('Branch product');
      }

      final deletedBranchProduct = ControllerUtils.softDeleteModel(
        model: branchProduct!,
        toMap: (model) => model.toMap(),
        fromMap: BranchProduct.fromMap,
      );
      branchProduct = deletedBranchProduct;
      return Response(statusCode: 200, title: 'Branch Product Deleted', message: 'The branch product has been deleted successfully', data: deletedBranchProduct);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = BranchProductsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final branchProducts = branchProduct == null || ControllerUtils.isSoftDeletedMap(branchProduct!.toMap()) ? <BranchProduct>[] : <BranchProduct>[branchProduct!];
      return Response(statusCode: 200, title: 'Branch Products Fetched', message: 'The branch products have been fetched successfully', data: branchProducts);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
