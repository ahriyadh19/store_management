import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/controllers.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/services/request.dart';

void main() {
  Request buildRequest({required Map<String, dynamic> data}) {
    return Request(title: 'Workflow Request', message: 'Transfer to sale workflow', data: data);
  }

  test('transfer-to-sale workflow creates linked transfer, movement, invoice, and sale tx', () {
    final transferOrdersController = TransferOrdersController();
    final transferOrderItemsController = TransferOrderItemsController();
    final movementsController = InventoryMovementsController();
    final invoicesController = SalesInvoicesController();
    final transactionsController = InventoryTransactionsController();

    const ownerUuid = '11111111-1111-4111-8111-111111111111';
    const sourceBranchUuid = '22222222-2222-4222-8222-222222222222';
    const destinationBranchUuid = '33333333-3333-4333-8333-333333333333';
    const storeUuid = '44444444-4444-4444-8444-444444444444';
    const customerUuid = '55555555-5555-4555-8555-555555555555';
    const productUuid = '66666666-6666-4666-8666-666666666666';
    const transferUuid = 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa';
    const salesInvoiceUuid = 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb';

    final transferResponse = transferOrdersController.create(
      request: buildRequest(
        data: {
          'id': 1,
          'uuid': transferUuid,
          'ownerUuid': ownerUuid,
          'sourceBranchUuid': sourceBranchUuid,
          'destinationBranchUuid': destinationBranchUuid,
          'transferNumber': 'TR-2026-1001',
          'status': 'approved',
          'requestedAt': 1715036400000,
        },
      ),
    );

    final transferItemResponse = transferOrderItemsController.create(
      request: buildRequest(
        data: {
          'id': 2,
          'transferOrderUuid': transferUuid,
          'productUuid': productUuid,
          'quantity': 20,
          'shippedQuantity': 20,
          'receivedQuantity': 20,
        },
      ),
    );

    final movementResponse = movementsController.create(
      request: buildRequest(
        data: {
          'id': 3,
          'supplierProductUuid': '77777777-7777-4777-8777-777777777777',
          'productUuid': productUuid,
          'movementType': 'transfer',
          'inventoryHolderType': 'branch',
          'inventoryHolderUuid': destinationBranchUuid,
          'quantityDelta': 20,
          'balanceAfter': 60,
          'unitCost': 12.5,
          'referenceType': 'transfer',
          'referenceUuid': transferUuid,
          'counterpartyHolderType': 'branch',
          'counterpartyHolderUuid': sourceBranchUuid,
          'transactionUuid': 'cccccccc-cccc-4ccc-8ccc-cccccccccccc',
          'note': 'Received transfer for resale',
        },
      ),
    );

    final salesInvoiceResponse = invoicesController.create(
      request: buildRequest(
        data: {
          'id': 4,
          'uuid': salesInvoiceUuid,
          'ownerUuid': ownerUuid,
          'storeUuid': storeUuid,
          'branchUuid': destinationBranchUuid,
          'customerUuid': customerUuid,
          'invoiceNumber': 'SINV-2026-2001',
          'issuedAt': 1715122800000,
          'currencyCode': 'USD',
          'subtotal': 500,
          'discountAmount': 20,
          'taxAmount': 30,
          'totalAmount': 510,
          'paidAmount': 0,
          'status': 'open',
        },
      ),
    );

    final saleTxResponse = transactionsController.create(
      request: buildRequest(
        data: {
          'id': 5,
          'ownerUuid': ownerUuid,
          'productUuid': productUuid,
          'holderType': 'branch',
          'holderUuid': destinationBranchUuid,
          'transactionType': 'sale',
          'quantity': -5,
          'unitCost': 12.5,
          'unitPrice': 100,
          'referenceType': 'sales_invoice',
          'referenceUuid': salesInvoiceUuid,
          'occurredAt': 1715122800000,
          'note': 'Sale fulfilled from transferred stock',
        },
      ),
    );

    expect(transferResponse.statusCode, 201);
    expect(transferItemResponse.statusCode, 201);
    expect(movementResponse.statusCode, 201);
    expect(salesInvoiceResponse.statusCode, 201);
    expect(saleTxResponse.statusCode, 201);

    expect(movementResponse.data?.referenceType, InventoryReferenceType.transfer);
    expect(movementResponse.data?.inventoryHolderUuid, destinationBranchUuid);
    expect(saleTxResponse.data?.referenceType, 'sales_invoice');
    expect(saleTxResponse.data?.quantity, -5);
  });
}
