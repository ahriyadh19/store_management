import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/views/pages/reports_page.dart';

void main() {
  testWidgets('reports page shows analytics, sync health, and recent activity sections', (tester) async {
    tester.view.physicalSize = const Size(1400, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        home: const Scaffold(body: ReportsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Operational Snapshot'), findsOneWidget);
    expect(find.text('Stores'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Sync Health'), 300);
    expect(find.text('Sync Health'), findsOneWidget);
    expect(find.text('Pending writes'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Recent Activity'), 300);
    expect(find.text('Recent Activity'), findsOneWidget);
  });
}