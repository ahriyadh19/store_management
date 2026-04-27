import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';

class ValidationUtils {
  static Response badRequest(String message) {
    return Response(statusCode: 400, title: 'Bad Request', message: message);
  }

  static Response? validateRequestMetadata(Request request) {
    if (request.title.trim().isEmpty) {
      return badRequest('Request title is required');
    }

    if (request.message.trim().isEmpty) {
      return badRequest('Request message is required');
    }

    return null;
  }

  static Response? validateRequiredString(Request request, String key, String message) {
    final value = request.data?[key];
    if (value is! String || value.trim().isEmpty) {
      return badRequest(message);
    }

    return null;
  }

  static Response? validateRequiredUuid(Request request, String key, String message) {
    final stringError = validateRequiredString(request, key, message);
    if (stringError != null) {
      return stringError;
    }

    final value = (request.data![key] as String).trim();
    final uuidPattern = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$');
    if (!uuidPattern.hasMatch(value)) {
      return badRequest(message);
    }

    return null;
  }

  static Response? validateRequiredInt(
    Request request,
    String key,
    String message, {
    int min = 1,
  }) {
    final value = request.data?[key];
    if (value is! int || value < min) {
      return badRequest(message);
    }

    return null;
  }

  static Response? validateRequiredNum(
    Request request,
    String key,
    String message, {
    num min = 0,
  }) {
    final value = request.data?[key];
    if (value is! num || value < min) {
      return badRequest(message);
    }

    return null;
  }

  static Response? validateStatus(Request request, {String key = 'status'}) {
    return validateRequiredInt(request, key, 'Status must be provided as a non-negative integer', min: 0);
  }

  static Response? validateEmail(Request request, {String key = 'email'}) {
    final value = request.data?[key];
    if (value is! String || value.trim().isEmpty) {
      return badRequest('Email is required');
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(value.trim())) {
      return badRequest('Email format is invalid');
    }

    return null;
  }
}