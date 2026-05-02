import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/supplier_products.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/supplier_products_validation.dart';

class SupplierProductsController {
	SupplierProducts? supplierProduct;
	Request? request;
	Response? response;

	SupplierProductsController({this.supplierProduct, this.request, this.response});

	Response _errorResponse(Object error) {
		return ControllerUtils.errorResponse(error);
	}

	Response read({required Request request}) {
		try {
			final validationError = SupplierProductsValidation.validateRead(request);
			if (validationError != null) {
				return validationError;
			}

			if (supplierProduct == null || ControllerUtils.isSoftDeletedMap(supplierProduct!.toMap())) {
				return ControllerUtils.notFound('Supplier product');
			}

			return Response(statusCode: 200, title: 'Product Fetched', message: 'The product has been fetched successfully', data: supplierProduct);
		} catch (error) {
			return _errorResponse(error);
		}
	}

	Response create({required Request request}) {
		try {
			final validationError = SupplierProductsValidation.validateCreate(request);
			if (validationError != null) {
				return validationError;
			}

			supplierProduct = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: SupplierProducts.fromMap);

			return Response(statusCode: 201, title: 'Product Added', message: 'The product has been added successfully', data: supplierProduct);
		} catch (error) {
			return _errorResponse(error);
		}
	}

	Response update({required Request request}) {
		try {
			final validationError = SupplierProductsValidation.validateUpdate(request);
			if (validationError != null) {
				return validationError;
			}

			if (supplierProduct == null || ControllerUtils.isSoftDeletedMap(supplierProduct!.toMap())) {
				return ControllerUtils.notFound('Supplier product');
			}

			supplierProduct = ControllerUtils.hydrateModelFromRequest(
				data: request.data!,
				existingModel: supplierProduct,
				toMap: (model) => model.toMap(),
				fromMap: SupplierProducts.fromMap,
			);

			return Response(statusCode: 200, title: 'Product Updated', message: 'The product has been updated successfully', data: supplierProduct);
		} catch (error) {
			return _errorResponse(error);
		}
	}

	Response delete({required Request request}) {
		try {
			final validationError = SupplierProductsValidation.validateDelete(request);
			if (validationError != null) {
				return validationError;
			}

			if (supplierProduct == null || ControllerUtils.isSoftDeletedMap(supplierProduct!.toMap())) {
				return ControllerUtils.notFound('Supplier product');
			}

			final deletedProduct = ControllerUtils.softDeleteModel(
				model: supplierProduct!,
				toMap: (model) => model.toMap(),
				fromMap: SupplierProducts.fromMap,
			);
			supplierProduct = deletedProduct;
			return Response(statusCode: 200, title: 'Product Deleted', message: 'The product has been deleted successfully', data: deletedProduct);
		} catch (error) {
			return _errorResponse(error);
		}
	}

	Response all({required Request request}) {
		try {
			final validationError = SupplierProductsValidation.validateAll(request);
			if (validationError != null) {
				return validationError;
			}

			final products = supplierProduct == null || ControllerUtils.isSoftDeletedMap(supplierProduct!.toMap()) ? <SupplierProducts>[] : <SupplierProducts>[supplierProduct!];
			return Response(statusCode: 200, title: 'Products Fetched', message: 'The products have been fetched successfully', data: products);
		} catch (error) {
			return _errorResponse(error);
		}
	}

	Response sell({required Request request}) {
		try {
			final validationError = SupplierProductsValidation.validateSell(request);
			if (validationError != null) {
				return validationError;
			}

			if (supplierProduct == null || ControllerUtils.isSoftDeletedMap(supplierProduct!.toMap())) {
				return ControllerUtils.notFound('Supplier product');
			}

			final int quantity = request.data!['quantity'] as int;

			supplierProduct = ControllerUtils.hydrateModelFromRequest(
				data: <String, dynamic>{...supplierProduct!.toMap(), 'stock': supplierProduct!.stock - quantity},
				existingModel: supplierProduct,
				toMap: (model) => model.toMap(),
				fromMap: SupplierProducts.fromMap,
			);
			return Response(statusCode: 200, title: 'Product Sold', message: 'The product has been sold successfully', data: supplierProduct);
		} catch (error) {
			return _errorResponse(error);
		}
	}

	Response restock({required Request request}) {
		try {
			final validationError = SupplierProductsValidation.validateRestock(request);
			if (validationError != null) {
				return validationError;
			}

			if (supplierProduct == null || ControllerUtils.isSoftDeletedMap(supplierProduct!.toMap())) {
				return ControllerUtils.notFound('Supplier product');
			}

			final int quantity = request.data!['quantity'] as int;
			supplierProduct = ControllerUtils.hydrateModelFromRequest(
				data: <String, dynamic>{...supplierProduct!.toMap(), 'stock': supplierProduct!.stock + quantity},
				existingModel: supplierProduct,
				toMap: (model) => model.toMap(),
				fromMap: SupplierProducts.fromMap,
			);
			return Response(statusCode: 200, title: 'Product Restocked', message: 'The product has been restocked successfully', data: supplierProduct);
		} catch (error) {
			return _errorResponse(error);
		}
	}
}
