import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class SalesInvoicesValidation {
  static const Set<String> _allowedStatuses = <String>{'open', 'partially_paid', 'paid', 'void'};

  static Response? validateRead(Request request) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    return ValidationUtils.validateRequiredInt(request, 'id', 'Sales invoice id is required');
  }

  static Response? validateCreate(Request request) => _validateUpsert(request, requireId: false);
  static Response? validateUpdate(Request request) => _validateUpsert(request, requireId: true);
  static Response? validateDelete(Request request) => validateRead(request);
  static Response? validateAll(Request request) => ValidationUtils.validateRequestMetadata(request);

  static Response? _validateUpsert(Request request, {required bool requireId}) {
    final metadata = ValidationUtils.validateRequestMetadata(request);
    if (metadata != null) return metadata;
    if (requireId) {
      final idError = ValidationUtils.validateRequiredInt(request, 'id', 'Sales invoice id is required');
      if (idError != null) return idError;
    }
    final owner = ValidationUtils.validateRequiredUuid(request, 'ownerUuid', 'Owner uuid must be a valid UUID');
    if (owner != null) return owner;
    final store = ValidationUtils.validateRequiredUuid(request, 'storeUuid', 'Store uuid must be a valid UUID');
    if (store != null) return store;
    final branch = ValidationUtils.validateRequiredUuid(request, 'branchUuid', 'Branch uuid must be a valid UUID');
    if (branch != null) return branch;
    final so = ValidationUtils.validateOptionalUuid(request, 'salesOrderUuid', 'Sales order uuid must be a valid UUID');
    if (so != null) return so;
    final customer = ValidationUtils.validateOptionalUuid(request, 'customerUuid', 'Customer uuid must be a valid UUID');
    if (customer != null) return customer;
    final number = ValidationUtils.validateRequiredString(request, 'invoiceNumber', 'Invoice number is required');
    if (number != null) return number;
    final issued = ValidationUtils.validateRequiredInt(request, 'issuedAt', 'Issued at timestamp is required', min: 0);
    if (issued != null) return issued;
    final code = ValidationUtils.validateRequiredString(request, 'currencyCode', 'Currency code is required');
    if (code != null) return code;
    for (final key in <String>['subtotal', 'discountAmount', 'taxAmount', 'totalAmount', 'paidAmount']) {
      final err = ValidationUtils.validateRequiredNum(request, key, '$key must be zero or greater', min: 0);
      if (err != null) return err;
    }
    final statusError = ValidationUtils.validateRequiredString(request, 'status', 'Sales invoice status is required');
    if (statusError != null) return statusError;
    final status = (request.data?['status'] as String).trim().toLowerCase();
    if (!_allowedStatuses.contains(status)) return ValidationUtils.badRequest('Sales invoice status is invalid');
    return ValidationUtils.validateOptionalUuid(request, 'createdByUserUuid', 'Created by user uuid must be a valid UUID');
  }
}
