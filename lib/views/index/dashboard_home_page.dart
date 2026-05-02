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
          final isWide = constraints.maxWidth >= 920;
          final spotlightWidth = isWide ? 270.0 : constraints.maxWidth - 40;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: LinearGradient(colors: [colorScheme.primaryContainer, colorScheme.tertiaryContainer], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.08), blurRadius: 28, offset: const Offset(0, 16))],
                      ),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: isWide ? 620 : constraints.maxWidth),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(color: colorScheme.surface.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(999)),
                                  child: Text(l10n.readyToManage, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(height: 16),
                                Text(l10n.welcomeTitle, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, height: 1.05)),
                                const SizedBox(height: 12),
                                Text(l10n.connectedWorkspace, style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.5)),
                                const SizedBox(height: 20),
                                Wrap(spacing: 12, runSpacing: 12, children: metrics.map((metric) => _DashboardMetricCard(metric: metric)).toList()),
                              ],
                            ),
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 320),
                            child: Builder(
                              builder: (context) => Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: colorScheme.surface.withValues(alpha: 0.78),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(color: colorScheme.outlineVariant),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundColor: colorScheme.primary,
                                          foregroundColor: colorScheme.onPrimary,
                                          child: Text(_initialsForUser(user?.name, authState.userEmail), style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(l10n.signedInAs, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                                              const SizedBox(height: 4),
                                              Text(
                                                user?.name.isNotEmpty == true ? user!.name : (authState.userEmail ?? l10n.signedInFallback),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (user != null) ...[
                                      const SizedBox(height: 16),
                                      Text(user.email, style: theme.textTheme.bodyMedium),
                                      const SizedBox(height: 6),
                                      Text('@${user.username}', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                                    ],
                                    const SizedBox(height: 18),
                                    FilledButton.icon(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu_open_rounded), label: Text(l10n.menu)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(l10n.quickActions, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: spotlights.map((spotlight) => _DashboardSpotlightCard(spotlight: spotlight, width: spotlightWidth)).toList(),
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
      constraints: const BoxConstraints(minWidth: 150),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(14)),
            child: Icon(metric.icon, color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(metric.value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(metric.label, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardSpotlightCard extends StatelessWidget {
  const _DashboardSpotlightCard({required this.spotlight, required this.width});

  final _DashboardSpotlight spotlight;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: spotlight.accentColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
            child: Icon(spotlight.icon, color: spotlight.accentColor),
          ),
          const SizedBox(height: 16),
          Text(spotlight.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(spotlight.description, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant, height: 1.45)),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: spotlight.items
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(color: colorScheme.surfaceContainerLow, borderRadius: BorderRadius.circular(999)),
                    child: Text(item, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
