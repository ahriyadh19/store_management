import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/views/index/dashboard_home_page.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

void main() {
  testWidgets('dashboard home page renders modern syncfusion charts and execution board', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const Scaffold(
          body: DashboardHomePage(
            authState: AuthState(status: AuthStatus.authenticated, userEmail: 'owner@store.com'),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1800));

    expect(find.text('Welcome to Store Management!'), findsOneWidget);
    expect(find.text('Workspace Pulse'), findsOneWidget);
    expect(find.text('Execution Board'), findsOneWidget);
    expect(find.byType(SfCartesianChart), findsOneWidget);
    expect(find.byType(SfCircularChart), findsOneWidget);
    expect(find.byType(SfSparkAreaChart), findsWidgets);
  });

  testWidgets('dashboard home page opens mapped pages from hero actions and metric cards', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final openedPages = <IndexPage>[];

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        home: Scaffold(
          body: DashboardHomePage(
            authState: const AuthState(status: AuthStatus.authenticated, userEmail: 'owner@store.com'),
            onOpenPage: openedPages.add,
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1800));

    await tester.tap(find.byIcon(Icons.hub_rounded));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.auto_awesome_motion_rounded));
    await tester.pump();

    expect(openedPages, contains(IndexPage.reports));
    expect(openedPages, contains(IndexPage.transactions));
  });
}