import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/store_company.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/store_companies_validation.dart';

class StoreCompaniesController {
  StoreCompany? storeCompany;
  Request? request;
  Response? response;

  StoreCompaniesController({this.storeCompany, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StoreCompaniesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeCompany == null) {
        return ControllerUtils.notFound('Store company');
      }

      return Response(statusCode: 200, title: 'Store Company Fetched', message: 'The store company has been fetched successfully', data: storeCompany);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StoreCompaniesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      storeCompany = StoreCompany(
        id: (request.data?['id'] as int?) ?? 0,
        storeUuid: request.data!['storeUuid'] as String,
        companyUuid: request.data!['companyUuid'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Store Company Added', message: 'The store company has been added successfully', data: storeCompany);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StoreCompaniesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeCompany == null) {
        return ControllerUtils.notFound('Store company');
      }

      storeCompany = storeCompany?.copyWith(
        id: request.data!['id'] as int,
        storeUuid: request.data!['storeUuid'] as String,
        companyUuid: request.data!['companyUuid'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Store Company Updated', message: 'The store company has been updated successfully', data: storeCompany);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StoreCompaniesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (storeCompany == null) {
        return ControllerUtils.notFound('Store company');
      }

      final deletedStoreCompany = storeCompany;
      storeCompany = null;
      return Response(statusCode: 200, title: 'Store Company Deleted', message: 'The store company has been deleted successfully', data: deletedStoreCompany);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StoreCompaniesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final storeCompanies = storeCompany == null ? <StoreCompany>[] : <StoreCompany>[storeCompany!];
      return Response(statusCode: 200, title: 'Store Companies Fetched', message: 'The store companies have been fetched successfully', data: storeCompanies);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
