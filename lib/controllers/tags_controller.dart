import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/tags.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/tags_validation.dart';

class TagsController {
  Tags? tag;
  Request? request;
  Response? response;

  TagsController({this.tag, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = TagsValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (tag == null) {
        return ControllerUtils.notFound('Tag');
      }

      return Response(statusCode: 200, title: 'Tag Fetched', message: 'The tag has been fetched successfully', data: tag);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = TagsValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      final now = DateTime.now();
      tag = Tags(
        id: request.data?['id'] as int?,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        status: request.data!['status'] as int,
        createdAt: now,
        updatedAt: now,
      );

      return Response(statusCode: 201, title: 'Tag Added', message: 'The tag has been added successfully', data: tag);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = TagsValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (tag == null) {
        return ControllerUtils.notFound('Tag');
      }

      tag = tag?.copyWith(
        id: request.data!['id'] as int,
        name: request.data!['name'] as String,
        description: request.data!['description'] as String,
        status: request.data!['status'] as int,
        updatedAt: DateTime.now(),
      );

      return Response(statusCode: 200, title: 'Tag Updated', message: 'The tag has been updated successfully', data: tag);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = TagsValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (tag == null) {
        return ControllerUtils.notFound('Tag');
      }

      final deletedTag = tag;
      tag = null;
      return Response(statusCode: 200, title: 'Tag Deleted', message: 'The tag has been deleted successfully', data: deletedTag);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = TagsValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final tags = tag == null ? <Tags>[] : <Tags>[tag!];
      return Response(statusCode: 200, title: 'Tags Fetched', message: 'The tags have been fetched successfully', data: tags);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}