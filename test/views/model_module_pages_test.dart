import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:store_management/views/pages/main_module_pages.dart';

void main() {
  testWidgets('product module page shows datatable, create toggle, and row actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
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

    expect(find.text('Create Product'), findsOneWidget);
    expect(find.text('Show form'), findsOneWidget);
    expect(find.text('Hide form'), findsOneWidget);
    expect(find.text('Products Datatable'), findsOneWidget);
    expect(find.text('Actions'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Warehouse Rice 50kg');
    final saveButton = find.widgetWithText(FilledButton, 'Save Product');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Saved product successfully.'), findsOneWidget);
    expect(find.text('Warehouse Rice 50kg'), findsWidgets);
    expect(find.byTooltip('View Product'), findsWidgets);
    expect(find.byTooltip('Edit Product'), findsWidgets);
    expect(find.byTooltip('Delete Product'), findsWidgets);
  });
}
