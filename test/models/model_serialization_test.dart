import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/models/company.dart';
import 'package:store_management/models/company_products.dart';
import 'package:store_management/models/products.dart';
import 'package:store_management/models/roles.dart';
import 'package:store_management/models/user_roles.dart';
import 'package:store_management/models/users.dart';

void main() {
  final createdAt = DateTime.fromMillisecondsSinceEpoch(1713744000000);
  final updatedAt = DateTime.fromMillisecondsSinceEpoch(1713830400000);

  group('model uuid generation', () {
    test('Company generates uuid automatically', () {
      final company = Company(
        id: 1,
        name: 'Store Co',
        description: 'Main supplier',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(company.uuid, isNotEmpty);
    });

    test('Products generates uuid automatically', () {
      final product = Products(
        id: 1,
        name: 'Rice',
        description: '1kg pack',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(product.uuid, isNotEmpty);
    });

    test('Roles generates uuid automatically', () {
      final role = Roles(
        id: 1,
        name: 'Admin',
        description: 'System administrator',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(role.uuid, isNotEmpty);
    });

    test('UserRoles generates uuid automatically', () {
      final userRole = UserRoles(
        id: 1,
        userId: 'user-1',
        roleId: 'role-1',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(userRole.uuid, isNotEmpty);
    });

    test('User generates uuid automatically', () {
      final user = User(
        email: 'owner@example.com',
        id: 1,
        name: 'Owner',
        password: 'secret',
        username: 'owner',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(user.uuid, isNotEmpty);
    });

    test('CompanyProducts generates uuid automatically', () {
      final companyProduct = CompanyProducts(
        id: 1,
        companyId: 'company-1',
        productId: 'product-1',
        price: 15.5,
        description: 'Retail price',
        stock: 20,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(companyProduct.uuid, isNotEmpty);
    });
  });

  group('model serialization', () {
    test('Company round-trips through map and json', () {
      final company = Company(
        id: 1,
        uuid: 'company-uuid',
        name: 'Store Co',
        description: 'Main supplier',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(Company.fromMap(company.toMap()), equals(company));
      expect(Company.fromJson(company.toJson()), equals(company));
    });

    test('Products round-trips through map and json', () {
      final product = Products(
        id: 1,
        uuid: 'product-uuid',
        name: 'Rice',
        description: '1kg pack',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(Products.fromMap(product.toMap()), equals(product));
      expect(Products.fromJson(product.toJson()), equals(product));
    });

    test('Roles round-trips through map and json', () {
      final role = Roles(
        id: 1,
        uuid: 'role-uuid',
        name: 'Admin',
        description: 'System administrator',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(Roles.fromMap(role.toMap()), equals(role));
      expect(Roles.fromJson(role.toJson()), equals(role));
    });

    test('UserRoles round-trips through map and json', () {
      final userRole = UserRoles(
        id: 1,
        uuid: 'user-role-uuid',
        userId: 'user-1',
        roleId: 'role-1',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(UserRoles.fromMap(userRole.toMap()), equals(userRole));
      expect(UserRoles.fromJson(userRole.toJson()), equals(userRole));
    });

    test('User round-trips through map and json', () {
      final user = User(
        email: 'owner@example.com',
        id: 1,
        name: 'Owner',
        password: 'secret',
        username: 'owner',
        uuid: 'user-uuid',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(User.fromMap(user.toMap(includePassword: true)), equals(user));
      expect(User.fromJson(user.toJson(includePassword: true)), equals(user));
    });

    test('User omits password from default serialization', () {
      final user = User(
        email: 'owner@example.com',
        id: 1,
        name: 'Owner',
        password: 'secret',
        username: 'owner',
        uuid: 'user-uuid',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(user.toMap().containsKey('password'), isFalse);
      expect(user.toJson(), isNot(contains('secret')));
    });

    test('User redacts password from debug output', () {
      final user = User(
        email: 'owner@example.com',
        id: 1,
        name: 'Owner',
        password: 'secret',
        username: 'owner',
        uuid: 'user-uuid',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(user.toString(), isNot(contains('secret')));
      expect(user.toString(), contains('password: ***'));
    });

    test('CompanyProducts round-trips through map and json', () {
      final companyProduct = CompanyProducts(
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

      expect(CompanyProducts.fromMap(companyProduct.toMap()), equals(companyProduct));
      expect(CompanyProducts.fromJson(companyProduct.toJson()), equals(companyProduct));
    });

    test('CompanyProducts accepts integer price values from raw maps', () {
      final companyProduct = CompanyProducts.fromMap({
        'id': 1,
        'uuid': 'company-product-uuid',
        'companyId': 'company-1',
        'productId': 'product-1',
        'price': 15,
        'description': 'Retail price',
        'stock': 20,
        'status': 1,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      });

      expect(companyProduct.price, 15.0);
    });
  });
}