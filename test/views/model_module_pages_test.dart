import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:store_management/views/pages/main_module_pages.dart';
import 'package:store_management/views/pages/model_module_pages.dart';

void main() {
  test('branch table is not treated as owner-scoped for sync queries', () {
    expect(tableUsesOwnerScopeForTesting('branch'), isFalse);
    expect(tableUsesOwnerScopeForTesting('store'), isTrue);
  });

  test('invoice-related client fields use dropdown selections', () {
    final english = AppLocalizations(const Locale('en'));

    expect(fieldUsesSelectionForTesting(invoiceFormDefinition(english), 'clientUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(returnFormDefinition(english), 'clientUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(paymentVoucherFormDefinition(english), 'clientUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(salesOrderFormDefinition(english), 'customerUuid'), isTrue);
    expect(fieldUsesSelectionForTesting(salesInvoiceFormDefinition(english), 'customerUuid'), isTrue);
  });

  testWidgets('product module page shows datatable, create toggle, and row actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        home: Scaffold(
          body: buildMainModulePage(
            page: IndexPage.products,
            title: 'Products',
            description: 'Prepare the product catalog with stock-ready items, pricing, and identifiers.',
            icon: Icons.inventory_2_rounded,
            highlights: const ['Product table', 'Pricing'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Create Product'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.text('Show create'), findsOneWidget);
    expect(find.text('Products Datatable'), findsOneWidget);
    expect(find.text('View, edit, and delete are in the last column.'), findsOneWidget);
    expect(find.text('Rows per page:'), findsOneWidget);
    expect(find.text('10'), findsWidgets);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('Hide create'), findsOneWidget);
  });

  testWidgets('inventory module shows dedicated purchase receiving panel', (tester) async {
    tester.view.physicalSize = const Size(1600, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        home: Scaffold(
          body: buildMainModulePage(
            page: IndexPage.inventory,
            title: 'Inventory',
            description: 'Track stock movements and receiving operations.',
            icon: Icons.warehouse_rounded,
            highlights: const ['Stock movement', 'Transfers'],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Purchase receiving'), findsOneWidget);
    expect(find.text('Post purchase receipt'), findsOneWidget);
    expect(find.text('Batches'), findsOneWidget);
    expect(find.text('Transactions'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Store UUID'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Branch UUID'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Supplier invoice UUID'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Quantity'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Unit cost'), findsOneWidget);
  });
}
