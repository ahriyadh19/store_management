import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/store_invoices_controller.dart';
import 'package:store_management/models/store_invoice.dart';
import 'package:store_management/services/request.dart';

void main() {
  final createdAt = DateTime.fromMillisecondsSinceEpoch(1713744000000);
  final updatedAt = DateTime.fromMillisecondsSinceEpoch(1713830400000);

  StoreInvoice buildInvoice() {
    return StoreInvoice(
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
  }

  Request buildRequest({Map<String, dynamic>? data, String title = 'Request', String message = 'Controller request'}) {
    return Request(title: title, message: message, data: data);
  }

  Map<String, dynamic> buildInvoiceData({
    int? id,
    int storeId = 1,
    String storeUuid = '11111111-1111-4111-8111-111111111111',
    int clientId = 2,
    String clientUuid = '22222222-2222-4222-8222-222222222222',
    String invoiceNumber = 'INV-001',
    num totalAmount = 200,
    num paidAmount = 50,
    num balanceAmount = 150,
    String notes = 'Monthly invoice',
    int? issuedAt,
    int? dueAt,
    int status = 1,
  }) {
    final data = <String, dynamic>{
      'storeId': storeId,
      'storeUuid': storeUuid,
      'clientId': clientId,
      'clientUuid': clientUuid,
      'invoiceNumber': invoiceNumber,
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
      expect(response.data?.clientId, 2);
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