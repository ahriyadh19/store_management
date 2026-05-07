import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/staff_attendance.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/staff_attendance_validation.dart';

class StaffAttendanceController {
  StaffAttendance? staffAttendance;
  Request? request;
  Response? response;

  StaffAttendanceController({this.staffAttendance, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StaffAttendanceValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (staffAttendance == null) {
        return ControllerUtils.notFound('Staff attendance');
      }

      return Response(statusCode: 200, title: 'Staff Attendance Fetched', message: 'The staff attendance has been fetched successfully', data: staffAttendance);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StaffAttendanceValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      staffAttendance = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StaffAttendance.fromMap,
      );

      return Response(statusCode: 201, title: 'Staff Attendance Added', message: 'The staff attendance has been added successfully', data: staffAttendance);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StaffAttendanceValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (staffAttendance == null) {
        return ControllerUtils.notFound('Staff attendance');
      }

      staffAttendance = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: staffAttendance, toMap: (model) => model.toMap(), fromMap: StaffAttendance.fromMap,
      );

      return Response(statusCode: 200, title: 'Staff Attendance Updated', message: 'The staff attendance has been updated successfully', data: staffAttendance);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StaffAttendanceValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (staffAttendance == null) {
        return ControllerUtils.notFound('Staff attendance');
      }

      final deletedStaffAttendance = staffAttendance;
      staffAttendance = null;
      return Response(statusCode: 200, title: 'Staff Attendance Deleted', message: 'The staff attendance has been deleted successfully', data: deletedStaffAttendance);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StaffAttendanceValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final staffAttendanceList = staffAttendance == null ? <StaffAttendance>[] : <StaffAttendance>[staffAttendance!];
      return Response(statusCode: 200, title: 'Staff Attendance Fetched', message: 'The staff attendance entries have been fetched successfully', data: staffAttendanceList);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
