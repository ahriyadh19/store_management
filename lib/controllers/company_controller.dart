import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/company.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/company_validation.dart';

class CompanyController {
  Company? company;
  Request? request;
  Response? response;

  CompanyController({this.company, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = CompanyValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (company == null) {
        return ControllerUtils.notFound('Company');
      }

      return Response(statusCode: 200, title: 'Company Fetched', message: 'The company has been fetched successfully', data: company);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = CompanyValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      company = Company(
        id: request.data?['id'] as int?,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Company Added', message: 'The company has been added successfully', data: company);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = CompanyValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (company == null) {
        return ControllerUtils.notFound('Company');
      }

      company = company?.copyWith(
        id: request.data!['id'] as int,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Company Updated', message: 'The company has been updated successfully', data: company);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = CompanyValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (company == null) {
        return ControllerUtils.notFound('Company');
      }

      final deletedCompany = company;
      company = null;
      return Response(statusCode: 200, title: 'Company Deleted', message: 'The company has been deleted successfully', data: deletedCompany);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = CompanyValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final companies = company == null ? <Company>[] : <Company>[company!];
      return Response(statusCode: 200, title: 'Companies Fetched', message: 'The companies have been fetched successfully', data: companies);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}