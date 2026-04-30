import 'package:flutter/material.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/views/components/language_switcher.dart';

class AuthFormPanel extends StatelessWidget {
  const AuthFormPanel({
    super.key,
    required this.l10n,
    required this.localeController,
    required this.appPreferencesController,
    required this.isSignIn,
    required this.isSignUp,
    required this.isLoading,
    required this.emailController,
    required this.nameController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.onForgotPassword,
    required this.onSwitchScreen,
    required this.onSubmit,
    required this.currentScreen,
  });

  final AppLocalizations l10n;
  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;
  final bool isSignIn;
  final bool isSignUp;
  final bool isLoading;
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final VoidCallback onForgotPassword;
  final ValueChanged<AuthScreen> onSwitchScreen;
  final VoidCallback onSubmit;
  final AuthScreen currentScreen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final isCompactHeight = viewportHeight < 760;
    final cardPadding = isCompactHeight ? 20.0 : 28.0;
    final sectionGap = isCompactHeight ? 18.0 : 24.0;
    final fieldGap = isCompactHeight ? 12.0 : 16.0;
    final headerGap = isCompactHeight ? 22.0 : 28.0;
    final headerIconSize = isCompactHeight ? 46.0 : 52.0;
    final recentEmails = appPreferencesController.recentEmails;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: isDarkMode ? 0.92 : 0.9),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: isDarkMode ? 0.45 : 0.25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDarkMode ? 0.28 : 0.09),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ThemeModeMenuButton(appPreferencesController: appPreferencesController),
                    const SizedBox(width: 8),
                    LanguageSwitcher(localeController: localeController),
                  ],
                ),
              ),
              SizedBox(height: isCompactHeight ? 14 : 16),
              _AuthBrandHeader(
                appTitle: l10n.appTitle,
                subtitle: isSignIn ? l10n.signInFooter : l10n.signUpFooter,
                iconSize: headerIconSize,
                isCompactHeight: isCompactHeight,
              ),
              SizedBox(height: headerGap),
              Text(
                isSignIn ? l10n.signIn : l10n.createAccount,
                style: (isCompactHeight ? theme.textTheme.headlineSmall : theme.textTheme.headlineMedium)?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(
                isSignIn ? l10n.signInSubtitle : l10n.signUpSubtitle,
                style: theme.textTheme.bodyLarge?.copyWith(color: const Color(0xFF5C6672)),
              ),
              SizedBox(height: sectionGap),
              SegmentedButton<AuthScreen>(
                style: ButtonStyle(padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: isCompactHeight ? 10 : 12))),
                segments: [
                  ButtonSegment(value: AuthScreen.signIn, label: Text(l10n.signIn)),
                  ButtonSegment(value: AuthScreen.signUp, label: Text(l10n.signUp)),
                ],
                selected: {currentScreen},
                onSelectionChanged: (selection) => onSwitchScreen(selection.first),
              ),
              SizedBox(height: sectionGap),
              if (isSignUp) ...[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.name, hintText: l10n.nameHint, border: const OutlineInputBorder()),
                ),
                SizedBox(height: fieldGap),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: l10n.username, hintText: l10n.usernameHint, border: const OutlineInputBorder()),
                ),
                SizedBox(height: fieldGap),
              ],
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: l10n.email, hintText: l10n.emailHint, border: const OutlineInputBorder()),
              ),
              if (!isSignUp && recentEmails.isNotEmpty) ...[
                SizedBox(height: fieldGap),
                AuthRecentEmailSuggestions(
                  title: l10n.recentEmails,
                  currentEmail: emailController.text,
                  emails: recentEmails,
                  onSelected: (email) {
                    emailController.text = email;
                  },
                ),
              ],
              SizedBox(height: fieldGap),
              _AuthPasswordField(
                controller: passwordController,
                obscureText: obscurePassword,
                labelText: l10n.password,
                hintText: l10n.passwordHint,
                onToggleVisibility: onTogglePasswordVisibility,
              ),
              if (isSignUp) ...[
                SizedBox(height: fieldGap),
                _AuthPasswordField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  labelText: l10n.confirmPassword,
                  hintText: l10n.confirmPasswordHint,
                  onToggleVisibility: onToggleConfirmPasswordVisibility,
                ),
              ],
              SizedBox(height: sectionGap),
              FilledButton(
                onPressed: isLoading ? null : onSubmit,
                style: FilledButton.styleFrom(minimumSize: Size.fromHeight(isCompactHeight ? 52 : 56)),
                child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.4)) : Text(isSignIn ? l10n.continueLabel : l10n.createAccount),
              ),
              if (isSignIn) ...[
                SizedBox(height: isCompactHeight ? 8 : 12),
                Align(
                  alignment: AlignmentDirectional.center,
                  child: TextButton(onPressed: onForgotPassword, child: Text(l10n.forgotPasswordAction)),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        const _PlatformAvailabilitySection(),
      ],
    );
  }
}

class _AuthBrandHeader extends StatelessWidget {
  const _AuthBrandHeader({
    required this.appTitle,
    required this.subtitle,
    required this.iconSize,
    required this.isCompactHeight,
  });

  final String appTitle;
  final String subtitle;
  final double iconSize;
  final bool isCompactHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: iconSize,
          width: iconSize,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1F7A8C), Color(0xFF39A6BC)]),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appTitle, style: (isCompactHeight ? theme.textTheme.titleMedium : theme.textTheme.titleLarge)?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280))),
            ],
          ),
        ),
      ],
    );
  }
}

class _AuthPasswordField extends StatelessWidget {
  const _AuthPasswordField({
    required this.controller,
    required this.obscureText,
    required this.labelText,
    required this.hintText,
    required this.onToggleVisibility,
  });

  final TextEditingController controller;
  final bool obscureText;
  final String labelText;
  final String hintText;
  final VoidCallback onToggleVisibility;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: onToggleVisibility,
          icon: Icon(obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded),
        ),
      ),
    );
  }
}

class _PlatformAvailabilitySection extends StatelessWidget {
  const _PlatformAvailabilitySection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isCompactHeight = MediaQuery.sizeOf(context).height < 760;
    const platformIcons = ['lib/assets/icons/android.png', 'lib/assets/icons/apple.png', 'lib/assets/icons/linux.png', 'lib/assets/icons/windows.png'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isCompactHeight ? 14 : 18, vertical: isCompactHeight ? 12 : 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.88 : 0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.availablePlatformsTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF5C6672), letterSpacing: 0.2),
          ),
          SizedBox(height: isCompactHeight ? 10 : 12),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: isCompactHeight ? 10 : 12,
              runSpacing: isCompactHeight ? 10 : 12,
              children: [for (final assetPath in platformIcons) _PlatformPill(assetPath: assetPath)],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformPill extends StatelessWidget {
  const _PlatformPill({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final isCompactHeight = MediaQuery.sizeOf(context).height < 760;
    return Container(
      height: isCompactHeight ? 46 : 52,
      width: isCompactHeight ? 46 : 52,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.07),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Image.asset(assetPath, fit: BoxFit.contain),
    );
  }
}

class AuthRecentEmailSuggestions extends StatelessWidget {
  const AuthRecentEmailSuggestions({super.key, required this.title, required this.currentEmail, required this.emails, required this.onSelected});

  final String title;
  final String currentEmail;
  final List<String> emails;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final email in emails)
              ActionChip(
                label: Text(email),
                avatar: Icon(email == currentEmail ? Icons.check_circle_rounded : Icons.email_outlined, size: 18),
                onPressed: () => onSelected(email),
              ),
          ],
        ),
      ],
    );
  }
}

class _ThemeModeMenuButton extends StatelessWidget {
  const _ThemeModeMenuButton({required this.appPreferencesController});

  final AppPreferencesController appPreferencesController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String labelFor(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.light:
          return l10n.lightMode;
        case ThemeMode.dark:
          return l10n.darkMode;
        case ThemeMode.system:
          return l10n.systemMode;
      }
    }

    IconData iconFor(ThemeMode mode) {
      switch (mode) {
        case ThemeMode.light:
          return Icons.light_mode_rounded;
        case ThemeMode.dark:
          return Icons.dark_mode_rounded;
        case ThemeMode.system:
          return Icons.brightness_auto_rounded;
      }
    }

    return PopupMenuButton<ThemeMode>(
      tooltip: l10n.settings,
      onSelected: appPreferencesController.setThemeMode,
      itemBuilder: (context) => [
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.system,
          child: ListTile(leading: Icon(iconFor(ThemeMode.system)), title: Text(labelFor(ThemeMode.system)), contentPadding: EdgeInsets.zero),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.light,
          child: ListTile(leading: Icon(iconFor(ThemeMode.light)), title: Text(labelFor(ThemeMode.light)), contentPadding: EdgeInsets.zero),
        ),
        PopupMenuItem<ThemeMode>(
          value: ThemeMode.dark,
          child: ListTile(leading: Icon(iconFor(ThemeMode.dark)), title: Text(labelFor(ThemeMode.dark)), contentPadding: EdgeInsets.zero),
        ),
      ],
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Icon(iconFor(appPreferencesController.themeMode))),
    );
  }
}