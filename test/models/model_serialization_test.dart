import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/models/categories.dart';
import 'package:store_management/models/client.dart';
import 'package:store_management/models/company.dart';
import 'package:store_management/models/company_products.dart';
import 'package:store_management/models/inventory_movement.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/payment_allocation.dart';
import 'package:store_management/models/product.dart';
import 'package:store_management/models/products_tags.dart';
import 'package:store_management/models/roles.dart';
import 'package:store_management/models/store_company.dart';
import 'package:store_management/models/store_financial_transaction.dart';
import 'package:store_management/models/store_invoice.dart';
import 'package:store_management/models/store_invoice_item.dart';
import 'package:store_management/models/store_payment_voucher.dart';
import 'package:store_management/models/store_return.dart';
import 'package:store_management/models/store_return_item.dart';
import 'package:store_management/models/store_user.dart';
import 'package:store_management/models/user_roles.dart';
import 'package:store_management/models/users.dart';

Decimal money(String value) => Decimal.parse(value);

void main() {
  final createdAt = DateTime.fromMillisecondsSinceEpoch(1713744000000);
  final updatedAt = DateTime.fromMillisecondsSinceEpoch(1713830400000);

  group('model uuid generation', () {
    test('detail models generate uuid automatically', () {
      final invoiceItem = StoreInvoiceItem(
        invoiceUuid: '11111111-1111-4111-8111-111111111111',
        companyProductUuid: '22222222-2222-4222-8222-222222222222',
        productUuid: '33333333-3333-4333-8333-333333333333',
        quantity: 2,
        unitPrice: money('20'),
        discountAmount: money('0'),
        taxAmount: money('2'),
        lineTotal: money('42'),
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final returnItem = StoreReturnItem(
        returnUuid: '11111111-1111-4111-8111-111111111111',
        companyProductUuid: '22222222-2222-4222-8222-222222222222',
        productUuid: '33333333-3333-4333-8333-333333333333',
        quantity: 1,
        unitPrice: money('20'),
        lineTotal: money('20'),
        reason: 'Damaged box',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final movement = InventoryMovement(
        companyProductUuid: '22222222-2222-4222-8222-222222222222',
        productUuid: '33333333-3333-4333-8333-333333333333',
        movementType: InventoryMovementType.sale,
        quantityDelta: -2,
        balanceAfter: 18,
        referenceType: InventoryReferenceType.invoiceItem,
        note: 'Invoice issue',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final allocation = PaymentAllocation(
        paymentVoucherUuid: '11111111-1111-4111-8111-111111111111',
        invoiceUuid: '22222222-2222-4222-8222-222222222222',
        allocatedAmount: money('100'),
        allocationDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(invoiceItem.uuid, isNotEmpty);
      expect(returnItem.uuid, isNotEmpty);
      expect(movement.uuid, isNotEmpty);
      expect(allocation.uuid, isNotEmpty);
    });
  });

  group('model serialization', () {
    test('nullable fields can be explicitly cleared via copyWith', () {
      final companyProduct = CompanyProducts(
        id: 1,
        uuid: 'company-product-uuid',
        companyUuid: '11111111-1111-4111-8111-111111111111',
        productUuid: '22222222-2222-4222-8222-222222222222',
        price: money('15.50'),
        costPrice: money('10.25'),
        description: 'Retail price',
        sku: 'RICE-001',
        barcode: '1234567890123',
        stock: 20,
        reorderLevel: 5,
        reorderQuantity: 10,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      ).copyWith(costPrice: null, sku: null, barcode: null, reorderLevel: null, reorderQuantity: null);

      final returnItem = StoreReturnItem(
        id: 1,
        uuid: 'return-item-uuid',
        returnUuid: '11111111-1111-4111-8111-111111111111',
        invoiceItemUuid: '22222222-2222-4222-8222-222222222222',
        companyProductUuid: '33333333-3333-4333-8333-333333333333',
        productUuid: '44444444-4444-4444-8444-444444444444',
        quantity: 1,
        unitPrice: money('10'),
        lineTotal: money('10'),
        reason: 'Damaged',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      ).copyWith(invoiceItemUuid: null);

      final movement = InventoryMovement(
        id: 1,
        uuid: 'movement-uuid',
        companyProductUuid: '11111111-1111-4111-8111-111111111111',
        productUuid: '22222222-2222-4222-8222-222222222222',
        movementType: InventoryMovementType.adjustment,
        quantityDelta: 1,
        balanceAfter: 8,
        unitCost: money('3.50'),
        referenceType: InventoryReferenceType.adjustment,
        referenceUuid: '33333333-3333-4333-8333-333333333333',
        note: 'Manual adjustment',
        createdByUserUuid: '44444444-4444-4444-8444-444444444444',
        createdAt: createdAt,
        updatedAt: updatedAt,
      ).copyWith(unitCost: null, referenceUuid: null, createdByUserUuid: null);

      expect(companyProduct.costPrice, isNull);
      expect(companyProduct.sku, isNull);
      expect(companyProduct.barcode, isNull);
      expect(companyProduct.reorderLevel, isNull);
      expect(companyProduct.reorderQuantity, isNull);
      expect(returnItem.invoiceItemUuid, isNull);
      expect(movement.unitCost, isNull);
      expect(movement.referenceUuid, isNull);
      expect(movement.createdByUserUuid, isNull);
    });

    test('Company round-trips through map and json', () {
      final company = Company(id: 1, uuid: 'company-uuid', name: 'Store Co', description: 'Main supplier', status: 1, createdAt: createdAt, updatedAt: updatedAt);

      expect(Company.fromMap(company.toMap()), equals(company));
      expect(Company.fromJson(company.toJson()), equals(company));
      expect(company.status, 1);
    });

    test('Product round-trips through map and json', () {
      final product = Product(id: 1, uuid: 'product-uuid', name: 'Rice', description: '1kg pack', status: 1, createdAt: createdAt, updatedAt: updatedAt);

      expect(Product.fromMap(product.toMap()), equals(product));
      expect(Product.fromJson(product.toJson()), equals(product));
    });

    test('Roles round-trips through map and json', () {
      final role = Roles(id: 1, uuid: 'role-uuid', name: 'Admin', description: 'System administrator', status: 1, createdAt: createdAt, updatedAt: updatedAt);

      expect(Roles.fromMap(role.toMap()), equals(role));
      expect(Roles.fromJson(role.toJson()), equals(role));
    });

    test('User round-trips through map and json', () {
      final user = User(email: 'owner@example.com', id: 1, name: 'Owner', password: 'secret', username: 'owner', uuid: 'user-uuid', status: 1, createdAt: createdAt, updatedAt: updatedAt);

      expect(User.fromMap(user.toMap(includePassword: true)), equals(user));
      expect(User.fromJson(user.toJson(includePassword: true)), equals(user));
      expect(user.toMap().containsKey('password'), isFalse);
      expect(user.toString(), contains('password: ***'));
    });

    test('UserRoles round-trips through map and json', () {
      final userRole = UserRoles(
        id: 1,
        uuid: 'user-role-uuid',
        userUuid: '11111111-1111-4111-8111-111111111111',
        roleUuid: '22222222-2222-4222-8222-222222222222',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(UserRoles.fromMap(userRole.toMap()), equals(userRole));
      expect(UserRoles.fromJson(userRole.toJson()), equals(userRole));
    });

    test('CompanyProducts round-trips through map and json', () {
      final companyProduct = CompanyProducts(
        id: 1,
        uuid: 'company-product-uuid',
        companyUuid: '11111111-1111-4111-8111-111111111111',
        productUuid: '22222222-2222-4222-8222-222222222222',
        price: money('15.50'),
        costPrice: money('10.25'),
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

      expect(CompanyProducts.fromMap(companyProduct.toMap()), equals(companyProduct));
      expect(CompanyProducts.fromJson(companyProduct.toJson()), equals(companyProduct));
      expect(companyProduct.isLowStock, isFalse);
    });

    test('CompanyProducts accepts integer price values from raw maps', () {
      final companyProduct = CompanyProducts.fromMap({
        'id': 1,
        'uuid': 'client-uuid',
        'companyUuid': '11111111-1111-4111-8111-111111111111',
        'productUuid': '22222222-2222-4222-8222-222222222222',
        'price': 15,
        'description': 'Retail price',
        'stock': 20,
        'status': 1,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
      });

      expect(companyProduct.price, money('15'));
    });

    test('StoreCompany round-trips through map and json', () {
      final storeCompany = StoreCompany(
        id: 1,
        uuid: 'store-company-uuid',
        storeUuid: '11111111-1111-4111-8111-111111111111',
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
        productUuid: '22222222-2222-4222-8222-222222222222',
        tagUuid: '33333333-3333-4333-8333-333333333333',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(ProductsTags.fromMap(productTag.toMap()), equals(productTag));
      expect(ProductsTags.fromJson(productTag.toJson()), equals(productTag));
    });

    test('StoreInvoice and detail items round-trip through map and json', () {
      final invoice = StoreInvoice(
        id: 1,
        uuid: 'invoice-uuid',
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientUuid: '22222222-2222-4222-8222-222222222222',
        invoiceNumber: 'INV-001',
        invoiceType: StoreInvoiceType.credit,
        itemCount: 0,
        totalAmount: money('200'),
        paidAmount: money('50'),
        balanceAmount: money('150'),
        notes: 'Monthly invoice',
        issuedAt: createdAt,
        dueAt: updatedAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final item = StoreInvoiceItem(
        id: 1,
        uuid: 'invoice-item-uuid',
        invoiceUuid: '11111111-1111-4111-8111-111111111111',
        companyProductUuid: '22222222-2222-4222-8222-222222222222',
        productUuid: '33333333-3333-4333-8333-333333333333',
        quantity: 2,
        unitPrice: money('20'),
        discountAmount: money('1'),
        taxAmount: money('2'),
        lineTotal: money('41'),
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(StoreInvoice.fromMap(invoice.toMap()), equals(invoice));
      expect(StoreInvoice.fromJson(invoice.toJson()), equals(invoice));
      expect(StoreInvoiceItem.fromMap(item.toMap()), equals(item));
      expect(StoreInvoiceItem.fromJson(item.toJson()), equals(item));
    });

    test('StorePaymentVoucher and PaymentAllocation round-trip through map and json', () {
      final voucher = StorePaymentVoucher(
        id: 1,
        uuid: 'voucher-uuid',
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientUuid: '22222222-2222-4222-8222-222222222222',
        voucherNumber: 'PV-001',
        payeeName: 'Vendor',
        amount: money('100'),
        paymentMethod: StorePaymentMethod.cash,
        referenceNumber: 'REF-001',
        description: 'Supplier payment',
        transactionDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final allocation = PaymentAllocation(
        id: 1,
        uuid: 'allocation-uuid',
        paymentVoucherUuid: '11111111-1111-4111-8111-111111111111',
        invoiceUuid: '22222222-2222-4222-8222-222222222222',
        allocatedAmount: money('50'),
        allocationDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(StorePaymentVoucher.fromMap(voucher.toMap()), equals(voucher));
      expect(StorePaymentVoucher.fromJson(voucher.toJson()), equals(voucher));
      expect(PaymentAllocation.fromMap(allocation.toMap()), equals(allocation));
      expect(PaymentAllocation.fromJson(allocation.toJson()), equals(allocation));
    });

    test('StoreReturn and return items round-trip through map and json', () {
      final storeReturn = StoreReturn(
        id: 1,
        uuid: 'return-uuid',
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientUuid: '22222222-2222-4222-8222-222222222222',
        returnNumber: 'RET-001',
        returnType: StoreReturnType.salesReturn,
        itemCount: 3,
        totalAmount: money('60'),
        reason: 'Damaged items',
        transactionDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final item = StoreReturnItem(
        id: 1,
        uuid: 'return-item-uuid',
        returnUuid: '11111111-1111-4111-8111-111111111111',
        invoiceItemUuid: '22222222-2222-4222-8222-222222222222',
        companyProductUuid: '33333333-3333-4333-8333-333333333333',
        productUuid: '44444444-4444-4444-8444-444444444444',
        quantity: 1,
        unitPrice: money('20'),
        lineTotal: money('20'),
        reason: 'Expired item',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(StoreReturn.fromMap(storeReturn.toMap()), equals(storeReturn));
      expect(StoreReturn.fromJson(storeReturn.toJson()), equals(storeReturn));
      expect(StoreReturnItem.fromMap(item.toMap()), equals(item));
      expect(StoreReturnItem.fromJson(item.toJson()), equals(item));
    });

    test('StoreFinancialTransaction and InventoryMovement round-trip through map and json', () {
      final transaction = StoreFinancialTransaction(
        id: 1,
        uuid: 'financial-transaction-uuid',
        storeUuid: '11111111-1111-4111-8111-111111111111',
        clientUuid: '22222222-2222-4222-8222-222222222222',
        transactionNumber: 'FT-001',
        transactionType: FinancialTransactionType.invoicePosting,
        sourceType: FinancialSourceType.invoice,
        sourceUuid: '44444444-4444-4444-8444-444444444444',
        amount: money('200'),
        entryType: LedgerEntryType.debit,
        description: 'Invoice posting',
        transactionDate: createdAt,
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final movement = InventoryMovement(
        id: 1,
        uuid: 'movement-uuid',
        companyProductUuid: '22222222-2222-4222-8222-222222222222',
        productUuid: '33333333-3333-4333-8333-333333333333',
        movementType: InventoryMovementType.restock,
        quantityDelta: 10,
        balanceAfter: 30,
        unitCost: money('11.25'),
        referenceType: InventoryReferenceType.restock,
        referenceUuid: '11111111-1111-4111-8111-111111111111',
        note: 'Supplier restock',
        createdByUserUuid: '44444444-4444-4444-8444-444444444444',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(StoreFinancialTransaction.fromMap(transaction.toMap()), equals(transaction));
      expect(StoreFinancialTransaction.fromJson(transaction.toJson()), equals(transaction));
      expect(InventoryMovement.fromMap(movement.toMap()), equals(movement));
      expect(InventoryMovement.fromJson(movement.toJson()), equals(movement));
    });

    test('Categories supports root nodes with null parentUuid', () {
      final category = Categories(id: 1, uuid: 'category-uuid', name: 'Root', description: 'Top level category', status: 1, parentUuid: null, createdAt: createdAt, updatedAt: updatedAt);

      expect(Categories.fromMap(category.toMap()), equals(category));
      expect(Categories.fromJson(category.toJson()), equals(category));
      expect(Categories.fromMap({...category.toMap(), 'parentUuid': null}).parentUuid, isNull);
    });

    test('StoreUser round-trips through map and json', () {
      final storeUser = StoreUser(
        id: 1,
        uuid: 'store-user-uuid',
        storeUuid: '22222222-2222-4222-8222-222222222222',
        userUuid: '33333333-3333-4333-8333-333333333333',
        userRoleUuid: '44444444-4444-4444-8444-444444444444',
        status: 1,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(StoreUser.fromMap(storeUser.toMap()), equals(storeUser));
      expect(StoreUser.fromJson(storeUser.toJson()), equals(storeUser));
    });

    test('legacy model maps generate uuid when missing', () {
      final company = Company.fromMap({'id': 1, 'name': 'Store Co', 'description': 'Main supplier', 'status': 1, 'createdAt': createdAt.millisecondsSinceEpoch, 'updatedAt': updatedAt.millisecondsSinceEpoch});

      expect(company.uuid, isNotEmpty);
    });

    test('Client accepts integer credit values from raw maps', () {
      final client = Client.fromMap({
        'id': 1,
        'uuid': 'client-uuid',
        'name': 'Walk-in Customer',
        'description': 'Prefers to pay later',
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

      expect(client.creditLimit, money('100'));
      expect(client.currentCredit, money('25'));
      expect(client.availableCredit, money('75'));
    });
  });
}