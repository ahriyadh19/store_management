import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/views/components/language_switcher.dart';

Widget _buildIndexDrawer(BuildContext context, LocaleController localeController, AppPreferencesController appPreferencesController) {
  final l10n = context.l10n;
  final authState = context.watch<AuthController>().state;
  final user = authState.user;
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final drawerSections = _buildDrawerSections(l10n);

  return Drawer(
    width: 330,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [colorScheme.surface, colorScheme.surfaceContainerLow]),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.78)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    child: Text(
                      _initialsForUser(user?.name, authState.userEmail),
                      style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.menu,
                          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.name.isNotEmpty == true ? user!.name : (authState.userEmail ?? l10n.signedInFallback),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.92)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...drawerSections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _DrawerSectionCard(section: section),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.settings, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Text(l10n.language, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 8),
                  LanguageSwitcher(localeController: localeController),
                  const SizedBox(height: 12),
                  Text(l10n.theme, style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  _ThemeModeOptionTile(
                    icon: Icons.brightness_auto_rounded,
                    label: l10n.systemMode,
                    value: ThemeMode.system,
                    currentValue: appPreferencesController.themeMode,
                    onSelected: appPreferencesController.setThemeMode,
                  ),
                  _ThemeModeOptionTile(icon: Icons.light_mode_rounded, label: l10n.lightMode, value: ThemeMode.light, currentValue: appPreferencesController.themeMode, onSelected: appPreferencesController.setThemeMode),
                  _ThemeModeOptionTile(icon: Icons.dark_mode_rounded, label: l10n.darkMode, value: ThemeMode.dark, currentValue: appPreferencesController.themeMode, onSelected: appPreferencesController.setThemeMode),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              dense: true,
              visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              leading: const Icon(Icons.logout_rounded),
              title: Text(l10n.logout),
              onTap: () {
                Navigator.of(context).maybePop();
                context.read<AuthController>().add(const AuthSignedOut());
              },
            ),
          ],
        ),
      ),
    ),
  );
}

List<_DrawerSection> _buildDrawerSections(AppLocalizations l10n) {
  return [
    _DrawerSection(
      key: _DrawerSectionKey.overview,
      title: l10n.overview,
      icon: Icons.space_dashboard_rounded,
      items: [
        _DrawerItem(label: l10n.dashboard, icon: Icons.dashboard_rounded, isActive: true, countsAsModule: false),
        _DrawerItem(label: l10n.reports, icon: Icons.bar_chart_rounded, countsAsModule: false),
        _DrawerItem(label: l10n.stores, icon: Icons.store_mall_directory_rounded),
        _DrawerItem(label: l10n.branches, icon: Icons.storefront_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.catalog,
      title: l10n.catalog,
      icon: Icons.inventory_2_rounded,
      items: [
        _DrawerItem(label: l10n.products, icon: Icons.inventory_2_rounded),
        _DrawerItem(label: l10n.categories, icon: Icons.category_rounded),
        _DrawerItem(label: l10n.tags, icon: Icons.sell_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.sales,
      title: l10n.sales,
      icon: Icons.point_of_sale_rounded,
      items: [
        _DrawerItem(label: l10n.invoices, icon: Icons.receipt_long_rounded),
        _DrawerItem(label: l10n.returns, icon: Icons.assignment_return_rounded),
        _DrawerItem(label: l10n.paymentVouchers, icon: Icons.account_balance_wallet_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.people,
      title: l10n.people,
      icon: Icons.groups_rounded,
      items: [
        _DrawerItem(label: l10n.clients, icon: Icons.support_agent_rounded),
        _DrawerItem(label: l10n.companies, icon: Icons.apartment_rounded),
        _DrawerItem(label: l10n.users, icon: Icons.person_outline_rounded),
        _DrawerItem(label: l10n.roles, icon: Icons.admin_panel_settings_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.operations,
      title: l10n.operations,
      icon: Icons.settings_suggest_rounded,
      items: [
        _DrawerItem(label: l10n.inventory, icon: Icons.warehouse_rounded),
        _DrawerItem(label: l10n.transactions, icon: Icons.sync_alt_rounded),
      ],
    ),
  ];
}

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
  final drawerSections = _buildDrawerSections(l10n);
  final activeModuleCount = drawerSections.fold<int>(0, (count, section) => count + section.items.where((item) => item.countsAsModule).length);

  int sectionCount(_DrawerSectionKey key) {
    final section = drawerSections.firstWhere((candidate) => candidate.key == key);
    return section.items.where((item) => item.countsAsModule).length;
  }

  return [
    _DashboardMetric(label: l10n.activeModules, value: '$activeModuleCount', icon: Icons.apps_rounded),
    _DashboardMetric(label: l10n.catalog, value: '${sectionCount(_DrawerSectionKey.catalog)}', icon: Icons.inventory_2_rounded),
    _DashboardMetric(label: l10n.sales, value: '${sectionCount(_DrawerSectionKey.sales)}', icon: Icons.point_of_sale_rounded),
    _DashboardMetric(label: l10n.people, value: '${sectionCount(_DrawerSectionKey.people)}', icon: Icons.groups_rounded),
  ];
}

List<_DashboardSpotlight> _buildDashboardSpotlights(AppLocalizations l10n) {
  return [
    _DashboardSpotlight(title: l10n.catalog, description: l10n.catalogSummary, icon: Icons.inventory_2_rounded, accentColor: const Color(0xFF157A6E), items: [l10n.products, l10n.categories, l10n.tags]),
    _DashboardSpotlight(title: l10n.sales, description: l10n.salesSummary, icon: Icons.point_of_sale_rounded, accentColor: const Color(0xFFC8553D), items: [l10n.invoices, l10n.returns, l10n.paymentVouchers]),
    _DashboardSpotlight(title: l10n.people, description: l10n.peopleSummary, icon: Icons.groups_rounded, accentColor: const Color(0xFF4E5D94), items: [l10n.clients, l10n.companies, l10n.users, l10n.roles]),
    _DashboardSpotlight(
      title: l10n.operations,
      description: l10n.operationsSummary,
      icon: Icons.settings_suggest_rounded,
      accentColor: const Color(0xFF8A5A44),
      items: [l10n.inventory, l10n.transactions, l10n.stores, l10n.branches],
    ),
  ];
}

class Index extends StatelessWidget {
  const Index({super.key, required this.localeController, required this.appPreferencesController});

  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final authState = context.watch<AuthController>().state;
    final user = authState.user;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final metrics = _buildDashboardMetrics(l10n);
    final spotlights = _buildDashboardSpotlights(l10n);

    return Scaffold(
      drawer: _buildIndexDrawer(context, localeController, appPreferencesController),
      appBar: AppBar(title: Text(l10n.appTitle), centerTitle: true, elevation: 0, backgroundColor: Colors.transparent),
      body: DecoratedBox(
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
      ),
    );
  }
}

/*

IconData _themeIconFor(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return Icons.brightness_auto_rounded;
    case ThemeMode.light:
      return Icons.light_mode_rounded;
    case ThemeMode.dark:
      return Icons.dark_mode_rounded;
  }
}
*/
enum _DrawerSectionKey { overview, catalog, sales, people, operations }

class _DrawerSection {
  const _DrawerSection({required this.key, required this.title, required this.icon, required this.items});

  final _DrawerSectionKey key;
  final String title;
  final IconData icon;
  final List<_DrawerItem> items;
}

class _DrawerItem {
  const _DrawerItem({required this.label, required this.icon, this.isActive = false, this.countsAsModule = true});

  final String label;
  final IconData icon;
  final bool isActive;
  final bool countsAsModule;
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

class _DrawerSectionCard extends StatelessWidget {
  const _DrawerSectionCard({required this.section});

  final _DrawerSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          dense: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          leading: Icon(section.icon, size: 20),
          title: Text(section.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          children: section.items
              .map(
                (item) => ListTile(
                  dense: true,
                  selected: item.isActive,
                  visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  leading: Icon(item.icon, size: 19),
                  title: Text(item.label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: item.isActive ? FontWeight.w700 : FontWeight.w500)),
                  trailing: item.isActive ? Icon(Icons.arrow_outward_rounded, size: 18, color: colorScheme.primary) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
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

class _ThemeModeOptionTile extends StatelessWidget {
  const _ThemeModeOptionTile({required this.icon, required this.label, required this.value, required this.currentValue, required this.onSelected});

  final IconData icon;
  final String label;
  final ThemeMode value;
  final ThemeMode currentValue;
  final ValueChanged<ThemeMode> onSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == currentValue;

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: -1, vertical: -2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(icon, size: 20),
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary) : null,
      selected: isSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onTap: () => onSelected(value),
    );
  }
}
