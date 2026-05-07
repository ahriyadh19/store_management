import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class PromotionRulesValidation {
  static const Set<String> _allowedDiscountTypes = <String>{'percent', 'fixed'};

  static Response? validateRead(Request request) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    return ValidationUtils.validateRequiredInt(request, 'id', 'Promotion rule id is required');
  }

  static Response? validateCreate(Request request) => _validateUpsert(request, requireId: false);
  static Response? validateUpdate(Request request) => _validateUpsert(request, requireId: true);
  static Response? validateDelete(Request request) => validateRead(request);
  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateUpsert(Request request, {required bool requireId}) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Promotion rule id is required');
      if (idError != null) return idError;
    }
    final owner = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (owner != null) return owner;
    final name = ValidationUtils.validateRequiredString(request, 'name', 'Promotion name is required');
    if (name != null) return name;
    final branch = ValidationUtils.validateOptionalUuid(request, 'branchUuid', 'Branch uuid must be a valid UUID');
    if (branch != null) return branch;
    final product = ValidationUtils.validateOptionalUuid(request, 'productUuid', 'Product uuid must be a valid UUID');
    if (product != null) return product;
    final discountType = ValidationUtils.validateRequiredString(request, 'discountType', 'Discount type is required');
    if (discountType != null) return discountType;
    final normalizedType = (request.data?['discountType'] as String).trim().toLowerCase();
    if (!_allowedDiscountTypes.contains(normalizedType)) return ValidationUtils.badRequest('Discount type is invalid');
    final discount = ValidationUtils.validateRequiredNum(request, 'discountValue', 'Discount value must be zero or greater', min: 0);
    if (discount != null) return discount;
    final starts = ValidationUtils.validateRequiredInt(request, 'startsAt', 'Starts at timestamp is required', min: 0);
    if (starts != null) return starts;
    final ends = ValidationUtils.validateOptionalInt(request, 'endsAt', 'Ends at must be a non-negative timestamp', min: 0);
    if (ends != null) return ends;
    return ValidationUtils.validateRequiredInt(request, 'status', 'Status is required', min: 0);
  }
}
