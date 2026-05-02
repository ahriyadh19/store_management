import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/supplier_products_controller.dart';
import 'package:store_management/models/supplier_products.dart';
import 'package:store_management/services/request.dart';

void main() {
	final createdAt = DateTime.fromMillisecondsSinceEpoch(1713744000000);
	final updatedAt = DateTime.fromMillisecondsSinceEpoch(1713830400000);

	SupplierProducts buildProduct() {
		return SupplierProducts(
			id: 1,
			uuid: 'supplier-product-uuid',
			supplierUuid: '11111111-1111-4111-8111-111111111111',
			productUuid: '22222222-2222-4222-8222-222222222222',
			price: Decimal.parse('15.5'),
			costPrice: Decimal.parse('10'),
			description: 'Retail price',
			sku: 'RICE-001',
			barcode: '1234567890123',
			stock: 20,
			reorderLevel: 5,
			reorderQuantity: 10,
			status: 1,
			createdAt: createdAt,
			updatedAt: updatedAt,
		);
	}

	Request buildRequest({Map<String, dynamic>? data, String title = 'Request', String message = 'Controller request'}) {
		return Request(
			title: title,
			message: message,
			data: data,
		);
	}

	Map<String, dynamic> buildProductData({
		int? id,
		String supplierUuid = '11111111-1111-4111-8111-111111111111',
		String productUuid = '22222222-2222-4222-8222-222222222222',
		String description = 'Retail price',
		num price = 15.5,
		num? costPrice = 10,
		String? sku = 'RICE-001',
		String? barcode = '1234567890123',
		int stock = 20,
		int? reorderLevel = 5,
		int? reorderQuantity = 10,
		int status = 1,
		int? quantity,
		int? availableStock,
	}) {
		final data = <String, dynamic>{
			'supplierUuid': supplierUuid,
			'productUuid': productUuid,
			'description': description,
			'price': price,
			'costPrice': costPrice,
			'sku': sku,
			'barcode': barcode,
			'stock': stock,
			'reorderLevel': reorderLevel,
			'reorderQuantity': reorderQuantity,
			'status': status,
		};

		if (id != null) {
			data['id'] = id;
		}

		if (quantity != null) {
			data['quantity'] = quantity;
		}

		if (availableStock != null) {
			data['availableStock'] = availableStock;
		}

		return data;
	}

	group('SupplierProductsController responses', () {
		test('create returns created response with product data', () {
			final controller = SupplierProductsController(supplierProduct: buildProduct());

			final response = controller.create(request: buildRequest(data: buildProductData(id: 1)));

			expect(response.statusCode, 201);
			expect(response.data, isA<SupplierProducts>());
			expect(response.data?.id, 1);
			expect(response.data?.price, Decimal.parse('15.5'));
		});

		test('create validates required product fields', () {
			final controller = SupplierProductsController(
				supplierProduct: buildProduct().copyWith(description: ''),
			);

			final response = controller.create(
				request: buildRequest(data: buildProductData(description: '')),
			);

			expect(response.statusCode, 400);
			expect(response.message, 'Description is required');
		});

		test('read returns not found when controller has no product', () {
			final controller = SupplierProductsController();

			final response = controller.read(request: buildRequest(data: {'id': 1}));

			expect(response.statusCode, 404);
			expect(response.message, 'Supplier product was not found');
		});

		test('delete returns success when product exists', () {
			final controller = SupplierProductsController(supplierProduct: buildProduct());

			final response = controller.delete(request: buildRequest(data: {'id': 1}));

			expect(response.statusCode, 200);
			expect(response.data, isA<SupplierProducts>());
		});

		test('all validates request title', () {
			final controller = SupplierProductsController(supplierProduct: buildProduct());

			final response = controller.all(request: buildRequest(title: ''));

			expect(response.statusCode, 400);
			expect(response.message, 'Request title is required');
		});

		test('sell returns bad request response for invalid quantity', () {
			final controller = SupplierProductsController(supplierProduct: buildProduct());

			final response = controller.sell(
				request: buildRequest(data: {'id': 1, 'quantity': 0}),
			);

			expect(response.statusCode, 400);
			expect(response.title, 'Bad Request');
			expect(response.message, 'Quantity must be greater than zero');
			expect(controller.supplierProduct!.stock, 20);
		});

		test('sell requires integer product id in request', () {
			final controller = SupplierProductsController(supplierProduct: buildProduct());

			final response = controller.sell(
				request: buildRequest(data: {'id': '1', 'quantity': 2}),
			);

			expect(response.statusCode, 400);
			expect(response.title, 'Bad Request');
			expect(response.message, 'Product id is required');
			expect(controller.supplierProduct!.stock, 20);
		});

		test('sell updates stock and returns success response', () {
			final controller = SupplierProductsController(supplierProduct: buildProduct());

			final response = controller.sell(
				request: buildRequest(data: {'id': 1, 'quantity': 5, 'availableStock': 20}),
			);

			expect(response.statusCode, 200);
			expect(response.data?.stock, 15);
			expect(controller.supplierProduct!.stock, 15);
		});

		test('sell validates stock availability', () {
			final controller = SupplierProductsController(supplierProduct: buildProduct());

			final response = controller.sell(
				request: buildRequest(data: {'id': 1, 'quantity': 25, 'availableStock': 20}),
			);

			expect(response.statusCode, 400);
			expect(response.message, 'Quantity cannot be greater than available stock');
		});

		test('restock validates quantity type', () {
			final controller = SupplierProductsController(supplierProduct: buildProduct());

			final response = controller.restock(
				request: buildRequest(data: {'id': 1, 'quantity': '5'}),
			);

			expect(response.statusCode, 400);
			expect(response.message, 'Quantity must be provided as an integer');
		});

		test('all returns product list response', () {
			final controller = SupplierProductsController(supplierProduct: buildProduct());

			final response = controller.all(request: buildRequest());

			expect(response.statusCode, 200);
			expect(response.data, isA<List<SupplierProducts>>());
			expect(response.data, hasLength(1));
			expect((response.data as List<SupplierProducts>).single.id, 1);
		});
	});
}
