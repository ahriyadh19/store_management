import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/controllers.dart';
import 'package:store_management/services/request.dart';

void main() {
  Request buildRequest(Map<String, dynamic> data) {
    return Request(title: 'Request', message: 'Controller request', data: data);
  }

  const ownerUuid = '11111111-1111-4111-8111-111111111111';
  const storeUuid = '22222222-2222-4222-8222-222222222222';
  const branchUuid = '33333333-3333-4333-8333-333333333333';
  const branch2Uuid = '44444444-4444-4444-8444-444444444444';
  const productUuid = '55555555-5555-4555-8555-555555555555';
  const userUuid = '66666666-6666-4666-8666-666666666666';
  const customerUuid = '77777777-7777-4777-8777-777777777777';
  const invoiceUuid = '88888888-8888-4888-8888-888888888888';
  const shiftUuid = '99999999-9999-4999-8999-999999999999';

  final now = DateTime.now().millisecondsSinceEpoch;

  test('transfer orders controller create/update works', () {
    final controller = TransferOrdersController();
    final created = controller.create(
      request: buildRequest({
        'ownerUuid': ownerUuid,
        'sourceBranchUuid': branchUuid,
        'destinationBranchUuid': branch2Uuid,
        'transferNumber': 'TR-001',
        'status': 'draft',
        'requestedAt': now,
      }),
    );

    expect(created.statusCode, 201);

    final updated = controller.update(
      request: buildRequest({
        'id': 1,
        'ownerUuid': ownerUuid,
        'sourceBranchUuid': branchUuid,
        'destinationBranchUuid': branch2Uuid,
        'transferNumber': 'TR-001',
        'status': 'approved',
        'requestedAt': now,
      }),
    );

    expect(updated.statusCode, 200);
  });

  test('transfer order item hard delete works', () {
    final controller = TransferOrderItemsController();
    final created = controller.create(
      request: buildRequest({
        'transferOrderUuid': ownerUuid,
        'productUuid': productUuid,
        'quantity': 10,
      }),
    );

    expect(created.statusCode, 201);

    final deleted = controller.delete(request: buildRequest({'id': 1}));
    expect(deleted.statusCode, 200);
    expect(controller.transferOrderItem, isNull);
  });

  test('sales order/invoice/return controllers create works', () {
    final salesOrderController = SalesOrdersController();
    final salesInvoiceController = SalesInvoicesController();
    final salesReturnController = SalesReturnsController();

    final orderResponse = salesOrderController.create(
      request: buildRequest({
        'ownerUuid': ownerUuid,
        'storeUuid': storeUuid,
        'branchUuid': branchUuid,
        'customerUuid': customerUuid,
        'orderNumber': 'SO-001',
        'orderDate': now,
        'status': 'draft',
        'pricingStrategy': 'branch',
      }),
    );

    final invoiceResponse = salesInvoiceController.create(
      request: buildRequest({
        'ownerUuid': ownerUuid,
        'storeUuid': storeUuid,
        'branchUuid': branchUuid,
        'salesOrderUuid': invoiceUuid,
        'customerUuid': customerUuid,
        'invoiceNumber': 'SINV-001',
        'issuedAt': now,
        'currencyCode': 'USD',
        'subtotal': 100,
        'discountAmount': 5,
        'taxAmount': 10,
        'totalAmount': 105,
        'paidAmount': 0,
        'status': 'open',
      }),
    );

    final returnResponse = salesReturnController.create(
      request: buildRequest({
        'ownerUuid': ownerUuid,
        'salesInvoiceUuid': invoiceUuid,
        'returnNumber': 'SRET-001',
        'returnDate': now,
        'reason': 'Damaged',
        'refundAmount': 20,
        'status': 'draft',
      }),
    );

    expect(orderResponse.statusCode, 201);
    expect(invoiceResponse.statusCode, 201);
    expect(returnResponse.statusCode, 201);
  });

  test('pricing controllers create works', () {
    final branchPriceController = BranchPricesController();
    final promotionController = PromotionRulesController();

    final priceResponse = branchPriceController.create(
      request: buildRequest({
        'ownerUuid': ownerUuid,
        'branchUuid': branchUuid,
        'productUuid': productUuid,
        'priceType': 'regular',
        'price': 50,
        'status': 1,
      }),
    );

    final promotionResponse = promotionController.create(
      request: buildRequest({
        'ownerUuid': ownerUuid,
        'name': 'Promo',
        'branchUuid': branchUuid,
        'productUuid': productUuid,
        'discountType': 'percent',
        'discountValue': 10,
        'startsAt': now,
        'status': 1,
      }),
    );

    expect(priceResponse.statusCode, 201);
    expect(promotionResponse.statusCode, 201);
  });

  test('workforce controllers create/delete works', () {
    final shiftController = StaffShiftsController();
    final attendanceController = StaffAttendanceController();
    final activityController = StaffActivityLogsController();

    final shiftResponse = shiftController.create(
      request: buildRequest({
        'ownerUuid': ownerUuid,
        'branchUuid': branchUuid,
        'userUuid': userUuid,
        'shiftDate': now,
        'startAt': now,
        'status': 'scheduled',
      }),
    );

    final attendanceResponse = attendanceController.create(
      request: buildRequest({
        'ownerUuid': ownerUuid,
        'staffShiftUuid': shiftUuid,
        'status': 'present',
      }),
    );

    final activityResponse = activityController.create(
      request: buildRequest({
        'ownerUuid': ownerUuid,
        'branchUuid': branchUuid,
        'userUuid': userUuid,
        'action': 'approve',
        'entityType': 'transfer_order',
        'entityUuid': invoiceUuid,
        'metadataJson': {'source': 'test'},
      }),
    );

    expect(shiftResponse.statusCode, 201);
    expect(attendanceResponse.statusCode, 201);
    expect(activityResponse.statusCode, 201);

    final attendanceDelete = attendanceController.delete(request: buildRequest({'id': 1}));
    final activityDelete = activityController.delete(request: buildRequest({'id': 1}));
    expect(attendanceDelete.statusCode, 200);
    expect(activityDelete.statusCode, 200);
    expect(attendanceController.staffAttendance, isNull);
    expect(activityController.staffActivityLog, isNull);
  });
}
