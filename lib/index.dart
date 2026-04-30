import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/views/components/language_switcher.dart';
import 'package:store_management/views/index/index_page.dart';
import 'package:store_management/views/index/index_page_registry.dart';

Widget _buildIndexDrawer(BuildContext context, LocaleController localeController, AppPreferencesController appPreferencesController, {required IndexPage selectedPage, required ValueChanged<IndexPage> onSelectPage}) {
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
                child: _DrawerSectionCard(section: section, selectedPage: selectedPage, onSelectPage: onSelectPage),
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
        _DrawerItem(page: IndexPage.dashboard, label: l10n.dashboard, icon: Icons.dashboard_rounded, countsAsModule: false),
        _DrawerItem(page: IndexPage.reports, label: l10n.reports, icon: Icons.bar_chart_rounded, countsAsModule: false),
        _DrawerItem(page: IndexPage.stores, label: l10n.stores, icon: Icons.store_mall_directory_rounded),
        _DrawerItem(page: IndexPage.branches, label: l10n.branches, icon: Icons.storefront_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.catalog,
      title: l10n.catalog,
      icon: Icons.inventory_2_rounded,
      items: [
        _DrawerItem(page: IndexPage.products, label: l10n.products, icon: Icons.inventory_2_rounded),
        _DrawerItem(page: IndexPage.categories, label: l10n.categories, icon: Icons.category_rounded),
        _DrawerItem(page: IndexPage.tags, label: l10n.tags, icon: Icons.sell_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.sales,
      title: l10n.sales,
      icon: Icons.point_of_sale_rounded,
      items: [
        _DrawerItem(page: IndexPage.invoices, label: l10n.invoices, icon: Icons.receipt_long_rounded),
        _DrawerItem(page: IndexPage.returns, label: l10n.returns, icon: Icons.assignment_return_rounded),
        _DrawerItem(page: IndexPage.paymentVouchers, label: l10n.paymentVouchers, icon: Icons.account_balance_wallet_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.people,
      title: l10n.people,
      icon: Icons.groups_rounded,
      items: [
        _DrawerItem(page: IndexPage.clients, label: l10n.clients, icon: Icons.support_agent_rounded),
        _DrawerItem(page: IndexPage.companies, label: l10n.companies, icon: Icons.apartment_rounded),
        _DrawerItem(page: IndexPage.users, label: l10n.users, icon: Icons.person_outline_rounded),
        _DrawerItem(page: IndexPage.roles, label: l10n.roles, icon: Icons.admin_panel_settings_rounded),
      ],
    ),
    _DrawerSection(
      key: _DrawerSectionKey.operations,
      title: l10n.operations,
      icon: Icons.settings_suggest_rounded,
      items: [
        _DrawerItem(page: IndexPage.inventory, label: l10n.inventory, icon: Icons.warehouse_rounded),
        _DrawerItem(page: IndexPage.transactions, label: l10n.transactions, icon: Icons.sync_alt_rounded),
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

class Index extends StatefulWidget {
  const Index({super.key, required this.localeController, required this.appPreferencesController});

  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  late IndexPage _selectedPage;

  @override
  void initState() {
    super.initState();
    _selectedPage = IndexPageStorage.fromStorageKey(widget.appPreferencesController.lastIndexPageKey);
  }

  void _handlePageSelected(IndexPage page) {
    if (_selectedPage == page) {
      Navigator.of(context).maybePop();
      return;
    }

    setState(() {
      _selectedPage = page;
    });
    widget.appPreferencesController.saveLastIndexPageKey(page.storageKey);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthController>().state;
    final pageDefinitions = buildIndexPageDefinitions(context, authState);
    final selectedDefinition = pageDefinitions[_selectedPage]!;

    return Scaffold(
      drawer: _buildIndexDrawer(context, widget.localeController, widget.appPreferencesController, selectedPage: _selectedPage, onSelectPage: _handlePageSelected),
      appBar: AppBar(title: Text(selectedDefinition.title), centerTitle: true, elevation: 0, backgroundColor: Colors.transparent),
      body: selectedDefinition.body,
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
  const _DrawerItem({required this.page, required this.label, required this.icon, this.countsAsModule = true});

  final IndexPage page;
  final String label;
  final IconData icon;
  final bool countsAsModule;
}

class _DrawerSectionCard extends StatelessWidget {
  const _DrawerSectionCard({required this.section, required this.selectedPage, required this.onSelectPage});

  final _DrawerSection section;
  final IndexPage selectedPage;
  final ValueChanged<IndexPage> onSelectPage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasActiveItem = section.items.any((item) => item.page == selectedPage);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: hasActiveItem,
          dense: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          leading: Icon(section.icon, size: 20),
          title: Text(section.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          children: section.items.map((item) {
            final isActive = item.page == selectedPage;

            return ListTile(
              dense: true,
              selected: isActive,
              selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.65),
              visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: Icon(item.icon, size: 19, color: isActive ? colorScheme.primary : null),
              title: Text(
                item.label,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, color: isActive ? colorScheme.primary : null),
              ),
              trailing: isActive ? Icon(Icons.arrow_outward_rounded, size: 18, color: colorScheme.primary) : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              onTap: () => onSelectPage(item.page),
            );
          }).toList(),
        ),
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
