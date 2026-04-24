import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/company_products_controller.dart';
import 'package:store_management/models/company_products.dart';
import 'package:store_management/services/request.dart';

void main() {
  final createdAt = DateTime.fromMillisecondsSinceEpoch(1713744000000);
  final updatedAt = DateTime.fromMillisecondsSinceEpoch(1713830400000);

  CompanyProducts buildProduct() {
    return CompanyProducts(
      id: 1,
      uuid: 'company-product-uuid',
      companyId: 'company-1',
      productId: 'product-1',
      price: 15.5,
      description: 'Retail price',
      stock: 20,
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
    String companyId = 'company-1',
    String productId = 'product-1',
    String description = 'Retail price',
    num price = 15.5,
    int stock = 20,
    int? quantity,
    int? availableStock,
  }) {
    final data = <String, dynamic>{
      'companyId': companyId,
      'productId': productId,
      'description': description,
      'price': price,
      'stock': stock,
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

  group('CompanyProductsController responses', () {
    test('create returns created response with product data', () {
      final controller = CompanyProductsController(companyProduct: buildProduct());

      final response = controller.create(request: buildRequest(data: buildProductData()));

      expect(response.statusCode, 201);
      expect(response.data, isA<CompanyProducts>());
      expect(response.data?.id, 1);
    });

    test('create validates required product fields', () {
      final controller = CompanyProductsController(
        companyProduct: buildProduct().copyWith(description: ''),
      );

      final response = controller.create(
        request: buildRequest(data: buildProductData(description: '')),
      );

      expect(response.statusCode, 400);
      expect(response.message, 'Description is required');
    });

    test('read returns not found when controller has no product', () {
      final controller = CompanyProductsController();

      final response = controller.read(request: buildRequest(data: {'id': 1}));

      expect(response.statusCode, 404);
      expect(response.message, 'Company product was not found');
    });

    test('delete returns success when product exists', () {
      final controller = CompanyProductsController(companyProduct: buildProduct());

      final response = controller.delete(request: buildRequest(data: {'id': 1}));

      expect(response.statusCode, 200);
      expect(response.data, isA<CompanyProducts>());
    });

    test('all validates request title', () {
      final controller = CompanyProductsController(companyProduct: buildProduct());

      final response = controller.all(request: buildRequest(title: ''));

      expect(response.statusCode, 400);
      expect(response.message, 'Request title is required');
    });

    test('sell returns bad request response for invalid quantity', () {
      final controller = CompanyProductsController(companyProduct: buildProduct());

      final response = controller.sell(
        request: buildRequest(data: {'id': 1, 'quantity': 0}),
      );

      expect(response.statusCode, 400);
      expect(response.title, 'Bad Request');
      expect(response.message, 'Quantity must be greater than zero');
      expect(controller.companyProduct!.stock, 20);
    });

    test('sell requires integer product id in request', () {
      final controller = CompanyProductsController(companyProduct: buildProduct());

      final response = controller.sell(
        request: buildRequest(data: {'id': '1', 'quantity': 2}),
      );

      expect(response.statusCode, 400);
      expect(response.title, 'Bad Request');
  expect(response.message, 'Product id is required');
  expect(controller.companyProduct!.stock, 20);
    });

    test('sell updates stock and returns success response', () {
      final controller = CompanyProductsController(companyProduct: buildProduct());

      final response = controller.sell(
        request: buildRequest(data: {'id': 1, 'quantity': 5, 'availableStock': 20}),
      );

      expect(response.statusCode, 200);
      expect(response.data?.stock, 15);
      expect(controller.companyProduct!.stock, 15);
    });

    test('sell validates stock availability', () {
      final controller = CompanyProductsController(companyProduct: buildProduct());

      final response = controller.sell(
        request: buildRequest(data: {'id': 1, 'quantity': 25, 'availableStock': 20}),
      );

      expect(response.statusCode, 400);
      expect(response.message, 'Quantity cannot be greater than available stock');
    });

    test('restock validates quantity type', () {
      final controller = CompanyProductsController(companyProduct: buildProduct());

      final response = controller.restock(
        request: buildRequest(data: {'id': 1, 'quantity': '5'}),
      );

      expect(response.statusCode, 400);
      expect(response.message, 'Quantity must be provided as an integer');
    });

    test('all returns product list response', () {
      final controller = CompanyProductsController(companyProduct: buildProduct());

      final response = controller.all(request: buildRequest());

      expect(response.statusCode, 200);
      expect(response.data, isA<List<CompanyProducts>>());
      expect(response.data, isEmpty);
    });
  });
}