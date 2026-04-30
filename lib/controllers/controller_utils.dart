import 'package:store_management/services/response.dart';

class ControllerUtils {
  static Response errorResponse(Object error) {
    return Response(statusCode: 500, title: 'Internal Server Error', message: error.toString());
  }

  static Response notFound(String entityName) {
    return Response(statusCode: 404, title: 'Not Found', message: '$entityName was not found');
  }

  static T hydrateModelFromRequest<T extends Object>({required Map<String, dynamic> data, required T Function(Map<String, dynamic> map) fromMap, T? existingModel, Map<String, dynamic> Function(T model)? toMap}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final existingData = existingModel == null || toMap == null ? const <String, dynamic>{} : toMap(existingModel);

    return fromMap({...existingData, ...data, 'id': data['id'] ?? existingData['id'] ?? 0, 'uuid': existingData['uuid'], 'createdAt': existingData['createdAt'] ?? now, 'updatedAt': now});
  }
}