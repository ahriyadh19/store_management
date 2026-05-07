import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class BranchPricesValidation {
  static const Set<String> _allowedPriceTypes = <String>{'regular', 'promo', 'clearance'};

  static Response? validateRead(Request request) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    return ValidationUtils.validateRequiredInt(request, 'id', 'Branch price id is required');
  }

  static Response? validateCreate(Request request) => _validateUpsert(request, requireId: false);
  static Response? validateUpdate(Request request) => _validateUpsert(request, requireId: true);
  static Response? validateDelete(Request request) => validateRead(request);
  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateUpsert(Request request, {required bool requireId}) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Branch price id is required');
      if (idError != null) return idError;
    }
    final owner = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (owner != null) return owner;
    final branch = ValidationUtils.validateRequiredUuid(request, 'branchUuid', 'Branch uuid must be a valid UUID');
    if (branch != null) return branch;
    final product = ValidationUtils.validateRequiredUuid(request, 'productUuid', 'Product uuid must be a valid UUID');
    if (product != null) return product;
    final type = ValidationUtils.validateRequiredString(request, 'priceType', 'Price type is required');
    if (type != null) return type;
    final priceType = (request.data?['priceType'] as String).trim().toLowerCase();
    if (!_allowedPriceTypes.contains(priceType)) return ValidationUtils.badRequest('Price type is invalid');
    final price = ValidationUtils.validateRequiredNum(request, 'price', 'Price must be zero or greater', min: 0);
    if (price != null) return price;
    final starts = ValidationUtils.validateOptionalInt(request, 'startsAt', 'Starts at must be a non-negative timestamp', min: 0);
    if (starts != null) return starts;
    final ends = ValidationUtils.validateOptionalInt(request, 'endsAt', 'Ends at must be a non-negative timestamp', min: 0);
    if (ends != null) return ends;
    final priority = ValidationUtils.validateOptionalInt(request, 'priority', 'Priority must be zero or greater', min: 0);
    if (priority != null) return priority;
    return ValidationUtils.validateRequiredInt(request, 'status', 'Status is required', min: 0);
  }
}
