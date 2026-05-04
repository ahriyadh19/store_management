import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:store_management/views/pages/main_module_pages.dart';

void main() {
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
    expect(find.text('Actions'), findsOneWidget);
    expect(find.text('Rows per page:'), findsOneWidget);
    expect(find.text('10'), findsWidgets);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('Hide create'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'Warehouse Rice 50kg');
    final saveButton = find.widgetWithText(FilledButton, 'Save Product');
    await tester.dragUntilVisible(saveButton, find.byType(ListView).first, const Offset(0, -220));
    await tester.ensureVisible(saveButton);
    await tester.pump();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Saved Product successfully.'), findsOneWidget);
    expect(find.text('Warehouse Rice 50kg'), findsWidgets);
    expect(find.byTooltip('View Product'), findsWidgets);
    expect(find.byTooltip('Edit Product'), findsWidgets);
    expect(find.byTooltip('Delete Product?'), findsWidgets);

    final deleteButtons = find.byTooltip('Delete Product?');
    await tester.ensureVisible(deleteButtons.first);
    await tester.tap(deleteButtons.first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byTooltip('Delete Product?').first);
    await tester.tap(find.byTooltip('Delete Product?').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byTooltip('Delete Product?').first);
    await tester.tap(find.byTooltip('Delete Product?').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();

    expect(find.text('No data available.'), findsOneWidget);
    expect(find.text('Rows per page:'), findsNothing);
  });
}
