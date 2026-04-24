import 'package:store_management/services/response.dart';

class ControllerUtils {
  static Response errorResponse(Object error) {
    return Response(statusCode: 500, title: 'Internal Server Error', message: error.toString());
  }

  static Response notFound(String entityName) {
    return Response(statusCode: 404, title: 'Not Found', message: '$entityName was not found');
  }
}