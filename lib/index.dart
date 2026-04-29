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
    child: Column(
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
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: LanguageSwitcher(localeController: localeController),
        ),
        SwitchListTile.adaptive(
          secondary: Icon(appPreferencesController.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
          title: Text(l10n.darkMode),
          value: appPreferencesController.isDarkMode,
          onChanged: (_) {
            appPreferencesController.toggleThemeMode();
          },
        ),
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

    return Scaffold(
      drawer: _buildIndexDrawer(context, localeController, appPreferencesController),
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: true,
        actions: [IconButton(tooltip: l10n.theme, onPressed: appPreferencesController.toggleThemeMode, icon: Icon(appPreferencesController.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded))],
      ),
      body: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, 12))],
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
