import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/staff_activity_log.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/staff_activity_logs_validation.dart';

class StaffActivityLogsController {
  StaffActivityLog? staffActivityLog;
  Request? request;
  Response? response;

  StaffActivityLogsController({this.staffActivityLog, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = StaffActivityLogsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (staffActivityLog == null) {
        return ControllerUtils.notFound('Staff activity log');
      }

      return Response(statusCode: 200, title: 'Staff Activity Log Fetched', message: 'The staff activity log has been fetched successfully', data: staffActivityLog);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = StaffActivityLogsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      staffActivityLog = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: StaffActivityLog.fromMap,
      );

      return Response(statusCode: 201, title: 'Staff Activity Log Added', message: 'The staff activity log has been added successfully', data: staffActivityLog);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = StaffActivityLogsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (staffActivityLog == null) {
        return ControllerUtils.notFound('Staff activity log');
      }

      staffActivityLog = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: staffActivityLog, toMap: (model) => model.toMap(), fromMap: StaffActivityLog.fromMap,
      );

      return Response(statusCode: 200, title: 'Staff Activity Log Updated', message: 'The staff activity log has been updated successfully', data: staffActivityLog);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = StaffActivityLogsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (staffActivityLog == null) {
        return ControllerUtils.notFound('Staff activity log');
      }

      final deletedStaffActivityLog = staffActivityLog;
      staffActivityLog = null;
      return Response(statusCode: 200, title: 'Staff Activity Log Deleted', message: 'The staff activity log has been deleted successfully', data: deletedStaffActivityLog);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = StaffActivityLogsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final staffActivityLogs = staffActivityLog == null ? <StaffActivityLog>[] : <StaffActivityLog>[staffActivityLog!];
      return Response(statusCode: 200, title: 'Staff Activity Logs Fetched', message: 'The staff activity logs have been fetched successfully', data: staffActivityLogs);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
