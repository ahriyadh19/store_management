import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/controllers.dart';
import 'package:store_management/services/request.dart';

void main() {
  Request buildRequest({required Map<String, dynamic> data}) {
    return Request(title: 'Workflow Request', message: 'Procure to stock workflow', data: data);
  }

  test('procure-to-stock controller workflow creates linked records', () {
    final purchaseOrdersController = PurchaseOrdersController();
    final orderItemsController = PurchaseOrderItemsController();
    final supplierInvoicesController = SupplierInvoicesController();
    final batchesController = InventoryBatchesController();
    final transactionsController = InventoryTransactionsController();

    const ownerUuid = '11111111-1111-4111-8111-111111111111';
    const storeUuid = '22222222-2222-4222-8222-222222222222';
    const supplierUuid = '33333333-3333-4333-8333-333333333333';
    const purchaseOrderUuid = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
    const productUuid = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';
    const supplierInvoiceUuid = 'cccccccc-cccc-4ccc-8ccc-cccccccccccc';
    const batchUuid = 'dddddddd-dddd-4ddd-8ddd-dddddddddddd';
    const branchUuid = 'eeeeeeee-eeee-4eee-8eee-eeeeeeeeeeee';

    final poCreateResponse = purchaseOrdersController.create(
      request: buildRequest(
        data: {
          'id': 1,
          'uuid': purchaseOrderUuid,
          'ownerUuid': ownerUuid,
          'storeUuid': storeUuid,
          'supplierUuid': supplierUuid,
          'poNumber': 'PO-2026-0100',
          'orderDate': 1715036400000,
          'expectedDate': 1715641200000,
          'status': 'submitted',
          'currencyCode': 'USD',
          'totalAmount': 0,
          'notes': 'Workflow PO',
        },
      ),
    );

    final itemCreateResponse = orderItemsController.create(
      request: buildRequest(
        data: {
          'id': 2,
          'purchaseOrderUuid': purchaseOrderUuid,
          'productUuid': productUuid,
          'quantity': 50,
          'unitCost': 10,
          'discountAmount': 0,
          'lineTotal': 500,
          'receivedQuantity': 0,
        },
      ),
    );

    final supplierInvoiceCreateResponse = supplierInvoicesController.create(
      request: buildRequest(
        data: {
          'id': 3,
          'uuid': supplierInvoiceUuid,
          'ownerUuid': ownerUuid,
          'storeUuid': storeUuid,
          'supplierUuid': supplierUuid,
          'purchaseOrderUuid': purchaseOrderUuid,
          'supplierInvoiceNumber': 'SI-2026-0100',
          'invoiceDate': 1715036400000,
          'currencyCode': 'USD',
          'subtotal': 500,
          'taxAmount': 25,
          'totalAmount': 525,
          'status': 'open',
        },
      ),
    );

    final batchCreateResponse = batchesController.create(
      request: buildRequest(
        data: {
          'id': 4,
          'uuid': batchUuid,
          'ownerUuid': ownerUuid,
          'storeUuid': storeUuid,
          'supplierUuid': supplierUuid,
          'productUuid': productUuid,
          'supplierInvoiceUuid': supplierInvoiceUuid,
          'batchNumber': 'BATCH-2026-0100',
          'receivedAt': 1715036400000,
          'unitCost': 10,
          'initialQuantity': 50,
          'remainingQuantity': 50,
          'status': 1,
        },
      ),
    );

    final txCreateResponse = transactionsController.create(
      request: buildRequest(
        data: {
          'id': 5,
          'ownerUuid': ownerUuid,
          'productUuid': productUuid,
          'batchUuid': batchUuid,
          'holderType': 'branch',
          'holderUuid': branchUuid,
          'transactionType': 'purchase',
          'quantity': 50,
          'unitCost': 10,
          'referenceType': 'supplier_invoice',
          'referenceUuid': supplierInvoiceUuid,
          'occurredAt': 1715036400000,
          'note': 'Procure-to-stock posting',
        },
      ),
    );

    expect(poCreateResponse.statusCode, 201);
    expect(itemCreateResponse.statusCode, 201);
    expect(supplierInvoiceCreateResponse.statusCode, 201);
    expect(batchCreateResponse.statusCode, 201);
    expect(txCreateResponse.statusCode, 201);

    expect(itemCreateResponse.data?.lineTotal, Decimal.parse('500'));
    expect(supplierInvoiceCreateResponse.data?.totalAmount, Decimal.parse('525'));
    expect(batchCreateResponse.data?.remainingQuantity, 50);
    expect(txCreateResponse.data?.referenceType, 'supplier_invoice');
    expect(txCreateResponse.data?.quantity, 50);
  });
}
