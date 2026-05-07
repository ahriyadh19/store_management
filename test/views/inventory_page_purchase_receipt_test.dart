import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/views/pages/inventory_page.dart';

void main() {
  testWidgets('purchase receiving submit maps expected payload', (tester) async {
    tester.view.physicalSize = const Size(1600, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    var called = 0;
    late Map<String, dynamic> payload;

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: InventoryPage(
            title: 'Inventory',
            description: 'Track stock movements and receiving operations.',
            icon: Icons.warehouse_rounded,
            purchaseReceiptPoster: ({
              required String ownerUuid,
              required String storeUuid,
              required String branchUuid,
              required String supplierUuid,
              required String productUuid,
              required String supplierInvoiceUuid,
              String? batchNumber,
              DateTime? expiryDate,
              required int quantity,
              required num unitCost,
              String? staffUserUuid,
            }) async {
              called += 1;
              payload = <String, dynamic>{
                'ownerUuid': ownerUuid,
                'storeUuid': storeUuid,
                'branchUuid': branchUuid,
                'supplierUuid': supplierUuid,
                'productUuid': productUuid,
                'supplierInvoiceUuid': supplierInvoiceUuid,
                'batchNumber': batchNumber,
                'expiryDate': expiryDate,
                'quantity': quantity,
                'unitCost': unitCost,
                'staffUserUuid': staffUserUuid,
              };
              return 'batch-test-001';
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('purchase-receipt-ownerUuid')), 'owner-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-storeUuid')), 'store-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-branchUuid')), 'branch-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-supplierUuid')), 'supplier-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-supplierInvoiceUuid')), 'supplier-invoice-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-productUuid')), 'product-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-batchNumber')), 'BATCH-9001');
    await tester.enterText(find.byKey(const Key('purchase-receipt-quantity')), '8');
    await tester.enterText(find.byKey(const Key('purchase-receipt-unitCost')), '12.5');
    await tester.enterText(find.byKey(const Key('purchase-receipt-expiryDate')), '2026-06-01');
    await tester.enterText(find.byKey(const Key('purchase-receipt-staffUserUuid')), 'staff-uuid-1');

    await tester.tap(find.byKey(const Key('purchase-receipt-submit')));
    await tester.pumpAndSettle();

    expect(called, 1);
    expect(payload['ownerUuid'], 'owner-uuid-1');
    expect(payload['storeUuid'], 'store-uuid-1');
    expect(payload['branchUuid'], 'branch-uuid-1');
    expect(payload['supplierUuid'], 'supplier-uuid-1');
    expect(payload['supplierInvoiceUuid'], 'supplier-invoice-uuid-1');
    expect(payload['productUuid'], 'product-uuid-1');
    expect(payload['batchNumber'], 'BATCH-9001');
    expect(payload['quantity'], 8);
    expect(payload['unitCost'], 12.5);
    expect(payload['expiryDate'], DateTime.parse('2026-06-01'));
    expect(payload['staffUserUuid'], 'staff-uuid-1');
    expect(find.textContaining('Purchase receipt posted. Batch: batch-test-001'), findsOneWidget);
  });

  testWidgets('purchase receiving blocks submit on invalid expiry date', (tester) async {
    tester.view.physicalSize = const Size(1600, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    var called = 0;

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: InventoryPage(
            title: 'Inventory',
            description: 'Track stock movements and receiving operations.',
            icon: Icons.warehouse_rounded,
            purchaseReceiptPoster: ({
              required String ownerUuid,
              required String storeUuid,
              required String branchUuid,
              required String supplierUuid,
              required String productUuid,
              required String supplierInvoiceUuid,
              String? batchNumber,
              DateTime? expiryDate,
              required int quantity,
              required num unitCost,
              String? staffUserUuid,
            }) async {
              called += 1;
              return 'batch-test-001';
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('purchase-receipt-ownerUuid')), 'owner-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-storeUuid')), 'store-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-branchUuid')), 'branch-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-supplierUuid')), 'supplier-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-supplierInvoiceUuid')), 'supplier-invoice-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-productUuid')), 'product-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-quantity')), '8');
    await tester.enterText(find.byKey(const Key('purchase-receipt-unitCost')), '12.5');
    await tester.enterText(find.byKey(const Key('purchase-receipt-expiryDate')), 'not-a-date');

    await tester.tap(find.byKey(const Key('purchase-receipt-submit')));
    await tester.pumpAndSettle();

    expect(called, 0);
    expect(find.text('Expiry date must use YYYY-MM-DD format.'), findsOneWidget);
  });

  testWidgets('purchase receiving blocks submit on invalid numeric values', (tester) async {
    tester.view.physicalSize = const Size(1600, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    var called = 0;

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: InventoryPage(
            title: 'Inventory',
            description: 'Track stock movements and receiving operations.',
            icon: Icons.warehouse_rounded,
            purchaseReceiptPoster: ({
              required String ownerUuid,
              required String storeUuid,
              required String branchUuid,
              required String supplierUuid,
              required String productUuid,
              required String supplierInvoiceUuid,
              String? batchNumber,
              DateTime? expiryDate,
              required int quantity,
              required num unitCost,
              String? staffUserUuid,
            }) async {
              called += 1;
              return 'batch-test-001';
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('purchase-receipt-ownerUuid')), 'owner-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-storeUuid')), 'store-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-branchUuid')), 'branch-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-supplierUuid')), 'supplier-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-supplierInvoiceUuid')), 'supplier-invoice-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-productUuid')), 'product-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-quantity')), '-2');
    await tester.enterText(find.byKey(const Key('purchase-receipt-unitCost')), 'x');

    await tester.tap(find.byKey(const Key('purchase-receipt-submit')));
    await tester.pumpAndSettle();

    expect(called, 0);
    expect(find.text('Enter a valid number'), findsOneWidget);
  });

  testWidgets('purchase receiving blocks submit when required field is empty', (tester) async {
    tester.view.physicalSize = const Size(1600, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    var called = 0;

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: InventoryPage(
            title: 'Inventory',
            description: 'Track stock movements and receiving operations.',
            icon: Icons.warehouse_rounded,
            purchaseReceiptPoster: ({
              required String ownerUuid,
              required String storeUuid,
              required String branchUuid,
              required String supplierUuid,
              required String productUuid,
              required String supplierInvoiceUuid,
              String? batchNumber,
              DateTime? expiryDate,
              required int quantity,
              required num unitCost,
              String? staffUserUuid,
            }) async {
              called += 1;
              return 'batch-test-001';
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('purchase-receipt-ownerUuid')), 'owner-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-storeUuid')), '');
    await tester.enterText(find.byKey(const Key('purchase-receipt-branchUuid')), 'branch-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-supplierUuid')), 'supplier-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-supplierInvoiceUuid')), 'supplier-invoice-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-productUuid')), 'product-uuid-1');
    await tester.enterText(find.byKey(const Key('purchase-receipt-quantity')), '8');
    await tester.enterText(find.byKey(const Key('purchase-receipt-unitCost')), '12.5');

    await tester.tap(find.byKey(const Key('purchase-receipt-submit')));
    await tester.pumpAndSettle();

    expect(called, 0);
    expect(find.text('Store UUID is required'), findsOneWidget);
  });
}
