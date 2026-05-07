import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/staff_shift.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/staff_shifts_validation.dart';

class StaffShiftsController {
  StaffShift? staffShift;
  Request? request;
  Response? response;

  StaffShiftsController({this.staffShift, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StaffShiftsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (staffShift == null || ControllerUtils.isSoftDeletedMap(staffShift!.toMap())) {
        return ControllerUtils.notFound('Staff shift');
      }

      return Response(statusCode: 200, title: 'Staff Shift Fetched', message: 'The staff shift has been fetched successfully', data: staffShift);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StaffShiftsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      staffShift = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StaffShift.fromMap,
      );

      return Response(statusCode: 201, title: 'Staff Shift Added', message: 'The staff shift has been added successfully', data: staffShift);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StaffShiftsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (staffShift == null || ControllerUtils.isSoftDeletedMap(staffShift!.toMap())) {
        return ControllerUtils.notFound('Staff shift');
      }

      staffShift = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: staffShift, toMap: (model) => model.toMap(), fromMap: StaffShift.fromMap,
      );

      return Response(statusCode: 200, title: 'Staff Shift Updated', message: 'The staff shift has been updated successfully', data: staffShift);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StaffShiftsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (staffShift == null || ControllerUtils.isSoftDeletedMap(staffShift!.toMap())) {
        return ControllerUtils.notFound('Staff shift');
      }

      final deletedStaffShift = ControllerUtils.softDeleteModel(
        model: staffShift!,
        toMap: (model) => model.toMap(),
        fromMap: StaffShift.fromMap,
      );
      staffShift = deletedStaffShift;
      return Response(statusCode: 200, title: 'Staff Shift Deleted', message: 'The staff shift has been deleted successfully', data: deletedStaffShift);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StaffShiftsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final staffShifts = staffShift == null || ControllerUtils.isSoftDeletedMap(staffShift!.toMap()) ? <StaffShift>[] : <StaffShift>[staffShift!];
      return Response(statusCode: 200, title: 'Staff Shifts Fetched', message: 'The staff shifts have been fetched successfully', data: staffShifts);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
