import 'package:flutter/material.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';

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
    _DashboardMetric(label: l10n.activeModules, value: '14', icon: Icons.apps_rounded),
    _DashboardMetric(label: l10n.catalog, value: '3', icon: Icons.inventory_2_rounded),
    _DashboardMetric(label: l10n.sales, value: '3', icon: Icons.point_of_sale_rounded),
    _DashboardMetric(label: l10n.people, value: '4', icon: Icons.groups_rounded),
  ];
}

List<_DashboardSpotlight> _buildDashboardSpotlights(AppLocalizations l10n) {
  return [
    _DashboardSpotlight(title: l10n.catalog, description: l10n.catalogSummary, icon: Icons.inventory_2_rounded, accentColor: const Color(0xFF157A6E), items: [l10n.products, l10n.categories, l10n.tags]),
    _DashboardSpotlight(title: l10n.sales, description: l10n.salesSummary, icon: Icons.point_of_sale_rounded, accentColor: const Color(0xFFC8553D), items: [l10n.invoices, l10n.returns, l10n.paymentVouchers]),
    _DashboardSpotlight(title: l10n.people, description: l10n.peopleSummary, icon: Icons.groups_rounded, accentColor: const Color(0xFF4E5D94), items: [l10n.clients, l10n.suppliers, l10n.users, l10n.roles]),
    _DashboardSpotlight(
      title: l10n.operations,
      description: l10n.operationsSummary,
      icon: Icons.settings_suggest_rounded,
      accentColor: const Color(0xFF8A5A44),
      items: [l10n.inventory, l10n.transactions, l10n.stores, l10n.branches],
    ),
  ];
}

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key, required this.authState});

  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final user = authState.user;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final metrics = _buildDashboardMetrics(l10n);
    final spotlights = _buildDashboardSpotlights(l10n);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [colorScheme.surface, colorScheme.surfaceContainerLow]),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AnimatedDashboardSection(
                      delay: 0,
                      child: _DashboardHeroSection(user: user, authState: authState, metrics: metrics),
                    ),
                    const SizedBox(height: 20),
                    Text(l10n.quickActions, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 12),
                    _AnimatedDashboardSection(
                      delay: 110,
                      child: _DashboardGrid(
                        minChildWidth: 220, spacing: 12, children: spotlights.map((spotlight) => _DashboardSpotlightCard(spotlight: spotlight)).toList()),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardHeroSection extends StatelessWidget {
  const _DashboardHeroSection({required this.user, required this.authState, required this.metrics});

  final dynamic user;
  final AuthState authState;
  final List<_DashboardMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final leadPanel = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: colorScheme.surface.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(999)),
          child: Text(l10n.readyToManage, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: 12),
        Text(l10n.welcomeTitle, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, height: 1.05)),
        const SizedBox(height: 10),
        Text(l10n.connectedWorkspace, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.45)),
        const SizedBox(height: 16),
        _DashboardGrid(minChildWidth: 140, spacing: 10, children: metrics.map((metric) => _DashboardMetricCard(metric: metric)).toList()),
      ],
    );

    final profilePanel = Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.82),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  child: Text(_initialsForUser(user?.name, authState.userEmail), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.signedInAs, style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 3),
                      Text(
                        user?.name.isNotEmpty == true ? user!.name : (authState.userEmail ?? l10n.signedInFallback),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (user != null) ...[
              const SizedBox(height: 14),
              Text(user.email, style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Text('@${user.username}', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
            ],
            const SizedBox(height: 14),
            FilledButton.icon(
              style: FilledButton.styleFrom(visualDensity: VisualDensity.compact),
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: const Icon(Icons.menu_open_rounded, size: 18),
              label: Text(l10n.menu),
            ),
          ],
        ),
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(colors: [colorScheme.primaryContainer, colorScheme.tertiaryContainer], begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 14))],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 840;
          if (!isWide) {
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [leadPanel, const SizedBox(height: 16), profilePanel]);
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: leadPanel),
              const SizedBox(width: 16),
              Expanded(flex: 3, child: profilePanel),
            ],
          );
        },
      ),
    );
  }
}

class _DashboardGrid extends StatelessWidget {
  const _DashboardGrid({required this.children, this.minChildWidth = 220, this.spacing = 12});

  final List<Widget> children;
  final double minChildWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width <= minChildWidth ? 1 : ((width + spacing) / (minChildWidth + spacing)).floor().clamp(1, children.length);
        final rows = <Widget>[];

        for (var index = 0; index < children.length; index += columns) {
          final rowChildren = children.skip(index).take(columns).toList();
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var itemIndex = 0; itemIndex < rowChildren.length; itemIndex++) ...[Expanded(child: rowChildren[itemIndex]), if (itemIndex < rowChildren.length - 1) SizedBox(width: spacing)],
                  for (var filler = rowChildren.length; filler < columns; filler++) ...[const Expanded(child: SizedBox.shrink()), if (filler < columns - 1) SizedBox(width: spacing)],
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) ...[rows[rowIndex], if (rowIndex < rows.length - 1) SizedBox(height: spacing)],
          ],
        );
      },
    );
  }
}

class _AnimatedDashboardSection extends StatelessWidget {
  const _AnimatedDashboardSection({required this.child, required this.delay});

  final Widget child;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + delay),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, (1 - value) * 16), child: child,
          ),
        );
      },
    );
  }
}

class _DashboardMetric {
  const _DashboardMetric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;
}

class _DashboardSpotlight {
  const _DashboardSpotlight({required this.title, required this.description, required this.icon, required this.accentColor, required this.items});

  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final List<String> items;
}

class _DashboardMetricCard extends StatelessWidget {
  const _DashboardMetricCard({required this.metric});

  final _DashboardMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(minWidth: 132),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
            child: Icon(metric.icon, color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSpotlightCard extends StatelessWidget {
  const _DashboardSpotlightCard({required this.spotlight});

  final _DashboardSpotlight spotlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: spotlight.accentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(spotlight.icon, color: spotlight.accentColor),
          ),
          const SizedBox(height: 12),
          Text(spotlight.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(spotlight.description, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.4)),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: spotlight.items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(999)),
                    child: Text(item, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
