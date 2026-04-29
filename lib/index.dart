import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/views/components/language_switcher.dart';

Widget _buildIndexDrawer(BuildContext context, LocaleController localeController, AppPreferencesController appPreferencesController) {
  final l10n = context.l10n;

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: Color(0xFF1F7A8C)),
          child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Text(l10n.menu, style: const TextStyle(color: Colors.white, fontSize: 24)),
          ),
        ),
        ListTile(leading: const Icon(Icons.dashboard_rounded), title: Text(l10n.dashboard)),
        ListTile(leading: const Icon(Icons.inventory_2_rounded), title: Text(l10n.products)),
        ListTile(leading: const Icon(Icons.people_rounded), title: Text(l10n.customers)),
        ListTile(leading: const Icon(Icons.bar_chart_rounded), title: Text(l10n.reports)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LanguageSwitcher(localeController: localeController),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(l10n.settings, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          ),
        ),
        _ThemeModeOptionTile(icon: Icons.brightness_auto_rounded, label: l10n.systemMode, value: ThemeMode.system, currentValue: appPreferencesController.themeMode, onSelected: appPreferencesController.setThemeMode),
        _ThemeModeOptionTile(icon: Icons.light_mode_rounded, label: l10n.lightMode, value: ThemeMode.light, currentValue: appPreferencesController.themeMode, onSelected: appPreferencesController.setThemeMode),
        _ThemeModeOptionTile(icon: Icons.dark_mode_rounded, label: l10n.darkMode, value: ThemeMode.dark, currentValue: appPreferencesController.themeMode, onSelected: appPreferencesController.setThemeMode),
        const SizedBox(height: 8),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.logout_rounded),
          title: Text(l10n.logout),
          onTap: () {
            Navigator.of(context).maybePop();
            context.read<AuthController>().add(const AuthSignedOut());
          },
        ),
      ],
    ),
  );
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

    return Scaffold(
      drawer: _buildIndexDrawer(context, localeController, appPreferencesController),
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [
          PopupMenuButton<ThemeMode>(
            tooltip: l10n.settings,
            onSelected: appPreferencesController.setThemeMode,
            icon: Icon(_themeIconFor(appPreferencesController.themeMode)),
            itemBuilder: (context) => [
              PopupMenuItem<ThemeMode>(value: ThemeMode.system, child: Text(l10n.systemMode)),
              PopupMenuItem<ThemeMode>(value: ThemeMode.light, child: Text(l10n.lightMode)),
              PopupMenuItem<ThemeMode>(value: ThemeMode.dark, child: Text(l10n.darkMode)),
            ],
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.24 : 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.storefront_rounded, size: 56),
              const SizedBox(height: 16),
              Text(
                l10n.welcomeTitle,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(user?.name.isNotEmpty == true ? user!.name : (authState.userEmail ?? l10n.signedInFallback), style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
              if (user != null) ...[
                const SizedBox(height: 12),
                Text(user.email, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text(
                  '@${user.username}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF5C6672)),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

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
      leading: Icon(icon),
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check_rounded, color: Theme.of(context).colorScheme.primary) : null,
      selected: isSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onTap: () => onSelected(value),
    );
  }
}
