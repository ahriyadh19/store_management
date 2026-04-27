import 'package:store_management/services/request.dart';
import 'package:store_management/services/response.dart';
import 'package:store_management/validations/validation_utils.dart';

class CompanyProductsValidation {
	static Response _badRequest(String message) {
		return Response(statusCode: 400, title: 'Bad Request', message: message);
	}

	static Response? validateRead(Request request) {
		final metadataError = ValidationUtils.validateRequestMetadata(request);
		if (metadataError != null) {
			return metadataError;
		}

		return _validateRequiredInt(request, 'id', 'Product id is required');
	}

	static Response? validateCreate(Request request) {
		final metadataError = ValidationUtils.validateRequestMetadata(request);
		if (metadataError != null) {
			return metadataError;
		}

		return _validateCreateOrUpdateFields(request, requireId: false);
	}

	static Response? validateUpdate(Request request) {
		final metadataError = ValidationUtils.validateRequestMetadata(request);
		if (metadataError != null) {
			return metadataError;
		}

		return _validateCreateOrUpdateFields(request, requireId: true);
	}

	static Response? validateDelete(Request request) {
		final metadataError = ValidationUtils.validateRequestMetadata(request);
		if (metadataError != null) {
			return metadataError;
		}

		return _validateRequiredInt(request, 'id', 'Product id is required');
	}

	static Response? validateAll(Request request) {
		return ValidationUtils.validateRequestMetadata(request);
	}

	static Response? validateSell(Request request) {
		final metadataError = ValidationUtils.validateRequestMetadata(request);
		if (metadataError != null) {
			return metadataError;
		}

		final idError = _validateRequiredInt(request, 'id', 'Product id is required');
		if (idError != null) {
			return idError;
		}

		final quantityError = _validateQuantity(request);
		if (quantityError != null) {
			return quantityError;
		}

		final availableStock = request.data?['availableStock'];
		if (availableStock != null) {
			if (availableStock is! int) {
				return _badRequest('Available stock must be provided as an integer');
			}

			final quantity = request.data!['quantity'] as int;
			if (quantity > availableStock) {
				return _badRequest('Quantity cannot be greater than available stock');
			}
		}

		return null;
	}

	static Response? validateRestock(Request request) {
		final metadataError = ValidationUtils.validateRequestMetadata(request);
		if (metadataError != null) {
			return metadataError;
		}

		final idError = _validateRequiredInt(request, 'id', 'Product id is required');
		if (idError != null) {
			return idError;
		}

		return _validateQuantity(request);
	}

	static Response? _validateRequiredString(Request request, String key, String message) {
		final value = request.data?[key];
		if (value is! String || value.trim().isEmpty) {
			return _badRequest(message);
		}

		return null;
	}

  static Response? _validateRequiredUuid(Request request, String key, String message) {
    final stringError = _validateRequiredString(request, key, message);
    if (stringError != null) {
      return stringError;
    }

    final value = (request.data![key] as String).trim();
    final uuidPattern = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$');
    if (!uuidPattern.hasMatch(value)) {
      return _badRequest(message);
    }

    return null;
  }

	static Response? _validateRequiredInt(Request request, String key, String message) {
		final value = request.data?[key];
		if (value is! int || value <= 0) {
			return _badRequest(message);
		}

		return null;
	}

	static Response? _validateCreateOrUpdateFields(Request request, {required bool requireId}) {
		if (requireId) {
			final idError = _validateRequiredInt(request, 'id', 'Product id is required');
			if (idError != null) {
				return idError;
			}
		}

    final companyIdError = _validateRequiredUuid(request, 'companyId', 'Company id reference must be a valid UUID');
		if (companyIdError != null) {
			return companyIdError;
		}

    final productIdError = _validateRequiredUuid(request, 'productId', 'Product id reference must be a valid UUID');
		if (productIdError != null) {
			return productIdError;
		}

		final descriptionError = _validateRequiredString(request, 'description', 'Description is required');
		if (descriptionError != null) {
			return descriptionError;
		}

		final price = request.data?['price'];
		if (price is! num) {
			return _badRequest('Price must be provided as a number');
		}

		if (price < 0) {
			return _badRequest('Price must be zero or greater');
		}

		final stock = request.data?['stock'];
		if (stock is! int) {
			return _badRequest('Stock must be provided as an integer');
		}

		if (stock < 0) {
			return _badRequest('Stock must be zero or greater');
		}

		final statusError = ValidationUtils.validateStatus(request);
		if (statusError != null) {
			return statusError;
		}

		return null;
	}

	static Response? _validateQuantity(Request request) {
		final quantity = request.data?['quantity'];
		if (quantity is! int) {
			return _badRequest('Quantity must be provided as an integer');
		}

		if (quantity <= 0) {
			return _badRequest('Quantity must be greater than zero');
		}

		return null;
	}
}