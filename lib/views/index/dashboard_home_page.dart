import 'package:flutter/material.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/users.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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

List<_DashboardMetric> _buildDashboardMetrics(AppLocalizations l10n) {
  return [
    _DashboardMetric(
      label: l10n.activeModules,
      value: '14',
      caption: l10n.pick('6 modules expanded this week', 'تم توسيع 6 وحدات هذا الأسبوع'),
      icon: Icons.apps_rounded,
      accentColor: const Color(0xFF127E78),
      trend: const <double>[12, 13, 12.5, 13.2, 13.6, 14, 14.4],
    ),
    _DashboardMetric(
      label: l10n.sales,
      value: '92%',
      caption: l10n.pick('Invoice flow healthy', 'تدفق الفواتير بحالة صحية'),
      icon: Icons.insights_rounded,
      accentColor: const Color(0xFFE1743B),
      trend: const <double>[54, 58, 63, 61, 68, 76, 92],
    ),
    _DashboardMetric(
      label: l10n.people,
      value: '18',
      caption: l10n.pick('Operators ready today', 'المشغلون الجاهزون اليوم'),
      icon: Icons.groups_rounded,
      accentColor: const Color(0xFF5567D8),
      trend: const <double>[9, 11, 10, 13, 14, 16, 18],
    ),
    _DashboardMetric(
      label: l10n.sync,
      value: '99.2%',
      caption: l10n.pick('Queued changes under control', 'التغييرات المجدولة تحت السيطرة'),
      icon: Icons.sync_rounded,
      accentColor: const Color(0xFF7A4DD8),
      trend: const <double>[96.5, 97.1, 97.4, 98.1, 98.7, 99.0, 99.2],
    ),
  ];
}

List<_PulsePoint> _buildPulseSeries() {
  return const <_PulsePoint>[_PulsePoint('Mon', 34), _PulsePoint('Tue', 41), _PulsePoint('Wed', 39), _PulsePoint('Thu', 57), _PulsePoint('Fri', 52), _PulsePoint('Sat', 68), _PulsePoint('Sun', 64)];
}

List<_MixSlice> _buildModuleMix(AppLocalizations l10n) {
  return <_MixSlice>[
    _MixSlice(l10n.catalog, 32, const Color(0xFF127E78)),
    _MixSlice(l10n.sales, 24, const Color(0xFFE1743B)),
    _MixSlice(l10n.people, 18, const Color(0xFF5567D8)),
    _MixSlice(l10n.operations, 26, const Color(0xFF8B5CF6)),
  ];
}

List<_ExecutionItem> _buildExecutionItems(AppLocalizations l10n) {
  return <_ExecutionItem>[
    _ExecutionItem(title: l10n.catalog, subtitle: l10n.catalogSummary, icon: Icons.inventory_2_rounded, accentColor: const Color(0xFF127E78), completion: 0.84, chips: <String>[l10n.products, l10n.categories, l10n.tags]),
    _ExecutionItem(
      title: l10n.sales,
      subtitle: l10n.salesSummary,
      icon: Icons.point_of_sale_rounded,
      accentColor: const Color(0xFFE1743B),
      completion: 0.72,
      chips: <String>[l10n.invoices, l10n.returns, l10n.paymentVouchers],
    ),
    _ExecutionItem(
      title: l10n.people,
      subtitle: l10n.peopleSummary,
      icon: Icons.groups_rounded,
      accentColor: const Color(0xFF5567D8),
      completion: 0.67,
      chips: <String>[l10n.clients, l10n.suppliers, l10n.users, l10n.roles],
    ),
    _ExecutionItem(
      title: l10n.operations,
      subtitle: l10n.operationsSummary,
      icon: Icons.settings_suggest_rounded,
      accentColor: const Color(0xFF8B5CF6),
      completion: 0.91,
      chips: <String>[l10n.inventory, l10n.transactions, l10n.stores, l10n.branches],
    ),
  ];
}

List<_SignalRow> _buildSignalRows(AppLocalizations l10n) {
  return <_SignalRow>[
    _SignalRow(l10n.pick('Sync relay', 'مرحّل المزامنة'), l10n.pick('Live', 'مباشر'), const Color(0xFF127E78)),
    _SignalRow(l10n.pick('Invoice rhythm', 'إيقاع الفواتير'), l10n.pick('Rising', 'صاعد'), const Color(0xFFE1743B)),
    _SignalRow(l10n.pick('Role coverage', 'تغطية الأدوار'), l10n.pick('Stable', 'مستقر'), const Color(0xFF5567D8)),
  ];
}

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key, required this.authState});

  final AuthState authState;

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final metrics = _buildDashboardMetrics(l10n);
    final pulseSeries = _buildPulseSeries();
    final moduleMix = _buildModuleMix(l10n);
    final executionItems = _buildExecutionItems(l10n);
    final signalRows = _buildSignalRows(l10n);

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
                      child: _DashboardHeroCard(authState: widget.authState, signals: signalRows),
                    ),
                    const SizedBox(height: 18),
                    _DashboardReveal(
                      controller: _controller,
                      interval: const Interval(0.12, 0.46, curve: Curves.easeOutCubic),
                      child: _MetricRail(metrics: metrics),
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
                                child: _PulsePanel(series: pulseSeries),
                              ),
                              const SizedBox(height: 18),
                              _DashboardReveal(
                                controller: _controller,
                                interval: const Interval(0.34, 0.7, curve: Curves.easeOutCubic),
                                child: _ModuleMixPanel(slices: moduleMix),
                              ),
                              const SizedBox(height: 18),
                              _DashboardReveal(
                                controller: _controller,
                                interval: const Interval(0.44, 0.86, curve: Curves.easeOutCubic),
                                child: _ExecutionBoard(items: executionItems),
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
                                    child: _PulsePanel(series: pulseSeries),
                                  ),
                                  const SizedBox(height: 18),
                                  _DashboardReveal(
                                    controller: _controller,
                                    interval: const Interval(0.44, 0.88, curve: Curves.easeOutCubic),
                                    child: _ExecutionBoard(items: executionItems),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              flex: 4,
                              child: _DashboardReveal(
                                controller: _controller,
                                interval: const Interval(0.34, 0.7, curve: Curves.easeOutCubic),
                                child: _ModuleMixPanel(slices: moduleMix),
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
}

class _DashboardHeroCard extends StatelessWidget {
  const _DashboardHeroCard({required this.authState, required this.signals});

  final AuthState authState;
  final List<_SignalRow> signals;

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
                      'A cinematic operations cockpit with live module rhythm, execution focus, and sharper visual telemetry across the workspace.',
                      'لوحة عمليات سينمائية بإيقاع وحدات مباشر وتركيز تنفيذي وقياسات بصرية أوضح عبر مساحة العمل.',
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.84), height: 1.45),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _HeroBadge(label: l10n.connectedWorkspace, icon: Icons.hub_rounded),
                      _HeroBadge(label: l10n.quickActions, icon: Icons.bolt_rounded),
                      _HeroBadge(label: l10n.sync, icon: Icons.auto_awesome_motion_rounded),
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
                        child: _SignalTile(signal: signal),
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
  const _MetricRail({required this.metrics});

  final List<_DashboardMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: metrics.map((metric) => SizedBox(width: 308, child: _MetricCard(metric: metric))).toList(growable: false),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _DashboardMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
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
  }
}

class _PulsePanel extends StatelessWidget {
  const _PulsePanel({required this.series});

  final List<_PulsePoint> series;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final tooltipBehavior = TooltipBehavior(enable: true, header: '', canShowMarker: true);

    return _DashboardPanel(
      title: l10n.pick('Workspace Pulse', 'نبض مساحة العمل'),
      subtitle: l10n.pick('Weekly system rhythm across sales, people, and sync responsiveness.', 'إيقاع النظام الأسبوعي عبر المبيعات والأشخاص واستجابة المزامنة.'),
      actionLabel: l10n.pick('Live telemetry', 'قياسات مباشرة'),
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
            maximum: 80,
            interval: 20,
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
  const _ModuleMixPanel({required this.slices});

  final List<_MixSlice> slices;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return _DashboardPanel(
      title: l10n.pick('Module Balance', 'توازن الوحدات'),
      subtitle: l10n.pick('Operational focus split across the current control surface.', 'توزيع التركيز التشغيلي عبر سطح التحكم الحالي.'),
      actionLabel: l10n.pick('Adaptive mix', 'مزيج متكيف'),
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
                      Text('14', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExecutionBoard extends StatelessWidget {
  const _ExecutionBoard({required this.items});

  final List<_ExecutionItem> items;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _DashboardPanel(
      title: l10n.pick('Execution Board', 'لوحة التنفيذ'),
      subtitle: l10n.pick('Modernized module cards with intent, state, and next-action density.', 'بطاقات وحدات مطورة تحمل النية والحالة وكثافة الإجراء التالي.'),
      actionLabel: l10n.quickActions,
      child: Wrap(
        spacing: 14,
        runSpacing: 14,
        children: items.map((item) => SizedBox(width: 310, child: _ExecutionCard(item: item))).toList(growable: false),
      ),
    );
  }
}

class _ExecutionCard extends StatelessWidget {
  const _ExecutionCard({required this.item});

  final _ExecutionItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completionLabel = '${(item.completion * 100).round()}%';

    return AnimatedContainer(
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
            children: item.chips.map((chip) => _ModuleChip(label: chip, color: item.accentColor)).toList(growable: false),
          ),
        ],
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
  const _HeroBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
  }
}

class _SignalTile extends StatelessWidget {
  const _SignalTile({required this.signal});

  final _SignalRow signal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
  }
}

class _ModuleChip extends StatelessWidget {
  const _ModuleChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
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

class _DashboardMetric {
  const _DashboardMetric({required this.label, required this.value, required this.caption, required this.icon, required this.accentColor, required this.trend});

  final String label;
  final String value;
  final String caption;
  final IconData icon;
  final Color accentColor;
  final List<double> trend;
}

class _PulsePoint {
  const _PulsePoint(this.label, this.value);

  final String label;
  final double value;
}

class _MixSlice {
  const _MixSlice(this.label, this.value, this.color);

  final String label;
  final double value;
  final Color color;
}

class _ExecutionItem {
  const _ExecutionItem({required this.title, required this.subtitle, required this.icon, required this.accentColor, required this.completion, required this.chips});

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final double completion;
  final List<String> chips;
}

class _SignalRow {
  const _SignalRow(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;
}
