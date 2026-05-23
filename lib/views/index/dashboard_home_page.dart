import 'dart:async';

import 'package:flutter/material.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/offline_sync_record.dart';
import 'package:store_management/models/users.dart';
import 'package:store_management/services/local_database.dart';
import 'package:store_management/services/local_database_management_controller.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

const List<String> _catalogTables = <String>['products', 'category', 'tags'];
const List<String> _salesTables = <String>['store_invoice', 'sales_invoice', 'store_return', 'sales_return', 'store_payment_voucher'];
const List<String> _peopleTables = <String>['client', 'supplier', 'users', 'roles', 'store_supplier', 'store_client', 'store_user', 'user_roles'];
const List<String> _operationsTables = <String>[
  'store',
  'branch',
  'inventory_movement',
  'inventory_batch',
  'inventory_transaction',
  'purchase_order',
  'purchase_order_item',
  'supplier_invoice',
  'transfer_order',
  'transfer_order_item',
  'store_branches',
  'branch_product',
  'store_invoice_item',
  'payment_allocation',
  'store_return_item',
  'branch_price',
  'promotion_rule',
  'staff_shift',
  'staff_attendance',
  'staff_activity_log',
  'store_financial_transaction',
];

const Map<IndexPage, List<String>> _moduleTables = <IndexPage, List<String>>{
  IndexPage.stores: <String>['store'],
  IndexPage.branches: <String>['branch', 'store_branches'],
  IndexPage.products: <String>['products', 'branch_product', 'branch_price'],
  IndexPage.categories: <String>['category'],
  IndexPage.tags: <String>['tags'],
  IndexPage.invoices: <String>['store_invoice', 'sales_invoice', 'store_invoice_item'],
  IndexPage.returns: <String>['store_return', 'sales_return', 'store_return_item'],
  IndexPage.paymentVouchers: <String>['store_payment_voucher', 'payment_allocation'],
  IndexPage.clients: <String>['client', 'store_client'],
  IndexPage.suppliers: <String>['supplier', 'store_supplier', 'supplier_invoice'],
  IndexPage.users: <String>['users', 'store_user'],
  IndexPage.roles: <String>['roles', 'role_permissions', 'user_roles', 'user_permissions'],
  IndexPage.inventory: <String>[
    'inventory_movement',
    'inventory_batch',
    'inventory_transaction',
    'purchase_order',
    'purchase_order_item',
    'transfer_order',
    'transfer_order_item',
    'sales_order',
    'sales_invoice',
    'sales_return',
    'promotion_rule',
    'branch_price',
    'staff_shift',
    'staff_attendance',
    'staff_activity_log',
    'branch_product',
  ],
  IndexPage.transactions: <String>['store_financial_transaction', 'inventory_transaction', 'inventory_movement', 'payment_allocation'],
};

const List<String> _activityTables = <String>[
  'staff_activity_log',
  'inventory_transaction',
  'store_financial_transaction',
  'store_invoice',
  'sales_invoice',
  'purchase_order',
  'supplier_invoice',
  'store_supplier',
  'store_client',
  'store_branches',
];

String _initialsForUser(String? name, String? email) {
  final source = (name?.trim().isNotEmpty == true ? name!.trim() : email?.trim()) ?? '';
  if (source.isEmpty) {
    return 'SM';
  }

  final segments = source.split(RegExp(r'\s+|@|\.|_')).where((segment) => segment.isNotEmpty).toList();
  if (segments.isEmpty) {
    final end = source.length >= 2 ? 2 : source.length;
    return source.substring(0, end).toUpperCase();
  }

  return segments.take(2).map((segment) => segment[0].toUpperCase()).join();
}

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key, required this.authState, this.localDatabaseManagementController, this.onOpenPage});

  final AuthState authState;
  final LocalDatabaseManagementController? localDatabaseManagementController;
  final ValueChanged<IndexPage>? onOpenPage;

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..forward();
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final managementController = widget.localDatabaseManagementController;
    if (managementController == null) {
      return _buildDashboard(context);
    }

    return AnimatedBuilder(animation: managementController, builder: (context, child) => _buildDashboard(context));
  }

  Widget _buildDashboard(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final snapshot = _DashboardSnapshot.fromSources(l10n: l10n, database: LocalDatabase.current, syncController: widget.localDatabaseManagementController);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[colorScheme.surface, colorScheme.surfaceContainerLow, colorScheme.surfaceContainerLowest]),
      ),
      child: Stack(
        children: [
          const Positioned(top: -70, right: -40, child: _BackdropOrb(size: 220, color: Color(0x30127E78))),
          const Positioned(top: 280, left: -40, child: _BackdropOrb(size: 180, color: Color(0x26E1743B))),
          const Positioned(bottom: -60, right: 100, child: _BackdropOrb(size: 240, color: Color(0x225567D8))),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1340),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DashboardReveal(
                      controller: _controller,
                      interval: const Interval(0.0, 0.28, curve: Curves.easeOutCubic),
                      child: _DashboardHeroCard(authState: widget.authState, signals: snapshot.signalRows, onOpenPage: _handleOpenPage),
                    ),
                    const SizedBox(height: 18),
                    _DashboardReveal(
                      controller: _controller,
                      interval: const Interval(0.12, 0.46, curve: Curves.easeOutCubic),
                      child: _MetricRail(metrics: snapshot.metrics, onOpenPage: _handleOpenPage),
                    ),
                    const SizedBox(height: 18),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 1080;
                        if (!isWide) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _DashboardReveal(
                                controller: _controller,
                                interval: const Interval(0.24, 0.58, curve: Curves.easeOutCubic),
                                child: _PulsePanel(series: snapshot.pulseSeries, statusLabel: snapshot.pulseStatusLabel),
                              ),
                              const SizedBox(height: 18),
                              _DashboardReveal(
                                controller: _controller,
                                interval: const Interval(0.34, 0.7, curve: Curves.easeOutCubic),
                                child: _ModuleMixPanel(slices: snapshot.moduleMix, centerValue: snapshot.moduleCenterValue, onOpenPage: _handleOpenPage),
                              ),
                              const SizedBox(height: 18),
                              _DashboardReveal(
                                controller: _controller,
                                interval: const Interval(0.44, 0.86, curve: Curves.easeOutCubic),
                                child: _ExecutionBoard(items: snapshot.executionItems, onOpenPage: _handleOpenPage),
                              ),
                              const SizedBox(height: 18),
                              _DashboardReveal(
                                controller: _controller,
                                interval: const Interval(0.52, 0.94, curve: Curves.easeOutCubic),
                                child: _RecentActivityPanel(items: snapshot.recentActivities, onOpenPage: _handleOpenPage),
                              ),
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 7,
                              child: Column(
                                children: [
                                  _DashboardReveal(
                                    controller: _controller,
                                    interval: const Interval(0.24, 0.58, curve: Curves.easeOutCubic),
                                    child: _PulsePanel(series: snapshot.pulseSeries, statusLabel: snapshot.pulseStatusLabel),
                                  ),
                                  const SizedBox(height: 18),
                                  _DashboardReveal(
                                    controller: _controller,
                                    interval: const Interval(0.44, 0.88, curve: Curves.easeOutCubic),
                                    child: _ExecutionBoard(items: snapshot.executionItems, onOpenPage: _handleOpenPage),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              flex: 4,
                              child: Column(
                                children: [
                                  _DashboardReveal(
                                    controller: _controller,
                                    interval: const Interval(0.34, 0.7, curve: Curves.easeOutCubic),
                                    child: _ModuleMixPanel(slices: snapshot.moduleMix, centerValue: snapshot.moduleCenterValue, onOpenPage: _handleOpenPage),
                                  ),
                                  const SizedBox(height: 18),
                                  _DashboardReveal(
                                    controller: _controller,
                                    interval: const Interval(0.52, 0.94, curve: Curves.easeOutCubic),
                                    child: _RecentActivityPanel(items: snapshot.recentActivities, onOpenPage: _handleOpenPage),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleOpenPage(IndexPage page) {
    widget.onOpenPage?.call(page);
  }
}

class _DashboardHeroCard extends StatelessWidget {
  const _DashboardHeroCard({required this.authState, required this.signals, required this.onOpenPage});

  final AuthState authState;
  final List<_SignalRow> signals;
  final ValueChanged<IndexPage> onOpenPage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final User? user = authState.user;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[Color(0xFF0F766E), Color(0xFF14532D), Color(0xFF312E81)]),
        boxShadow: const <BoxShadow>[BoxShadow(color: Color(0x24111B33), blurRadius: 30, offset: Offset(0, 20))],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 930;
          final content = <Widget>[
            Expanded(
              flex: isWide ? 6 : 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _LiveBeacon(),
                        const SizedBox(width: 8),
                        Text(
                          l10n.readyToManage,
                          style: theme.textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.welcomeTitle,
                    style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, height: 1.0),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.pick(
                      'Live operations telemetry driven by your cached database, with direct access into each management area.',
                      'قياسات تشغيلية مباشرة مدفوعة بقاعدة البيانات المحلية مع وصول مباشر إلى كل مساحة إدارة.',
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.84), height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _HeroBadge(label: l10n.connectedWorkspace, icon: Icons.hub_rounded, onTap: () => onOpenPage(IndexPage.reports)),
                      _HeroBadge(label: l10n.quickActions, icon: Icons.bolt_rounded, onTap: () => onOpenPage(IndexPage.inventory)),
                      _HeroBadge(label: l10n.sync, icon: Icons.auto_awesome_motion_rounded, onTap: () => onOpenPage(IndexPage.transactions)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: isWide ? 18 : 0, height: isWide ? 0 : 18),
            Expanded(
              flex: isWide ? 4 : 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white.withValues(alpha: 0.16),
                          child: Text(
                            _initialsForUser(user?.name, authState.userEmail),
                            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.signedInAs, style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70)),
                              const SizedBox(height: 4),
                              Text(
                                user?.name.isNotEmpty == true ? user!.name : (authState.userEmail ?? l10n.signedInFallback),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ...signals.map(
                      (signal) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _SignalTile(signal: signal, onTap: signal.page == null ? null : () => onOpenPage(signal.page!)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: colorScheme.primary, minimumSize: const Size.fromHeight(46)),
                      icon: const Icon(Icons.dashboard_customize_rounded),
                      label: Text(l10n.menu),
                    ),
                  ],
                ),
              ),
            ),
          ];

          if (isWide) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: content);
          }

          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: content);
        },
      ),
    );
  }
}

class _MetricRail extends StatelessWidget {
  const _MetricRail({required this.metrics, required this.onOpenPage});

  final List<_DashboardMetric> metrics;
  final ValueChanged<IndexPage> onOpenPage;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: metrics
          .map(
            (metric) => SizedBox(
              width: 308,
              child: _MetricCard(metric: metric, onTap: metric.page == null ? null : () => onOpenPage(metric.page!)),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric, this.onTap});

  final _DashboardMetric metric;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
        boxShadow: <BoxShadow>[BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.06), blurRadius: 22, offset: const Offset(0, 14))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: metric.accentColor.withValues(alpha: 0.14)),
                child: Icon(metric.icon, color: metric.accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(metric.label, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(metric.caption, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              if (onTap != null) Icon(Icons.arrow_outward_rounded, color: metric.accentColor, size: 18),
            ],
          ),
          const SizedBox(height: 16),
          Text(metric.value, style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900, height: 0.95)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 72,
              child: SfSparkAreaChart(
                data: metric.trend,
                borderColor: metric.accentColor,
                borderWidth: 2.5,
                color: metric.accentColor.withValues(alpha: 0.22),
                axisLineWidth: 0,
                trackball: const SparkChartTrackball(activationMode: SparkChartActivationMode.tap),
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return child;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: BorderRadius.circular(28), onTap: onTap, child: child),
    );
  }
}

class _PulsePanel extends StatelessWidget {
  const _PulsePanel({required this.series, required this.statusLabel});

  final List<_PulsePoint> series;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final tooltipBehavior = TooltipBehavior(enable: true, header: '', canShowMarker: true);

    return _DashboardPanel(
      title: l10n.pick('Workspace Pulse', 'نبض مساحة العمل'),
      subtitle: l10n.pick('Weekly movement based on live activity, invoices, stock transactions, and cached updates.', 'الحركة الأسبوعية بناء على النشاط المباشر والفواتير وحركات المخزون والتحديثات المخزنة.'),
      actionLabel: statusLabel,
      child: SizedBox(
        height: 320,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          tooltipBehavior: tooltipBehavior,
          margin: EdgeInsets.zero,
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
            axisLine: const AxisLine(width: 0),
            labelStyle: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            axisLine: const AxisLine(width: 0),
            majorTickLines: const MajorTickLines(size: 0),
            labelStyle: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            majorGridLines: MajorGridLines(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.34), dashArray: const <double>[6, 5]),
          ),
          series: <CartesianSeries<_PulsePoint, String>>[
            SplineAreaSeries<_PulsePoint, String>(
              dataSource: series,
              xValueMapper: (_PulsePoint point, _) => point.label,
              yValueMapper: (_PulsePoint point, _) => point.value,
              borderColor: const Color(0xFF0F766E),
              borderWidth: 3,
              gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: <Color>[Color(0x99127E78), Color(0x22127E78)]),
              animationDuration: 1400,
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleMixPanel extends StatelessWidget {
  const _ModuleMixPanel({required this.slices, required this.centerValue, required this.onOpenPage});

  final List<_MixSlice> slices;
  final String centerValue;
  final ValueChanged<IndexPage> onOpenPage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return _DashboardPanel(
      title: l10n.pick('Module Balance', 'توازن الوحدات'),
      subtitle: l10n.pick('Live record distribution across the operational areas of the workspace.', 'توزيع السجلات المباشر عبر المساحات التشغيلية في مساحة العمل.'),
      actionLabel: l10n.pick('Interactive mix', 'مزيج تفاعلي'),
      child: Column(
        children: [
          SizedBox(
            height: 280,
            child: SfCircularChart(
              margin: EdgeInsets.zero,
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(centerValue, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
                      Text(l10n.activeModules, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
              series: <CircularSeries<_MixSlice, String>>[
                DoughnutSeries<_MixSlice, String>(
                  dataSource: slices,
                  xValueMapper: (_MixSlice slice, _) => slice.label,
                  yValueMapper: (_MixSlice slice, _) => slice.value,
                  pointColorMapper: (_MixSlice slice, _) => slice.color,
                  innerRadius: '72%',
                  radius: '94%',
                  animationDuration: 1400,
                  dataLabelSettings: const DataLabelSettings(isVisible: false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...slices.map(
            (slice) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => onOpenPage(slice.page),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(color: slice.color, borderRadius: BorderRadius.circular(999)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(slice.label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                      ),
                      Text('${slice.value.toInt()}%', style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_outward_rounded, color: slice.color, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExecutionBoard extends StatelessWidget {
  const _ExecutionBoard({required this.items, required this.onOpenPage});

  final List<_ExecutionItem> items;
  final ValueChanged<IndexPage> onOpenPage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _DashboardPanel(
      title: l10n.pick('Execution Board', 'لوحة التنفيذ'),
      subtitle: l10n.pick('Operational sections computed from live cache coverage and synchronization readiness.', 'الأقسام التشغيلية محسوبة من تغطية المخزن المباشر وجاهزية المزامنة.'),
      actionLabel: l10n.quickActions,
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: items
            .map(
              (item) => SizedBox(
                width: 310,
                child: _ExecutionCard(item: item, onOpenPage: onOpenPage),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _ExecutionCard extends StatelessWidget {
  const _ExecutionCard({required this.item, required this.onOpenPage});

  final _ExecutionItem item;
  final ValueChanged<IndexPage> onOpenPage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completionLabel = '${(item.completion * 100).round()}%';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => onOpenPage(item.page),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: item.accentColor.withValues(alpha: 0.16)),
            boxShadow: <BoxShadow>[BoxShadow(color: item.accentColor.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 12))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: item.accentColor.withValues(alpha: 0.12)),
                    child: Icon(item.icon, color: item.accentColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          completionLabel,
                          style: theme.textTheme.labelLarge?.copyWith(color: item.accentColor, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_outward_rounded, color: item.accentColor, size: 18),
                ],
              ),
              const SizedBox(height: 12),
              Text(item.subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.45)),
              const SizedBox(height: 14),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: item.completion),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(value: value, minHeight: 9, backgroundColor: item.accentColor.withValues(alpha: 0.12), valueColor: AlwaysStoppedAnimation<Color>(item.accentColor)),
                  );
                },
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: item.chips.map((chip) => _ModuleChip(label: chip.label, color: item.accentColor, onTap: () => onOpenPage(chip.page))).toList(growable: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentActivityPanel extends StatelessWidget {
  const _RecentActivityPanel({required this.items, required this.onOpenPage});

  final List<_RecentActivityItem> items;
  final ValueChanged<IndexPage> onOpenPage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _DashboardPanel(
      title: l10n.pick('Recent Activity', 'النشاط الأخير'),
      subtitle: l10n.pick('Most recent records and operational touches detected in the live cache.', 'أحدث السجلات واللمسات التشغيلية المكتشفة في المخزن المباشر.'),
      actionLabel: l10n.pick('${items.length} items', '${items.length} عناصر'),
      child: Column(
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => onOpenPage(item.page),
                    child: Ink(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerLow.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: item.color.withValues(alpha: 0.14)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(color: item.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                            child: Icon(item.icon, color: item.color),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.35),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item.timeLabel,
                                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700, color: item.color),
                              ),
                              const SizedBox(height: 4),
                              const Icon(Icons.arrow_outward_rounded, size: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({required this.title, required this.subtitle, required this.child, required this.actionLabel});

  final String title;
  final String subtitle;
  final String actionLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
        boxShadow: <BoxShadow>[BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.05), blurRadius: 24, offset: const Offset(0, 14))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.45)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(999)),
                child: Text(actionLabel, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _DashboardReveal extends StatelessWidget {
  const _DashboardReveal({required this.controller, required this.interval, required this.child});

  final AnimationController controller;
  final Interval interval;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(parent: controller, curve: interval);
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final value = animation.value;
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 28),
            child: Transform.scale(scale: 0.96 + (value * 0.04), child: child),
          ),
        );
      },
    );
  }
}

class _BackdropOrb extends StatelessWidget {
  const _BackdropOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[BoxShadow(color: color, blurRadius: 80, spreadRadius: 18)],
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label, required this.icon, this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return child;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: BorderRadius.circular(18), onTap: onTap, child: child),
    );
  }
}

class _SignalTile extends StatelessWidget {
  const _SignalTile({required this.signal, this.onTap});

  final _SignalRow signal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: signal.color, borderRadius: BorderRadius.circular(999)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              signal.label,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            signal.value,
            style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return child;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: BorderRadius.circular(18), onTap: onTap, child: child),
    );
  }
}

class _ModuleChip extends StatelessWidget {
  const _ModuleChip({required this.label, required this.color, this.onTap});

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
    );

    if (onTap == null) {
      return child;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: BorderRadius.circular(999), onTap: onTap, child: child),
    );
  }
}

class _LiveBeacon extends StatefulWidget {
  const _LiveBeacon();

  @override
  State<_LiveBeacon> createState() => _LiveBeaconState();
}

class _LiveBeaconState extends State<_LiveBeacon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final easedValue = Curves.easeOut.transform(_controller.value);
        final scale = 0.8 + (easedValue * 0.45);
        final opacity = 1 - (easedValue * 0.7);
        return Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: scale,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: opacity * 0.25),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
            ),
          ],
        );
      },
    );
  }
}

class _DashboardSnapshot {
  const _DashboardSnapshot({
    required this.metrics,
    required this.pulseSeries,
    required this.moduleMix,
    required this.executionItems,
    required this.signalRows,
    required this.recentActivities,
    required this.moduleCenterValue,
    required this.pulseStatusLabel,
  });

  final List<_DashboardMetric> metrics;
  final List<_PulsePoint> pulseSeries;
  final List<_MixSlice> moduleMix;
  final List<_ExecutionItem> executionItems;
  final List<_SignalRow> signalRows;
  final List<_RecentActivityItem> recentActivities;
  final String moduleCenterValue;
  final String pulseStatusLabel;

  factory _DashboardSnapshot.fromSources({required AppLocalizations l10n, required LocalDatabase? database, required LocalDatabaseManagementController? syncController}) {
    final moduleRecordCounts = <IndexPage, int>{for (final entry in _moduleTables.entries) entry.key: _countRowsForTables(database, entry.value)};
    final activeModules = moduleRecordCounts.values.where((count) => count > 0).length;
    final totalModules = _moduleTables.length;
    final salesCount = _countRowsForTables(database, _salesTables);
    final peopleCount = _countRowsForTables(database, _peopleTables);
    final invoiceCount = _countRowsForTables(database, const <String>['store_invoice', 'sales_invoice']);
    final relationshipCount = _countRowsForTables(database, const <String>['store_supplier', 'store_client', 'store_user']);
    final pendingCount = syncController?.pendingSynchronizationCount ?? _pendingRecordCount(database);
    final conflictedCount = database?.getConflictedRecords().length ?? 0;
    final syncRatio = _syncRatio(database);
    final syncPercent = (syncRatio * 100).clamp(0, 100);

    final metrics = <_DashboardMetric>[
      _DashboardMetric(
        label: l10n.activeModules,
        value: '$activeModules/$totalModules',
        caption: l10n.pick('$activeModules modules currently carry cached records', 'تحتوي $activeModules وحدات حاليا على سجلات مخزنة'),
        icon: Icons.apps_rounded,
        accentColor: const Color(0xFF127E78),
        trend: _trendForPages(database, const <IndexPage>[IndexPage.stores, IndexPage.branches, IndexPage.products, IndexPage.inventory]),
        page: IndexPage.reports,
      ),
      _DashboardMetric(
        label: l10n.sales,
        value: _formatCompactNumber(salesCount),
        caption: l10n.pick('$invoiceCount invoice records tracked live', 'يتم تتبع $invoiceCount سجلات فواتير مباشرة'),
        icon: Icons.insights_rounded,
        accentColor: const Color(0xFFE1743B),
        trend: _trendForTables(database, _salesTables),
        page: IndexPage.invoices,
      ),
      _DashboardMetric(
        label: l10n.people,
        value: _formatCompactNumber(peopleCount),
        caption: l10n.pick('$relationshipCount active relationship records mapped', 'تم ربط $relationshipCount سجل علاقات نشط'),
        icon: Icons.groups_rounded,
        accentColor: const Color(0xFF5567D8),
        trend: _trendForTables(database, _peopleTables),
        page: IndexPage.suppliers,
      ),
      _DashboardMetric(
        label: l10n.sync,
        value: '${syncPercent.toStringAsFixed(1)}%',
        caption: l10n.pick('$pendingCount pending changes • $conflictedCount conflicts', '$pendingCount تغييرات معلقة • $conflictedCount تعارضات'),
        icon: Icons.sync_rounded,
        accentColor: const Color(0xFF7A4DD8),
        trend: _syncTrend(database),
        page: IndexPage.transactions,
      ),
    ];

    final overviewCount = _countRowsForTables(database, const <String>['store', 'branch']);
    final catalogCount = _countRowsForTables(database, _catalogTables);
    final salesMixCount = _countRowsForTables(database, _salesTables);
    final peopleMixCount = _countRowsForTables(database, _peopleTables);
    final operationsCount = _countRowsForTables(database, _operationsTables);
    final totalMix = (overviewCount + catalogCount + salesMixCount + peopleMixCount + operationsCount).clamp(1, 1 << 30);
    final moduleMix = <_MixSlice>[
      _MixSlice(l10n.overview, (overviewCount / totalMix) * 100, const Color(0xFF127E78), IndexPage.stores),
      _MixSlice(l10n.catalog, (catalogCount / totalMix) * 100, const Color(0xFFE1743B), IndexPage.products),
      _MixSlice(l10n.sales, (salesMixCount / totalMix) * 100, const Color(0xFF5567D8), IndexPage.invoices),
      _MixSlice(l10n.people, (peopleMixCount / totalMix) * 100, const Color(0xFF8B5CF6), IndexPage.suppliers),
    ];

    final executionItems = <_ExecutionItem>[
      _ExecutionItem(
        title: l10n.catalog,
        subtitle: l10n.pick('${_formatCompactNumber(catalogCount)} catalog records cached across products, categories, and tags.', 'تم تخزين ${_formatCompactNumber(catalogCount)} سجلا لفهرس المنتجات والفئات والوسوم.'),
        icon: Icons.inventory_2_rounded,
        accentColor: const Color(0xFF127E78),
        completion: _completionForTables(database, _catalogTables),
        chips: <_DashboardLinkChip>[
          _DashboardLinkChip(label: '${l10n.products} ${_formatCompactNumber(_countRowsForTables(database, const <String>['products']))}', page: IndexPage.products),
          _DashboardLinkChip(label: '${l10n.categories} ${_formatCompactNumber(_countRowsForTables(database, const <String>['category']))}', page: IndexPage.categories),
          _DashboardLinkChip(label: '${l10n.tags} ${_formatCompactNumber(_countRowsForTables(database, const <String>['tags']))}', page: IndexPage.tags),
        ],
        page: IndexPage.products,
      ),
      _ExecutionItem(
        title: l10n.sales,
        subtitle: l10n.pick('${_formatCompactNumber(salesCount)} sales-side records across invoices, returns, and vouchers.', 'يوجد ${_formatCompactNumber(salesCount)} سجل للمبيعات عبر الفواتير والمرتجعات والسندات.'),
        icon: Icons.point_of_sale_rounded,
        accentColor: const Color(0xFFE1743B),
        completion: _completionForTables(database, _salesTables),
        chips: <_DashboardLinkChip>[
          _DashboardLinkChip(label: '${l10n.invoices} ${_formatCompactNumber(_countRowsForTables(database, const <String>['store_invoice', 'sales_invoice']))}', page: IndexPage.invoices),
          _DashboardLinkChip(label: '${l10n.returns} ${_formatCompactNumber(_countRowsForTables(database, const <String>['store_return', 'sales_return']))}', page: IndexPage.returns),
          _DashboardLinkChip(label: '${l10n.paymentVouchers} ${_formatCompactNumber(_countRowsForTables(database, const <String>['store_payment_voucher']))}', page: IndexPage.paymentVouchers),
        ],
        page: IndexPage.invoices,
      ),
      _ExecutionItem(
        title: l10n.people,
        subtitle: l10n.pick('${_formatCompactNumber(peopleCount)} people and relationship records ready for navigation.', 'هناك ${_formatCompactNumber(peopleCount)} سجلات أشخاص وعلاقات جاهزة للتنقل.'),
        icon: Icons.groups_rounded,
        accentColor: const Color(0xFF5567D8),
        completion: _completionForTables(database, _peopleTables),
        chips: <_DashboardLinkChip>[
          _DashboardLinkChip(label: '${l10n.clients} ${_formatCompactNumber(_countRowsForTables(database, const <String>['client', 'store_client']))}', page: IndexPage.clients),
          _DashboardLinkChip(label: '${l10n.suppliers} ${_formatCompactNumber(_countRowsForTables(database, const <String>['supplier', 'store_supplier']))}', page: IndexPage.suppliers),
          _DashboardLinkChip(label: '${l10n.users} ${_formatCompactNumber(_countRowsForTables(database, const <String>['users', 'store_user']))}', page: IndexPage.users),
        ],
        page: IndexPage.suppliers,
      ),
      _ExecutionItem(
        title: l10n.operations,
        subtitle: l10n.pick(
          '${_formatCompactNumber(operationsCount)} operational records across inventory, movements, and staff activity.',
          'يوجد ${_formatCompactNumber(operationsCount)} سجل تشغيلي عبر المخزون والحركات ونشاط الموظفين.',
        ),
        icon: Icons.settings_suggest_rounded,
        accentColor: const Color(0xFF8B5CF6),
        completion: _completionForTables(database, _operationsTables),
        chips: <_DashboardLinkChip>[
          _DashboardLinkChip(
            label: '${l10n.inventory} ${_formatCompactNumber(_countRowsForTables(database, const <String>['inventory_transaction', 'inventory_movement', 'inventory_batch']))}',
            page: IndexPage.inventory,
          ),
          _DashboardLinkChip(label: '${l10n.transactions} ${_formatCompactNumber(_countRowsForTables(database, const <String>['store_financial_transaction', 'payment_allocation']))}', page: IndexPage.transactions),
          _DashboardLinkChip(label: '${l10n.stores} ${_formatCompactNumber(_countRowsForTables(database, const <String>['store']))}', page: IndexPage.stores),
          _DashboardLinkChip(label: '${l10n.branches} ${_formatCompactNumber(_countRowsForTables(database, const <String>['branch', 'store_branches']))}', page: IndexPage.branches),
        ],
        page: IndexPage.inventory,
      ),
    ];

    final recentActivities = _buildRecentActivities(l10n, database);

    final signalRows = <_SignalRow>[
      _SignalRow(l10n.pick('Sync relay', 'مرحّل المزامنة'), syncController?.synchronizationStateLabel ?? l10n.pick('Cache ready', 'المخزن جاهز'), const Color(0xFF127E78), IndexPage.transactions),
      _SignalRow(l10n.pick('Pending queue', 'الطابور المعلق'), l10n.pick('$pendingCount changes', '$pendingCount تغييرا'), const Color(0xFFE1743B), IndexPage.transactions),
      _SignalRow(l10n.pick('Recent conflicts', 'التعارضات الأخيرة'), l10n.pick('$conflictedCount flagged', '$conflictedCount مؤشر'), const Color(0xFF5567D8), IndexPage.reports),
    ];

    return _DashboardSnapshot(
      metrics: metrics,
      pulseSeries: _trendForTables(database, _activityTables).asMap().entries.map((entry) => _PulsePoint(_weekdayLabel(entry.key), entry.value)).toList(growable: false),
      moduleMix: moduleMix,
      executionItems: executionItems,
      signalRows: signalRows,
      recentActivities: recentActivities,
      moduleCenterValue: activeModules.toString(),
      pulseStatusLabel: syncController?.synchronizationStateLabel ?? l10n.pick('Live cache', 'مخزن مباشر'),
    );
  }
}

int _countRowsForTables(LocalDatabase? database, List<String> tableNames) {
  if (database == null) {
    return 0;
  }

  var total = 0;
  for (final tableName in tableNames) {
    total += database.getRowsForType(tableName).length;
  }
  return total;
}

int _pendingRecordCount(LocalDatabase? database) {
  if (database == null) {
    return 0;
  }

  var count = 0;
  for (final tableName in LocalDatabase.managedModelTypes) {
    for (final record in database.getRecordsForType(tableName)) {
      if (record.syncState != OfflineSyncState.synced) {
        count += 1;
      }
    }
  }
  return count;
}

double _syncRatio(LocalDatabase? database) {
  if (database == null) {
    return 1;
  }

  var total = 0;
  var synced = 0;
  for (final tableName in LocalDatabase.managedModelTypes) {
    for (final record in database.getRecordsForType(tableName)) {
      total += 1;
      if (record.syncState == OfflineSyncState.synced) {
        synced += 1;
      }
    }
  }

  if (total == 0) {
    return 1;
  }
  return synced / total;
}

double _completionForTables(LocalDatabase? database, List<String> tableNames) {
  if (database == null) {
    return 0;
  }

  var total = 0;
  var synced = 0;
  for (final tableName in tableNames) {
    for (final record in database.getRecordsForType(tableName)) {
      total += 1;
      if (record.syncState == OfflineSyncState.synced) {
        synced += 1;
      }
    }
  }

  if (total == 0) {
    return 0.0;
  }
  return (synced / total).clamp(0.0, 1.0);
}

List<double> _trendForPages(LocalDatabase? database, List<IndexPage> pages) {
  final tableNames = <String>[];
  for (final page in pages) {
    final mapped = _moduleTables[page];
    if (mapped != null) {
      tableNames.addAll(mapped);
    }
  }
  return _trendForTables(database, tableNames);
}

List<double> _trendForTables(LocalDatabase? database, List<String> tableNames) {
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  final counts = List<double>.filled(7, 0);

  if (database == null) {
    return const <double>[0.5, 0.8, 0.6, 1.1, 0.9, 1.4, 1.2];
  }

  for (final tableName in tableNames) {
    for (final row in database.getRowsForType(tableName)) {
      final timestamp = _extractTimestamp(row);
      if (timestamp == null) {
        continue;
      }

      final dayStart = DateTime(timestamp.year, timestamp.month, timestamp.day);
      final diffDays = startOfToday.difference(dayStart).inDays;
      if (diffDays < 0 || diffDays > 6) {
        continue;
      }

      final bucketIndex = 6 - diffDays;
      counts[bucketIndex] += 1;
    }
  }

  final hasValues = counts.any((value) => value > 0);
  if (!hasValues) {
    return const <double>[0.5, 0.8, 0.6, 1.1, 0.9, 1.4, 1.2];
  }
  return counts;
}

List<double> _syncTrend(LocalDatabase? database) {
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  final syncedCounts = List<double>.filled(7, 0);
  final totalCounts = List<double>.filled(7, 0);

  if (database == null) {
    return const <double>[0, 0, 0, 0, 0, 0, 0];
  }

  for (final tableName in LocalDatabase.managedModelTypes) {
    for (final record in database.getRecordsForType(tableName)) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(record.updatedAtMillis);
      final dayStart = DateTime(timestamp.year, timestamp.month, timestamp.day);
      final diffDays = startOfToday.difference(dayStart).inDays;
      if (diffDays < 0 || diffDays > 6) {
        continue;
      }

      final bucketIndex = 6 - diffDays;
      totalCounts[bucketIndex] += 1;
      if (record.syncState == OfflineSyncState.synced) {
        syncedCounts[bucketIndex] += 1;
      }
    }
  }

  final trend = <double>[];
  for (var index = 0; index < 7; index++) {
    final total = totalCounts[index];
    if (total == 0) {
      trend.add(0);
      continue;
    }
    trend.add((syncedCounts[index] / total) * 100);
  }
  return trend;
}

DateTime? _extractTimestamp(Map<String, dynamic> row) {
  const keys = <String>[
    'updatedAt',
    'updated_at',
    'createdAt',
    'created_at',
    'syncedAt',
    'synced_at',
    'issuedAt',
    'issued_at',
    'transactionDate',
    'transaction_date',
    'performedAt',
    'performed_at',
    'activityAt',
    'activity_at',
    'date',
  ];

  for (final key in keys) {
    final value = row[key];
    final parsed = _asDateTime(value);
    if (parsed != null) {
      return parsed;
    }
  }

  return null;
}

DateTime? _asDateTime(Object? value) {
  if (value is DateTime) {
    return value;
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }
  if (value is num) {
    return DateTime.fromMillisecondsSinceEpoch(value.toInt());
  }
  if (value is String) {
    final trimmed = value.trim();
    final asInt = int.tryParse(trimmed);
    if (asInt != null) {
      return DateTime.fromMillisecondsSinceEpoch(asInt);
    }
    return DateTime.tryParse(trimmed);
  }
  return null;
}

List<_RecentActivityItem> _buildRecentActivities(AppLocalizations l10n, LocalDatabase? database) {
  if (database == null) {
    return <_RecentActivityItem>[
      _RecentActivityItem(
        title: l10n.pick('No local activity yet', 'لا يوجد نشاط محلي بعد'),
        subtitle: l10n.pick('Open any module to begin caching live operational records.', 'افتح أي وحدة لبدء تخزين السجلات التشغيلية المباشرة.'),
        timeLabel: l10n.pick('Now', 'الآن'),
        page: IndexPage.dashboard,
        icon: Icons.insights_rounded,
        color: const Color(0xFF127E78),
      ),
    ];
  }

  final items = <_RecentActivityItem>[];
  for (final tableName in _activityTables) {
    final page = _pageForTable(tableName);
    if (page == null) {
      continue;
    }

    for (final row in database.getRowsForType(tableName)) {
      final timestamp = _extractTimestamp(row);
      if (timestamp == null) {
        continue;
      }

      final title = _activityTitle(row, tableName, l10n);
      final subtitle = _activitySubtitle(row, page, timestamp, l10n);
      final metadata = indexPageMetadata(page);
      items.add(_RecentActivityItem(title: title, subtitle: subtitle, timeLabel: _relativeTimeLabel(timestamp, l10n), page: page, icon: metadata.icon, color: _pageAccentColor(page), timestamp: timestamp));
    }
  }

  items.sort((left, right) => right.timestamp.compareTo(left.timestamp));
  if (items.isEmpty) {
    return <_RecentActivityItem>[
      _RecentActivityItem(
        title: l10n.pick('No recent activity', 'لا يوجد نشاط حديث'),
        subtitle: l10n.pick('Your dashboard will populate as live records reach the local cache.', 'ستمتلئ اللوحة عندما تصل السجلات المباشرة إلى المخزن المحلي.'),
        timeLabel: l10n.pick('Waiting', 'انتظار'),
        page: IndexPage.reports,
        icon: Icons.hourglass_top_rounded,
        color: const Color(0xFFE1743B),
      ),
    ];
  }

  return items.take(6).toList(growable: false);
}

String _activityTitle(Map<String, dynamic> row, String tableName, AppLocalizations l10n) {
  const titleKeys = <String>['name', 'title', 'username', 'invoiceNumber', 'returnNumber', 'voucherNumber', 'transactionNumber', 'poNumber', 'referenceNumber', 'number', 'description'];
  for (final key in titleKeys) {
    final value = row[key]?.toString().trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
  }

  return switch (tableName) {
    'store_supplier' => l10n.pick('Supplier link updated', 'تم تحديث ربط المورد'),
    'store_client' => l10n.pick('Client link updated', 'تم تحديث ربط العميل'),
    'store_branches' => l10n.pick('Branch assignment updated', 'تم تحديث ربط الفرع'),
    'staff_activity_log' => row['action']?.toString() ?? l10n.pick('Staff activity', 'نشاط موظف'),
    _ => l10n.pick('Recent record update', 'تحديث سجل حديث'),
  };
}

String _activitySubtitle(Map<String, dynamic> row, IndexPage page, DateTime timestamp, AppLocalizations l10n) {
  final descriptors = <String>[];
  final pageLabel = localizedIndexPageTitle(l10n, page);
  descriptors.add(pageLabel);

  const hintKeys = <String>['status', 'transactionType', 'action', 'referenceType', 'amount'];
  for (final key in hintKeys) {
    final value = row[key]?.toString().trim();
    if (value != null && value.isNotEmpty) {
      descriptors.add(value);
      break;
    }
  }
  descriptors.add(_absoluteTimeLabel(timestamp));
  return descriptors.join(' • ');
}

IndexPage? _pageForTable(String tableName) {
  for (final entry in _moduleTables.entries) {
    if (entry.value.contains(tableName)) {
      return entry.key;
    }
  }
  return null;
}

Color _pageAccentColor(IndexPage page) {
  return switch (page) {
    IndexPage.stores || IndexPage.branches || IndexPage.products || IndexPage.inventory => const Color(0xFF127E78),
    IndexPage.invoices || IndexPage.returns || IndexPage.paymentVouchers => const Color(0xFFE1743B),
    IndexPage.clients || IndexPage.suppliers || IndexPage.users || IndexPage.roles => const Color(0xFF5567D8),
    IndexPage.transactions || IndexPage.reports => const Color(0xFF8B5CF6),
    _ => const Color(0xFF127E78),
  };
}

String _formatCompactNumber(int value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(value >= 10000000 ? 0 : 1)}M';
  }
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 1)}K';
  }
  return value.toString();
}

String _relativeTimeLabel(DateTime timestamp, AppLocalizations l10n) {
  final diff = DateTime.now().difference(timestamp);
  if (diff.inMinutes < 1) {
    return l10n.pick('now', 'الآن');
  }
  if (diff.inHours < 1) {
    return l10n.pick('${diff.inMinutes}m', '${diff.inMinutes}د');
  }
  if (diff.inDays < 1) {
    return l10n.pick('${diff.inHours}h', '${diff.inHours}س');
  }
  return l10n.pick('${diff.inDays}d', '${diff.inDays}ي');
}

String _absoluteTimeLabel(DateTime timestamp) {
  final month = timestamp.month.toString().padLeft(2, '0');
  final day = timestamp.day.toString().padLeft(2, '0');
  final hour = timestamp.hour.toString().padLeft(2, '0');
  final minute = timestamp.minute.toString().padLeft(2, '0');
  return '${timestamp.year}-$month-$day $hour:$minute';
}

String _weekdayLabel(int index) {
  const labels = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return labels[index.clamp(0, labels.length - 1)];
}

class _DashboardMetric {
  const _DashboardMetric({required this.label, required this.value, required this.caption, required this.icon, required this.accentColor, required this.trend, this.page});

  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color accentColor;
  final List<double> trend;
  final IndexPage? page;
}

class _PulsePoint {
  const _PulsePoint(this.label, this.value);

  final String label;
  final double value;
}

class _MixSlice {
  const _MixSlice(this.label, this.value, this.color, this.page);

  final String label;
  final double value;
  final Color color;
  final IndexPage page;
}

class _ExecutionItem {
  const _ExecutionItem({required this.title, required this.subtitle, required this.icon, required this.accentColor, required this.completion, required this.chips, required this.page});

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final double completion;
  final List<_DashboardLinkChip> chips;
  final IndexPage page;
}

class _DashboardLinkChip {
  const _DashboardLinkChip({required this.label, required this.page});

  final String label;
  final IndexPage page;
}

class _SignalRow {
  const _SignalRow(this.label, this.value, this.color, [this.page]);

  final String label;
  final String value;
  final Color color;
  final IndexPage? page;
}

class _RecentActivityItem {
  _RecentActivityItem({required this.title, required this.subtitle, required this.timeLabel, required this.page, required this.icon, required this.color, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.fromMillisecondsSinceEpoch(0);

  final String title;
  final String subtitle;
  final String timeLabel;
  final IndexPage page;
  final IconData icon;
  final Color color;
  final DateTime timestamp;
}
