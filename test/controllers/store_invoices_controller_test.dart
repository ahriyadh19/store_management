import 'package:decimal/decimal.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/store_invoices_controller.dart';
import 'package:store_management/models/model_enums.dart';
import 'package:store_management/models/store_invoice.dart';
import 'package:store_management/services/request.dart';

void main() {
  final createdAt = DateTime.fromMillisecondsSinceEpoch(1713744000000);
  final updatedAt = DateTime.fromMillisecondsSinceEpoch(1713830400000);

  StoreInvoice buildInvoice() {
    return StoreInvoice(
      id: 1,
      uuid: 'invoice-uuid',
      storeUuid: '11111111-1111-4111-8111-111111111111',
      clientUuid: '22222222-2222-4222-8222-222222222222',
      invoiceNumber: 'INV-001',
      invoiceType: StoreInvoiceType.cash,
      itemCount: 0,
      totalAmount: Decimal.parse('200'),
      paidAmount: Decimal.parse('50'),
      balanceAmount: Decimal.parse('150'),
      notes: 'Monthly invoice',
      issuedAt: createdAt,
      dueAt: updatedAt,
      status: 1,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Request buildRequest({Map<String, dynamic>? data, String title = 'Request', String message = 'Controller request'}) {
    return Request(title: title, message: message, data: data);
  }

  Map<String, dynamic> buildInvoiceData({
    int? id,
    String storeUuid = '11111111-1111-4111-8111-111111111111',
    String clientUuid = '22222222-2222-4222-8222-222222222222',
    String invoiceNumber = 'INV-001',
    String invoiceType = 'cash',
    int itemCount = 0,
    num totalAmount = 200,
    num paidAmount = 50,
    num balanceAmount = 150,
    String notes = 'Monthly invoice',
    int? issuedAt,
    int? dueAt,
    int status = 1,
  }) {
    final data = <String, dynamic>{
      'storeUuid': storeUuid,
      'clientUuid': clientUuid,
      'invoiceNumber': invoiceNumber,
      'invoiceType': invoiceType,
      'itemCount': itemCount,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'balanceAmount': balanceAmount,
      'notes': notes,
      'issuedAt': issuedAt ?? createdAt.millisecondsSinceEpoch,
      'dueAt': dueAt ?? updatedAt.millisecondsSinceEpoch,
      'status': status,
    };

    if (id != null) {
      data['id'] = id;
    }

    return data;
  }

  group('StoreInvoicesController responses', () {
    test('create returns created response with invoice data', () {
      final controller = StoreInvoicesController(invoice: buildInvoice());

      final response = controller.create(request: buildRequest(data: buildInvoiceData(id: 1)));

      expect(response.statusCode, 201);
      expect(response.data, isA<StoreInvoice>());
      expect(response.data?.invoiceNumber, 'INV-001');
      expect(response.data?.invoiceType, StoreInvoiceType.cash);
      expect(response.data?.itemCount, 0);
      expect(response.data?.clientUuid, '22222222-2222-4222-8222-222222222222');
      expect(response.data?.totalAmount, Decimal.parse('200'));
    });

    test('create accepts zero item invoices with credit type', () {
      final controller = StoreInvoicesController(invoice: buildInvoice());

      final response = controller.create(
        request: buildRequest(data: buildInvoiceData(invoiceType: 'credit', itemCount: 0, totalAmount: 120, paidAmount: 0, balanceAmount: 120)),
      );

      expect(response.statusCode, 201);
      expect(response.data?.invoiceType, StoreInvoiceType.credit);
      expect(response.data?.itemCount, 0);
      expect(response.data?.balanceAmount, Decimal.parse('120'));
    });

    test('create validates required invoice notes', () {
      final controller = StoreInvoicesController(invoice: buildInvoice());

      final response = controller.create(request: buildRequest(data: buildInvoiceData(notes: '')));

      expect(response.statusCode, 400);
      expect(response.message, 'Invoice notes are required');
    });

    test('all returns invoice list response', () {
      final controller = StoreInvoicesController(invoice: buildInvoice());

      final response = controller.all(request: buildRequest());

      expect(response.statusCode, 200);
      expect(response.data, isA<List<StoreInvoice>>());
      expect((response.data as List<StoreInvoice>).single.id, 1);
    });
  });
}