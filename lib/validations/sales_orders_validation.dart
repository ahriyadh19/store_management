import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class SalesOrdersValidation {
  static const Set<String> _allowedStatuses = <String>{'draft', 'confirmed', 'fulfilled', 'cancelled'};
  static const Set<String> _allowedPricingStrategies = <String>{'branch', 'store'};

  static Response? validateRead(Request request) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    return ValidationUtils.validateRequiredInt(request, 'id', 'Sales order id is required');
  }

  static Response? validateCreate(Request request) => _validateUpsert(request, requireId: false);
  static Response? validateUpdate(Request request) => _validateUpsert(request, requireId: true);
  static Response? validateDelete(Request request) => validateRead(request);
  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateUpsert(Request request, {required bool requireId}) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Sales order id is required');
      if (idError != null) return idError;
    }
    final owner = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (owner != null) return owner;
    final store = ValidationUtils.validateRequiredUuid(request, 'storeUuid', 'Store uuid must be a valid UUID');
    if (store != null) return store;
    final branch = ValidationUtils.validateRequiredUuid(request, 'branchUuid', 'Branch uuid must be a valid UUID');
    if (branch != null) return branch;
    final customer = ValidationUtils.validateOptionalUuid(request, 'customerUuid', 'Customer uuid must be a valid UUID');
    if (customer != null) return customer;
    final number = ValidationUtils.validateRequiredString(request, 'orderNumber', 'Order number is required');
    if (number != null) return number;
    final orderDate = ValidationUtils.validateRequiredInt(request, 'orderDate', 'Order date timestamp is required', min: 0);
    if (orderDate != null) return orderDate;
    final statusError = ValidationUtils.validateRequiredString(request, 'status', 'Sales order status is required');
    if (statusError != null) return statusError;
    final status = (request.data?['status'] as String).trim().toLowerCase();
    if (!_allowedStatuses.contains(status)) return ValidationUtils.badRequest('Sales order status is invalid');
    final pricing = ValidationUtils.validateRequiredString(request, 'pricingStrategy', 'Pricing strategy is required');
    if (pricing != null) return pricing;
    final strategy = (request.data?['pricingStrategy'] as String).trim().toLowerCase();
    if (!_allowedPricingStrategies.contains(strategy)) return ValidationUtils.badRequest('Pricing strategy is invalid');
    return ValidationUtils.validateOptionalUuid(request, 'createdByUserUuid', 'Created by user uuid must be a valid UUID');
  }
}
