import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/models/categories.dart';
import 'package:store_management/models/client.dart';
import 'package:store_management/models/company.dart';
import 'package:store_management/models/company_products.dart';
import 'package:store_management/models/product.dart';
import 'package:store_management/models/products_tags.dart';
import 'package:store_management/models/roles.dart';
import 'package:store_management/models/store_company.dart';
import 'package:store_management/models/store_financial_transaction.dart';
import 'package:store_management/models/user_roles.dart';
import 'package:store_management/models/store_invoice.dart';
import 'package:store_management/models/store_payment_voucher.dart';
import 'package:store_management/models/store_return.dart';
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
      final product = Product(
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
        userId: 1, userUuid: '11111111-1111-4111-8111-111111111111', roleId: 2, roleUuid: '22222222-2222-4222-8222-222222222222',
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
        companyId: 1,
        companyUuid: '11111111-1111-4111-8111-111111111111',
        productId: 2,
        productUuid: '22222222-2222-4222-8222-222222222222',
        price: 15.5,
        description: 'Retail price',
        stock: 20,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(companyProduct.uuid, isNotEmpty);
    });

    test('StoreCompany generates uuid automatically', () {
      final storeCompany = StoreCompany(
        id: 1,
        storeId: 1,
        storeUuid: '11111111-1111-4111-8111-111111111111',
        companyId: 2,
        companyUuid: '22222222-2222-4222-8222-222222222222',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(storeCompany.uuid, isNotEmpty);
    });

    test('ProductsTags generates uuid automatically', () {
      final productTag = ProductsTags(
        id: 1,
        productId: 2,
        productUuid: '22222222-2222-4222-8222-222222222222',
        tagId: 3,
        tagUuid: '33333333-3333-4333-8333-333333333333',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(productTag.uuid, isNotEmpty);
    });

    test('StoreInvoice generates uuid automatically', () {
      final invoice = StoreInvoice(
        id: 1,
        storeId: 1,
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientId: 2,
        clientUuid: '22222222-2222-4222-8222-222222222222',
        invoiceNumber: 'INV-001',
        totalAmount: 200,
        paidAmount: 50,
        balanceAmount: 150,
        notes: 'Monthly invoice',
        issuedAt: createdAt,
        dueAt: updatedAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(invoice.uuid, isNotEmpty);
    });

    test('StorePaymentVoucher generates uuid automatically', () {
      final voucher = StorePaymentVoucher(
        id: 1,
        storeId: 1,
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientId: 2,
        clientUuid: '22222222-2222-4222-8222-222222222222',
        voucherNumber: 'PV-001',
        payeeName: 'Vendor',
        amount: 100,
        paymentMethod: 'cash',
        referenceNumber: 'REF-001',
        description: 'Supplier payment',
        transactionDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(voucher.uuid, isNotEmpty);
    });

    test('StoreReturn generates uuid automatically', () {
      final storeReturn = StoreReturn(
        id: 1,
        storeId: 1,
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientId: 2,
        clientUuid: '22222222-2222-4222-8222-222222222222',
        returnNumber: 'RET-001',
        returnType: 'sales_return',
        itemCount: 3,
        totalAmount: 60,
        reason: 'Damaged items',
        transactionDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(storeReturn.uuid, isNotEmpty);
    });

    test('StoreFinancialTransaction generates uuid automatically', () {
      final transaction = StoreFinancialTransaction(
        id: 1,
        storeId: 1,
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientId: 2,
        clientUuid: '22222222-2222-4222-8222-222222222222',
        transactionNumber: 'FT-001',
        transactionType: 'invoice_posting',
        sourceType: 'invoice',
        sourceId: 1,
        sourceUuid: '44444444-4444-4444-8444-444444444444',
        amount: 200,
        entryType: 'debit',
        description: 'Invoice posting',
        transactionDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(transaction.uuid, isNotEmpty);
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
      final product = Product(
        id: 1,
        uuid: 'product-uuid',
        name: 'Rice',
        description: '1kg pack',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(Product.fromMap(product.toMap()), equals(product));
      expect(Product.fromJson(product.toJson()), equals(product));
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
        userId: 1,
        userUuid: '11111111-1111-4111-8111-111111111111',
        roleId: 2,
        roleUuid: '22222222-2222-4222-8222-222222222222',
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
        companyId: 1,
        companyUuid: '11111111-1111-4111-8111-111111111111',
        productId: 2,
        productUuid: '22222222-2222-4222-8222-222222222222',
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
        'companyId': 1,
        'companyUuid': '11111111-1111-4111-8111-111111111111',
        'productId': 2,
        'productUuid': '22222222-2222-4222-8222-222222222222',
        'price': 15,
        'description': 'Retail price',
        'stock': 20,
        'status': 1,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      });

      expect(companyProduct.price, 15.0);
    });

    test('StoreCompany round-trips through map and json', () {
      final storeCompany = StoreCompany(
        id: 1,
        uuid: 'store-company-uuid',
        storeId: 1,
        storeUuid: '11111111-1111-4111-8111-111111111111',
        companyId: 2,
        companyUuid: '22222222-2222-4222-8222-222222222222',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(StoreCompany.fromMap(storeCompany.toMap()), equals(storeCompany));
      expect(StoreCompany.fromJson(storeCompany.toJson()), equals(storeCompany));
    });

    test('ProductsTags round-trips through map and json', () {
      final productTag = ProductsTags(
        id: 1,
        uuid: 'product-tag-uuid',
        productId: 2,
        productUuid: '22222222-2222-4222-8222-222222222222',
        tagId: 3,
        tagUuid: '33333333-3333-4333-8333-333333333333',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(ProductsTags.fromMap(productTag.toMap()), equals(productTag));
      expect(ProductsTags.fromJson(productTag.toJson()), equals(productTag));
    });

    test('StoreInvoice round-trips through map and json', () {
      final invoice = StoreInvoice(
        id: 1,
        uuid: 'invoice-uuid',
        storeId: 1,
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientId: 2,
        clientUuid: '22222222-2222-4222-8222-222222222222',
        invoiceNumber: 'INV-001',
        totalAmount: 200,
        paidAmount: 50,
        balanceAmount: 150,
        notes: 'Monthly invoice',
        issuedAt: createdAt,
        dueAt: updatedAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(StoreInvoice.fromMap(invoice.toMap()), equals(invoice));
      expect(StoreInvoice.fromJson(invoice.toJson()), equals(invoice));
    });

    test('StorePaymentVoucher round-trips through map and json', () {
      final voucher = StorePaymentVoucher(
        id: 1,
        uuid: 'voucher-uuid',
        storeId: 1,
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientId: 2,
        clientUuid: '22222222-2222-4222-8222-222222222222',
        voucherNumber: 'PV-001',
        payeeName: 'Vendor',
        amount: 100,
        paymentMethod: 'cash',
        referenceNumber: 'REF-001',
        description: 'Supplier payment',
        transactionDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(StorePaymentVoucher.fromMap(voucher.toMap()), equals(voucher));
      expect(StorePaymentVoucher.fromJson(voucher.toJson()), equals(voucher));
    });

    test('StoreReturn round-trips through map and json', () {
      final storeReturn = StoreReturn(
        id: 1,
        uuid: 'return-uuid',
        storeId: 1,
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientId: 2,
        clientUuid: '22222222-2222-4222-8222-222222222222',
        returnNumber: 'RET-001',
        returnType: 'sales_return',
        itemCount: 3,
        totalAmount: 60,
        reason: 'Damaged items',
        transactionDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(StoreReturn.fromMap(storeReturn.toMap()), equals(storeReturn));
      expect(StoreReturn.fromJson(storeReturn.toJson()), equals(storeReturn));
    });

    test('StoreFinancialTransaction round-trips through map and json', () {
      final transaction = StoreFinancialTransaction(
        id: 1,
        uuid: 'financial-transaction-uuid',
        storeId: 1,
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientId: 2,
        clientUuid: '22222222-2222-4222-8222-222222222222',
        transactionNumber: 'FT-001',
        transactionType: 'invoice_posting',
        sourceType: 'invoice',
        sourceId: 1,
        sourceUuid: '44444444-4444-4444-8444-444444444444',
        amount: 200,
        entryType: 'debit',
        description: 'Invoice posting',
        transactionDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(StoreFinancialTransaction.fromMap(transaction.toMap()), equals(transaction));
      expect(StoreFinancialTransaction.fromJson(transaction.toJson()), equals(transaction));
    });

    test('Categories supports root nodes with null parentId', () {
      final category = Categories(id: 1, uuid: 'category-uuid', name: 'Root', description: 'Top level category', status: 1, parentId: null, createdAt: createdAt, updatedAt: updatedAt);

      expect(Categories.fromMap(category.toMap()), equals(category));
      expect(Categories.fromJson(category.toJson()), equals(category));
      expect(Categories.fromMap({...category.toMap(), 'parentId': null}).parentId, isNull);
    });

    test('Client accepts integer credit values from raw maps', () {
      final client = Client.fromMap({
        'id': 1,
        'uuid': 'client-uuid',
        'name': 'Retail buyer',
        'description': 'Preferred customer',
        'email': 'buyer@example.com',
        'phone': '123456789',
        'address': 'Main street',
        'status': 1,
        'creditLimit': 100,
        'currentCredit': 25,
        'availableCredit': 75,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      });

      expect(client.creditLimit, 100.0);
      expect(client.currentCredit, 25.0);
      expect(client.availableCredit, 75.0);
    });
  });
}