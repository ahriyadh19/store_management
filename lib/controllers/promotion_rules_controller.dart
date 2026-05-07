import 'package:store_management/controllers/controller_utils.dart';
import 'package:store_management/models/promotion_rule.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/promotion_rules_validation.dart';

class PromotionRulesController {
  PromotionRule? promotionRule;
  Request? request;
  Response? response;

  PromotionRulesController({this.promotionRule, this.request, this.response});

  Response _errorResponse(Object error) {
    return ControllerUtils.errorResponse(error);
  }

  Response read({required Request request}) {
    try {
      final validationError = PromotionRulesValidation.validateRead(request);
      if (validationError != null) {
        return validationError;
      }

      if (promotionRule == null || ControllerUtils.isSoftDeletedMap(promotionRule!.toMap())) {
        return ControllerUtils.notFound('Promotion rule');
      }

      return Response(statusCode: 200, title: 'Promotion Rule Fetched', message: 'The promotion rule has been fetched successfully', data: promotionRule);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response create({required Request request}) {
    try {
      final validationError = PromotionRulesValidation.validateCreate(request);
      if (validationError != null) {
        return validationError;
      }

      promotionRule = ControllerUtils.hydrateModelFromRequest(data: request.data!, fromMap: PromotionRule.fromMap,
      );

      return Response(statusCode: 201, title: 'Promotion Rule Added', message: 'The promotion rule has been added successfully', data: promotionRule);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response update({required Request request}) {
    try {
      final validationError = PromotionRulesValidation.validateUpdate(request);
      if (validationError != null) {
        return validationError;
      }

      if (promotionRule == null || ControllerUtils.isSoftDeletedMap(promotionRule!.toMap())) {
        return ControllerUtils.notFound('Promotion rule');
      }

      promotionRule = ControllerUtils.hydrateModelFromRequest(data: request.data!, existingModel: promotionRule, toMap: (model) => model.toMap(), fromMap: PromotionRule.fromMap,
      );

      return Response(statusCode: 200, title: 'Promotion Rule Updated', message: 'The promotion rule has been updated successfully', data: promotionRule);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response delete({required Request request}) {
    try {
      final validationError = PromotionRulesValidation.validateDelete(request);
      if (validationError != null) {
        return validationError;
      }

      if (promotionRule == null || ControllerUtils.isSoftDeletedMap(promotionRule!.toMap())) {
        return ControllerUtils.notFound('Promotion rule');
      }

      final deletedPromotionRule = ControllerUtils.softDeleteModel(
        model: promotionRule!,
        toMap: (model) => model.toMap(),
        fromMap: PromotionRule.fromMap,
      );
      promotionRule = deletedPromotionRule;
      return Response(statusCode: 200, title: 'Promotion Rule Deleted', message: 'The promotion rule has been deleted successfully', data: deletedPromotionRule);
    } catch (error) {
      return _errorResponse(error);
    }
  }

  Response all({required Request request}) {
    try {
      final validationError = PromotionRulesValidation.validateAll(request);
      if (validationError != null) {
        return validationError;
      }

      final promotionRules = promotionRule == null || ControllerUtils.isSoftDeletedMap(promotionRule!.toMap()) ? <PromotionRule>[] : <PromotionRule>[promotionRule!];
      return Response(statusCode: 200, title: 'Promotion Rules Fetched', message: 'The promotion rules have been fetched successfully', data: promotionRules);
    } catch (error) {
      return _errorResponse(error);
    }
  }
}
