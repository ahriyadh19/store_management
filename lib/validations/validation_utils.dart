import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/models/model_enums.dart';

class ValidationUtils {
  static const int _maxRequestTitleLength = 120;
  static const int _maxRequestMessageLength = 2000;
  static const int _maxEmailLength = 254;
  static final RegExp _uuidPattern = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$');
  static final RegExp _usernamePattern = RegExp(r'^[a-zA-Z0-9_]{3,30}$');

  static Response badRequest(String message) {
    return Response(statusCode: 400, title: 'Bad Request', message: message);
  }

  static Response? validateRequestMetadata(Request request) {
    final trimmedTitle = request.title.trim();
    if (trimmedTitle.isEmpty) {
      return badRequest('Request title is required');
    }

    if (trimmedTitle.length > _maxRequestTitleLength) {
      return badRequest('Request title is too long');
    }

    final trimmedMessage = request.message.trim();
    if (trimmedMessage.isEmpty) {
      return badRequest('Request message is required');
    }

    if (trimmedMessage.length > _maxRequestMessageLength) {
      return badRequest('Request message is too long');
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

  static Response? validateOptionalEnumString(Request request, String key, String message, Object Function(String value) parser) {
    final value = request.data?[key];
    if (value == null) {
      return null;
    }

    if (value is! String || value.trim().isEmpty) {
      return badRequest(message);
    }

    try {
      parser(value.trim());
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

    final normalized = value.trim();
    if (normalized.length > _maxEmailLength) {
      return badRequest('Email format is invalid');
    }

    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(normalized)) {
      return badRequest('Email format is invalid');
    }

    return null;
  }

  static Response? validateUsername(Request request, {String key = 'username'}) {
    final value = request.data?[key];
    if (value is! String || value.trim().isEmpty) {
      return badRequest('Username is required');
    }

    final normalized = value.trim();
    if (!_usernamePattern.hasMatch(normalized)) {
      return badRequest('Username must be 3-30 chars and use letters, numbers, or underscores only');
    }

    return null;
  }
}