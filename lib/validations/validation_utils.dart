import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/models/model_enums.dart';

class ValidationUtils {
  static final RegExp _uuidPattern = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$');

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

  static Response? validateRequiredEnumString(
    Request request,
    String key,
    String message,
    Object Function(String value) parser,
  ) {
    final stringError = validateRequiredString(request, key, message);
    if (stringError != null) {
      return stringError;
    }

    try {
      parser((request.data![key] as String).trim());
    } on FormatException {
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
    if (!_uuidPattern.hasMatch(value)) {
      return badRequest(message);
    }

    return null;
  }

  static Response? validateOptionalUuid(Request request, String key, String message) {
    final value = request.data?[key];
    if (value == null) {
      return null;
    }

    if (value is! String || !_uuidPattern.hasMatch(value.trim())) {
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

  static Response? validateOptionalInt(Request request, String key, String message, {int min = 0}) {
    final value = request.data?[key];
    if (value == null) {
      return null;
    }

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
    final acceptedCodes = RecordStatus.acceptableCodes.join(', ');
    final statusMessage = 'Status must be one of the accepted status codes: $acceptedCodes';
    final statusError = validateRequiredInt(request, key, statusMessage, min: 0);
    if (statusError != null) {
      return statusError;
    }

    final statusCode = request.data![key] as int;
    if (!RecordStatus.isAcceptableCode(statusCode)) {
      return badRequest(statusMessage);
    }

    return null;
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