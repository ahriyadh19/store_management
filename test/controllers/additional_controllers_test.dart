import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/controllers.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/services/request.dart';
import 'package:store_management/validations/validations.dart';

void main() {
  final allocationDate = DateTime.fromMillisecondsSinceEpoch(1713916800000);

  Request buildRequest({
    Map<String, dynamic>? data,
    String title = 'Request',
    String message = 'Controller request',
  }) {
    return Request(title: title, message: message, data: data);
  }

  Map<String, dynamic> buildClientData({
    int id = 1,
    String name = 'Walk-in Client',
    String description = 'Preferred customer',
    String email = 'client@example.com',
    String phone = '+256700000001',
    String address = 'Kampala',
    num creditLimit = 500,
    num currentCredit = 125,
    num availableCredit = 375,
    int status = 1,
  }) {
    return {
      'id': id,
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
      'address': address,
      'creditLimit': creditLimit,
      'currentCredit': currentCredit,
      'availableCredit': availableCredit,
      'status': status,
    };
  }

  Map<String, dynamic> buildStoreData({
    int id = 2,
    String name = 'Main Branch',
    String description = 'Downtown store',
    String address = 'Plot 1 Market Street',
    String phone = '+256700000002',
    String email = 'store@example.com',
  }) {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }

  Map<String, dynamic> buildBranchData({
    int id = 10,
    String name = 'City Branch',
    String description = 'Handles downtown customers',
    String address = 'Plot 7 City Square',
    String phone = '+256700000010',
    String email = 'branch@example.com',
    int status = 1,
  }) {
    return {'id': id, 'name': name, 'description': description, 'address': address, 'phone': phone, 'email': email, 'status': status};
  }

  Map<String, dynamic> buildStoreClientData({
    int id = 3,
    String storeUuid = '11111111-1111-4111-8111-111111111111',
    String clientUuid = '22222222-2222-4222-8222-222222222222',
    int status = 1,
  }) {
    return {
      'id': id,
      'storeUuid': storeUuid,
      'clientUuid': clientUuid,
      'status': status,
    };
  }

  Map<String, dynamic> buildStoreCompanyData({
    int id = 4,
    String storeUuid = '11111111-1111-4111-8111-111111111111',
    String companyUuid = '33333333-3333-4333-8333-333333333333',
    int status = 1,
  }) {
    return {
      'id': id,
      'storeUuid': storeUuid,
      'companyUuid': companyUuid,
      'status': status,
    };
  }

  Map<String, dynamic> buildStoreUserData({
    int id = 5,
    String storeUuid = '11111111-1111-4111-8111-111111111111',
    String userUuid = '44444444-4444-4444-8444-444444444444',
    String userRoleUuid = '55555555-5555-4555-8555-555555555555',
    int status = 1,
  }) {
    return {
      'id': id,
      'storeUuid': storeUuid,
      'userUuid': userUuid,
      'userRoleUuid': userRoleUuid,
      'status': status,
    };
  }

  Map<String, dynamic> buildStoreBranchesData({int id = 11, String storeUuid = '11111111-1111-4111-8111-111111111111', String branchUuid = '22222222-2222-4222-8222-222222222222', int status = 1}) {
    return {'id': id, 'storeUuid': storeUuid, 'branchUuid': branchUuid, 'status': status};
  }

  Map<String, dynamic> buildPaymentAllocationData({
    int id = 6,
    String paymentVoucherUuid = '66666666-6666-4666-8666-666666666666',
    String invoiceUuid = '77777777-7777-4777-8777-777777777777',
    num allocatedAmount = 85.5,
    int? allocationDateMs,
    int status = 1,
  }) {
    return {
      'id': id,
      'paymentVoucherUuid': paymentVoucherUuid,
      'invoiceUuid': invoiceUuid,
      'allocatedAmount': allocatedAmount,
      'allocationDate': allocationDateMs ?? allocationDate.millisecondsSinceEpoch,
      'status': status,
    };
  }

  Map<String, dynamic> buildPaymentVoucherData({
    int id = 12,
    String storeUuid = '11111111-1111-4111-8111-111111111111',
    String clientUuid = '22222222-2222-4222-8222-222222222222',
    String voucherNumber = 'PV-001',
    String payeeName = 'Supplier One',
    num amount = 250.75,
    String paymentMethod = 'cash',
    String referenceNumber = 'REF-001',
    String description = 'Vendor settlement',
    int transactionDateMs = 1714003200000,
    int status = 1,
  }) {
    return {
      'id': id,
      'storeUuid': storeUuid,
      'clientUuid': clientUuid,
      'voucherNumber': voucherNumber,
      'payeeName': payeeName,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'referenceNumber': referenceNumber,
      'description': description,
      'transactionDate': transactionDateMs,
      'status': status,
    };
  }

  Map<String, dynamic> buildStoreReturnData({
    int id = 13,
    String storeUuid = '11111111-1111-4111-8111-111111111111',
    String clientUuid = '22222222-2222-4222-8222-222222222222',
    String returnNumber = 'RET-001',
    String returnType = 'sales_return',
    int itemCount = 1,
    num totalAmount = 80,
    String reason = 'Customer returned item',
    int transactionDateMs = 1714089600000,
    int status = 1,
  }) {
    return {
      'id': id,
      'storeUuid': storeUuid,
      'clientUuid': clientUuid,
      'returnNumber': returnNumber,
      'returnType': returnType,
      'itemCount': itemCount,
      'totalAmount': totalAmount,
      'reason': reason,
      'transactionDate': transactionDateMs,
      'status': status,
    };
  }

  Map<String, dynamic> buildFinancialTransactionData({
    int id = 14,
    String storeUuid = '11111111-1111-4111-8111-111111111111',
    String clientUuid = '22222222-2222-4222-8222-222222222222',
    String transactionNumber = 'TXN-001',
    String transactionType = 'payment_receipt',
    String sourceType = 'payment_voucher',
    String sourceUuid = '66666666-6666-4666-8666-666666666666',
    num amount = 250.75,
    String entryType = 'debit',
    String description = 'Payment posted',
    int transactionDateMs = 1714176000000,
    int status = 1,
  }) {
    return {
      'id': id,
      'storeUuid': storeUuid,
      'clientUuid': clientUuid,
      'transactionNumber': transactionNumber,
      'transactionType': transactionType,
      'sourceType': sourceType,
      'sourceUuid': sourceUuid,
      'amount': amount,
      'entryType': entryType,
      'description': description,
      'transactionDate': transactionDateMs,
      'status': status,
    };
  }

  Map<String, dynamic> buildStoreInvoiceItemData({
    int id = 7,
    String invoiceUuid = '77777777-7777-4777-8777-777777777777',
    String companyProductUuid = '88888888-8888-4888-8888-888888888888',
    String productUuid = '99999999-9999-4999-8999-999999999999',
    int quantity = 3,
    num unitPrice = 40,
    num discountAmount = 5,
    num taxAmount = 2,
    num lineTotal = 117,
    int status = 1,
  }) {
    return {
      'id': id,
      'invoiceUuid': invoiceUuid,
      'companyProductUuid': companyProductUuid,
      'productUuid': productUuid,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
      'lineTotal': lineTotal,
      'status': status,
    };
  }

  Map<String, dynamic> buildStoreReturnItemData({
    int id = 8,
    String returnUuid = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
    String? invoiceItemUuid,
    String companyProductUuid = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
    String productUuid = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc',
    int quantity = 2,
    num unitPrice = 40,
    num lineTotal = 80,
    String reason = 'Damaged item',
    int status = 1,
  }) {
    return {
      'id': id,
      'returnUuid': returnUuid,
      'invoiceItemUuid': invoiceItemUuid,
      'companyProductUuid': companyProductUuid,
      'productUuid': productUuid,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'lineTotal': lineTotal,
      'reason': reason,
      'status': status,
    };
  }

  Map<String, dynamic> buildInventoryMovementData({
    int id = 9,
    String companyProductUuid = 'dddddddd-dddd-4ddd-8ddd-dddddddddddd',
    String productUuid = 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee',
    String movementType = 'sale',
    int quantityDelta = -2,
    int balanceAfter = 18,
    num? unitCost = 12.75,
    String referenceType = 'invoice',
    String? referenceUuid = 'ffffffff-ffff-4fff-8fff-ffffffffffff',
    String note = 'Sold two units',
    String? createdByUserUuid = '12121212-1212-4121-8121-121212121212',
  }) {
    return {
      'id': id,
      'companyProductUuid': companyProductUuid,
      'productUuid': productUuid,
      'movementType': movementType,
      'quantityDelta': quantityDelta,
      'balanceAfter': balanceAfter,
      'unitCost': unitCost,
      'referenceType': referenceType,
      'referenceUuid': referenceUuid,
      'note': note,
      'createdByUserUuid': createdByUserUuid,
    };
  }

  group('Barrel exports', () {
    test('controllers and validations barrels expose new surfaces', () {
      final controller = BranchesController();
      final validationResult = BranchesValidation.validateAll(buildRequest());

      expect(controller, isA<BranchesController>());
      expect(validationResult, isNull);
    });
  });

  group('Additional controllers', () {
    test('clients controller creates and reads client data', () {
      final controller = ClientsController();

      final createResponse = controller.create(request: buildRequest(data: buildClientData()));
      final readResponse = controller.read(request: buildRequest(data: {'id': 1}));

      expect(createResponse.statusCode, 201);
      expect(createResponse.data?.availableCredit, Decimal.parse('375'));
      expect(readResponse.statusCode, 200);
      expect(readResponse.data?.email, 'client@example.com');
    });

    test('stores controller updates store fields', () {
      final controller = StoresController();

      controller.create(request: buildRequest(data: buildStoreData()));
      final updateResponse = controller.update(
        request: buildRequest(
          data: buildStoreData(name: 'Airport Branch', email: 'airport@example.com'),
        ),
      );

      expect(updateResponse.statusCode, 200);
      expect(updateResponse.data?.name, 'Airport Branch');
      expect(updateResponse.data?.email, 'airport@example.com');
    });

    test('branches controller creates and updates branch fields', () {
      final controller = BranchesController();

      final createResponse = controller.create(request: buildRequest(data: buildBranchData()));
      final updateResponse = controller.update(
        request: buildRequest(
          data: buildBranchData(name: 'Airport Branch', email: 'airport.branch@example.com'),
        ),
      );

      expect(createResponse.statusCode, 201);
      expect(createResponse.data?.status, 1);
      expect(updateResponse.statusCode, 200);
      expect(updateResponse.data?.name, 'Airport Branch');
      expect(updateResponse.data?.email, 'airport.branch@example.com');
    });

    test('store clients controller deletes created store client', () {
      final controller = StoreClientsController();

      controller.create(request: buildRequest(data: buildStoreClientData()));
      final deleteResponse = controller.delete(request: buildRequest(data: {'id': 3}));
      final readAfterDelete = controller.read(request: buildRequest(data: {'id': 3}));
      final allAfterDelete = controller.all(request: buildRequest());

      expect(deleteResponse.statusCode, 200);
      expect(deleteResponse.data?.clientUuid, '22222222-2222-4222-8222-222222222222');
      expect(deleteResponse.data?.synced, isFalse);
      expect(deleteResponse.data?.deletedAt, isNotNull);
      expect(controller.storeClient?.deletedAt, isNotNull);
      expect(readAfterDelete.statusCode, 404);
      expect(allAfterDelete.data, isEmpty);
    });

    test('store companies controller creates and lists store companies', () {
      final controller = StoreCompaniesController();

      final createResponse = controller.create(request: buildRequest(data: buildStoreCompanyData()));
      final allResponse = controller.all(request: buildRequest());

      expect(createResponse.statusCode, 201);
      expect(createResponse.data?.companyUuid, '33333333-3333-4333-8333-333333333333');
      expect(allResponse.statusCode, 200);
      expect(allResponse.data, hasLength(1));
    });

    test('store companies controller returns not found when missing record', () {
      final controller = StoreCompaniesController();

      final response = controller.read(request: buildRequest(data: {'id': 4}));

      expect(response.statusCode, 404);
      expect(response.message, 'Store company was not found');
    });

    test('store users controller creates and lists store users', () {
      final controller = StoreUsersController();

      final createResponse = controller.create(request: buildRequest(data: buildStoreUserData()));
      final allResponse = controller.all(request: buildRequest());

      expect(createResponse.statusCode, 201);
      expect(createResponse.data?.userRoleUuid, '55555555-5555-4555-8555-555555555555');
      expect(allResponse.statusCode, 200);
      expect(allResponse.data, hasLength(1));
    });

    test('store branches controller creates and lists store branch relations', () {
      final controller = StoreBranchesController();

      final createResponse = controller.create(request: buildRequest(data: buildStoreBranchesData()));
      final allResponse = controller.all(request: buildRequest());

      expect(createResponse.statusCode, 201);
      expect(createResponse.data?.branchUuid, '22222222-2222-4222-8222-222222222222');
      expect(allResponse.statusCode, 200);
      expect(allResponse.data, hasLength(1));
    });

    test('payment allocations controller parses decimal amounts and dates', () {
      final controller = PaymentAllocationsController();

      final response = controller.create(request: buildRequest(data: buildPaymentAllocationData()));

      expect(response.statusCode, 201);
      expect(response.data?.allocatedAmount, Decimal.parse('85.5'));
      expect(response.data?.allocationDate, allocationDate);
    });

    test('store payment vouchers controller parses decimal and enum fields', () {
      final controller = StorePaymentVouchersController();

      final response = controller.create(request: buildRequest(data: buildPaymentVoucherData()));

      expect(response.statusCode, 201);
      expect(response.data?.amount, Decimal.parse('250.75'));
      expect(response.data?.paymentMethod, StorePaymentMethod.cash);
    });

    test('store returns controller parses total amount and enum fields', () {
      final controller = StoreReturnsController();

      final response = controller.create(request: buildRequest(data: buildStoreReturnData()));

      expect(response.statusCode, 201);
      expect(response.data?.returnType, StoreReturnType.salesReturn);
      expect(response.data?.totalAmount, Decimal.parse('80'));
    });

    test('store financial transactions controller parses enum and amount fields', () {
      final controller = StoreFinancialTransactionsController();

      final response = controller.create(request: buildRequest(data: buildFinancialTransactionData()));

      expect(response.statusCode, 201);
      expect(response.data?.transactionType, FinancialTransactionType.paymentReceipt);
      expect(response.data?.sourceType, FinancialSourceType.paymentVoucher);
      expect(response.data?.entryType, LedgerEntryType.debit);
      expect(response.data?.amount, Decimal.parse('250.75'));
    });

    test('store invoice items controller validates required quantity', () {
      final controller = StoreInvoiceItemsController();

      final response = controller.create(
        request: buildRequest(data: buildStoreInvoiceItemData(quantity: 0)),
      );

      expect(response.statusCode, 400);
      expect(response.message, 'Quantity must be provided as a positive integer');
    });

    test('store invoice items controller creates and reads invoice items', () {
      final controller = StoreInvoiceItemsController();

      controller.create(request: buildRequest(data: buildStoreInvoiceItemData()));
      final response = controller.read(request: buildRequest(data: {'id': 7}));

      expect(response.statusCode, 200);
      expect(response.data?.lineTotal, Decimal.parse('117'));
    });

    test('store return items controller allows nullable invoice item uuid', () {
      final controller = StoreReturnItemsController();

      final response = controller.create(
        request: buildRequest(data: buildStoreReturnItemData(invoiceItemUuid: null)),
      );

      expect(response.statusCode, 201);
      expect(response.data?.invoiceItemUuid, isNull);
      expect(response.data?.lineTotal, Decimal.parse('80'));
    });

    test('inventory movements controller parses enum and nullable fields', () {
      final controller = InventoryMovementsController();

      final response = controller.create(
        request: buildRequest(
          data: buildInventoryMovementData(
            unitCost: null,
            referenceUuid: null,
            createdByUserUuid: null,
          ),
        ),
      );

      expect(response.statusCode, 201);
      expect(response.data?.movementType, InventoryMovementType.sale);
      expect(response.data?.referenceType, InventoryReferenceType.invoice);
      expect(response.data?.unitCost, isNull);
      expect(response.data?.referenceUuid, isNull);
      expect(response.data?.createdByUserUuid, isNull);
    });
  });
}
