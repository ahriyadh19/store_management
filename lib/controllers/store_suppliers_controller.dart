import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_supplier.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_suppliers_validation.dart';

class StoreSuppliersController {
  StoreSupplier? storeSupplier;
  Request? request;
  Response? response;

  StoreSuppliersController({this.storeSupplier, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreSuppliersValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeSupplier == null || ControllerUtils.isSoftDeletedMap(storeSupplier!.toMap())) {
        return ControllerUtils.notFound('Store supplier');
      }

      return Response(statusCode: 200, title: 'Store Supplier Fetched', message: 'The store supplier has been fetched successfully', data: storeSupplier);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreSuppliersValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      storeSupplier = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StoreSupplier.fromMap);

      return Response(statusCode: 201, title: 'Store Supplier Added', message: 'The store supplier has been added successfully', data: storeSupplier);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreSuppliersValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeSupplier == null || ControllerUtils.isSoftDeletedMap(storeSupplier!.toMap())) {
        return ControllerUtils.notFound('Store supplier');
      }

      storeSupplier = ControllerUtils.hydrateModelFromRequest(
        data: request.data!,
        existingModel: storeSupplier,
        toMap: (model) => model.toMap(),
        fromMap: StoreSupplier.fromMap,
      );

      return Response(statusCode: 200, title: 'Store Supplier Updated', message: 'The store supplier has been updated successfully', data: storeSupplier);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreSuppliersValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeSupplier == null || ControllerUtils.isSoftDeletedMap(storeSupplier!.toMap())) {
        return ControllerUtils.notFound('Store supplier');
      }

      final deletedStoreSupplier = ControllerUtils.softDeleteModel(
        model: storeSupplier!,
        toMap: (model) => model.toMap(),
        fromMap: StoreSupplier.fromMap,
      );
      storeSupplier = deletedStoreSupplier;
      return Response(statusCode: 200, title: 'Store Supplier Deleted', message: 'The store supplier has been deleted successfully', data: deletedStoreSupplier);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreSuppliersValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final storeSuppliers = storeSupplier == null || ControllerUtils.isSoftDeletedMap(storeSupplier!.toMap()) ? <StoreSupplier>[] : <StoreSupplier>[storeSupplier!];
      return Response(statusCode: 200, title: 'Store Suppliers Fetched', message: 'The store suppliers have been fetched successfully', data: storeSuppliers);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}