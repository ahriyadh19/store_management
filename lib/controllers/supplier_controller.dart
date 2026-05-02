import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/supplier.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/supplier_validation.dart';

class SupplierController {
	Supplier? supplier;
	Request? request;
	Response? response;

	SupplierController({this.supplier, this.request, this.response});

	Response _errorResponse(Object error) {
		return ControllerUtils.errorResponse(error);
	}

	Response read({required Request request}) {
		try {
			final validationError = SupplierValidation.validateRead(request);
			if (validationError != null) {
				return validationError;
			}

			if (supplier == null || ControllerUtils.isSoftDeletedMap(supplier!.toMap())) {
				return ControllerUtils.notFound('Supplier');
			}

			return Response(statusCode: 200, title: 'Supplier Fetched', message: 'The supplier has been fetched successfully', data: supplier);
		} catch (error) {
			return _errorResponse(error);
		}
	}

	Response create({required Request request}) {
		try {
			final validationError = SupplierValidation.validateCreate(request);
			if (validationError != null) {
				return validationError;
			}

			supplier = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: Supplier.fromMap);

			return Response(statusCode: 201, title: 'Supplier Added', message: 'The supplier has been added successfully', data: supplier);
		} catch (error) {
			return _errorResponse(error);
		}
	}

	Response update({required Request request}) {
		try {
			final validationError = SupplierValidation.validateUpdate(request);
			if (validationError != null) {
				return validationError;
			}

			if (supplier == null || ControllerUtils.isSoftDeletedMap(supplier!.toMap())) {
				return ControllerUtils.notFound('Supplier');
			}

			supplier = ControllerUtils.hydrateModelFromRequest(
				data: request.data!,
				existingModel: supplier,
				toMap: (model) => model.toMap(),
				fromMap: Supplier.fromMap,
			);

			return Response(statusCode: 200, title: 'Supplier Updated', message: 'The supplier has been updated successfully', data: supplier);
		} catch (error) {
			return _errorResponse(error);
		}
	}

	Response delete({required Request request}) {
		try {
			final validationError = SupplierValidation.validateDelete(request);
			if (validationError != null) {
				return validationError;
			}

			if (supplier == null || ControllerUtils.isSoftDeletedMap(supplier!.toMap())) {
				return ControllerUtils.notFound('Supplier');
			}

			final deletedSupplier = ControllerUtils.softDeleteModel(
				model: supplier!,
				toMap: (model) => model.toMap(),
				fromMap: Supplier.fromMap,
			);
			supplier = deletedSupplier;
			return Response(statusCode: 200, title: 'Supplier Deleted', message: 'The supplier has been deleted successfully', data: deletedSupplier);
		} catch (error) {
			return _errorResponse(error);
		}
	}

	Response all({required Request request}) {
		try {
			final validationError = SupplierValidation.validateAll(request);
			if (validationError != null) {
				return validationError;
			}

			final suppliers = supplier == null || ControllerUtils.isSoftDeletedMap(supplier!.toMap()) ? <Supplier>[] : <Supplier>[supplier!];
			return Response(statusCode: 200, title: 'Suppliers Fetched', message: 'The suppliers have been fetched successfully', data: suppliers);
		} catch (error) {
			return _errorResponse(error);
		}
	}
}
