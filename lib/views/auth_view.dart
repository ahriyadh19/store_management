import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/views/components/language_switcher.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key, required this.localeController, required this.appPreferencesController});

  final LocaleController localeController;
  final AppPreferencesController appPreferencesController;

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmationLinkController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final initialEmail = widget.appPreferencesController.lastEmail;
    if (initialEmail.isNotEmpty) {
      _emailController.text = initialEmail;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _confirmationLinkController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocListener<AuthController, AuthState>(
      listenWhen: (previous, current) => previous.messageKey != current.messageKey || previous.userEmail != current.userEmail,
      listener: (context, state) {
        if (state.userEmail != null && state.userEmail!.isNotEmpty) {
          _emailController.text = state.userEmail!;
        }

        final messageKey = state.messageKey;
        if (messageKey == null) {
          return;
        }

        final message = l10n.message(messageKey, email: state.userEmail ?? _emailController.text);

        final color = state.status == AuthStatus.failure ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
      },
      child: Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode ? const [Color(0xFF07131A), Color(0xFF0C1C24), Color(0xFF14151F)] : const [Color(0xFFF6FBFF), Color(0xFFE9F3F5), Color(0xFFF9F4EC)],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                const Positioned(top: -72, left: -48, child: _BackdropOrb(size: 180, color: Color(0x331F7A8C))),
                const Positioned(top: 120, right: -54, child: _BackdropOrb(size: 164, color: Color(0x33E08D3C))),
                const Positioned(bottom: -70, left: 40, child: _BackdropOrb(size: 150, color: Color(0x262D5BFF))),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: BlocBuilder<AuthController, AuthState>(
                        builder: (context, state) {
                          final isSignIn = state.screen == AuthScreen.signIn;
                          final isSignUp = state.screen == AuthScreen.signUp;

                          if (state.screen == AuthScreen.confirmEmail) {
                            return _AuthStatusCard(
                              icon: Icons.mark_email_read_rounded,
                              title: l10n.confirmYourEmail,
                              description: l10n.confirmEmailDescription(state.userEmail ?? _emailController.text),
                              input: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(l10n.confirmEmailPasteHint, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF5C6672))),
                                  const SizedBox(height: 16),
                                  TextField(
                                    controller: _confirmationLinkController,
                                    minLines: 2,
                                    maxLines: 4,
                                    decoration: InputDecoration(labelText: l10n.confirmationLink, hintText: l10n.confirmationLinkHint, border: const OutlineInputBorder()),
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: TextButton(
                                      onPressed: state.isLoading
                                          ? null
                                          : () {
                                              context.read<AuthController>().add(AuthConfirmationResent(email: state.userEmail ?? _emailController.text));
                                            },
                                      child: Text(l10n.resendEmail),
                                    ),
                                  ),
                                ],
                              ),
                              primaryLabel: l10n.completeConfirmation,
                              primaryPressed: state.isLoading
                                  ? null
                                  : () {
                                      context.read<AuthController>().add(AuthConfirmationLinkSubmitted(email: state.userEmail ?? _emailController.text, confirmationLink: _confirmationLinkController.text));
                                    },
                              secondaryLabel: l10n.backToSignIn,
                              secondaryPressed: () {
                                context.read<AuthController>().add(const AuthScreenChanged(AuthScreen.signIn));
                              },
                              isLoading: state.isLoading,
                            );
                          }

                          if (state.screen == AuthScreen.forgotPassword || state.screen == AuthScreen.resetPassword) {
                            final isResetSent = state.screen == AuthScreen.resetPassword;
                            final recentEmails = widget.appPreferencesController.recentEmails;

                            return _AuthStatusCard(
                              icon: isResetSent ? Icons.password_rounded : Icons.lock_reset_rounded,
                              title: isResetSent ? l10n.resetPassword : l10n.forgotPasswordTitle,
                              description: isResetSent ? l10n.resetPasswordSentDescription(state.userEmail ?? _emailController.text) : l10n.forgotPasswordDescription,
                              input: isResetSent
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(l10n.resetPasswordPasteHint, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF5C6672))),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _confirmationLinkController,
                                          minLines: 2,
                                          maxLines: 4,
                                          decoration: InputDecoration(labelText: l10n.resetLink, hintText: l10n.resetLinkHint, border: const OutlineInputBorder()),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _passwordController,
                                          obscureText: _obscurePassword,
                                          decoration: InputDecoration(
                                            labelText: l10n.password,
                                            hintText: l10n.passwordHint,
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(onPressed: _togglePasswordVisibility, icon: Icon(_obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded)),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _confirmPasswordController,
                                          obscureText: _obscureConfirmPassword,
                                          decoration: InputDecoration(
                                            labelText: l10n.confirmPassword,
                                            hintText: l10n.confirmPasswordHint,
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(onPressed: _toggleConfirmPasswordVisibility, icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded)),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Align(
                                          alignment: AlignmentDirectional.centerEnd,
                                          child: TextButton(
                                            onPressed: state.isLoading
                                                ? null
                                                : () {
                                                    context.read<AuthController>().add(AuthPasswordResetSubmitted(email: state.userEmail ?? _emailController.text));
                                                  },
                                            child: Text(l10n.sendAgain),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        TextField(
                                          controller: _emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(labelText: l10n.email, hintText: l10n.emailHint, border: const OutlineInputBorder()),
                                        ),
                                        if (recentEmails.isNotEmpty) ...[
                                          const SizedBox(height: 12),
                                          _RecentEmailSuggestions(
                                            title: l10n.recentEmails,
                                            currentEmail: _emailController.text,
                                            emails: recentEmails,
                                            onSelected: (email) {
                                              _emailController.text = email;
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                              primaryLabel: isResetSent ? l10n.completeResetPassword : l10n.sendResetLink,
                              primaryPressed: state.isLoading
                                  ? null
                                  : () {
                                      if (!isResetSent) {
                                        context.read<AuthController>().add(AuthPasswordResetSubmitted(email: _emailController.text));
                                        return;
                                      }

                                      if (_passwordController.text != _confirmPasswordController.text) {
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(SnackBar(content: Text(l10n.message(AppMessageKey.passwordsDoNotMatch)), backgroundColor: Theme.of(context).colorScheme.error));
                                        return;
                                      }

                                      context.read<AuthController>().add(
                                        AuthPasswordResetCompleted(email: state.userEmail ?? _emailController.text, resetLink: _confirmationLinkController.text, password: _passwordController.text),
                                      );
                                    },
                              secondaryLabel: l10n.backToSignIn,
                              secondaryPressed: () {
                                context.read<AuthController>().add(const AuthScreenChanged(AuthScreen.signIn));
                              },
                              isLoading: state.isLoading,
                            );
                          }

                          return _AuthMainContent(
                            l10n: l10n,
                            localeController: widget.localeController,
                            appPreferencesController: widget.appPreferencesController,
                            isSignIn: isSignIn,
                            isSignUp: isSignUp,
                            isLoading: state.isLoading,
                            emailController: _emailController,
                            nameController: _nameController,
                            usernameController: _usernameController,
                            passwordController: _passwordController,
                            confirmPasswordController: _confirmPasswordController,
                            obscurePassword: _obscurePassword,
                            obscureConfirmPassword: _obscureConfirmPassword,
                            onTogglePasswordVisibility: _togglePasswordVisibility,
                            onToggleConfirmPasswordVisibility: _toggleConfirmPasswordVisibility,
                            onForgotPassword: () {
                              context.read<AuthController>().add(const AuthScreenChanged(AuthScreen.forgotPassword));
                            },
                            onSwitchScreen: (selection) {
                              context.read<AuthController>().add(AuthScreenChanged(selection));
                            },
                            onSubmit: () {
                              if (isSignUp && _passwordController.text != _confirmPasswordController.text) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(SnackBar(content: Text(l10n.message(AppMessageKey.passwordsDoNotMatch)), backgroundColor: Theme.of(context).colorScheme.error));
                                return;
                              }

                              context.read<AuthController>().add(AuthSubmitted(name: _nameController.text, username: _usernameController.text, email: _emailController.text, password: _passwordController.text));
                            },
                            currentScreen: state.screen,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          boxShadow: [BoxShadow(color: color, blurRadius: 40, spreadRadius: 12)],
        ),
      ),
    );
  }
}

class _AuthMainContent extends StatelessWidget {
  const _AuthMainContent({
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: headerIconSize,
                    width: headerIconSize,
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
                        Text(l10n.appTitle, style: (isCompactHeight ? theme.textTheme.titleMedium : theme.textTheme.titleLarge)?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(isSignIn ? l10n.signInFooter : l10n.signUpFooter, style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280))),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: headerGap),
              Text(isSignIn ? l10n.signIn : l10n.createAccount, style: (isCompactHeight ? theme.textTheme.headlineSmall : theme.textTheme.headlineMedium)?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(isSignIn ? l10n.signInSubtitle : l10n.signUpSubtitle, style: theme.textTheme.bodyLarge?.copyWith(color: const Color(0xFF5C6672))),
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
                _RecentEmailSuggestions(
                  title: l10n.recentEmails,
                  currentEmail: emailController.text,
                  emails: recentEmails,
                  onSelected: (email) {
                    emailController.text = email;
                  },
                ),
              ],
              SizedBox(height: fieldGap),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  hintText: l10n.passwordHint,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(onPressed: onTogglePasswordVisibility, icon: Icon(obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded)),
                ),
              ),
              if (isSignUp) ...[
                SizedBox(height: fieldGap),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: l10n.confirmPassword,
                    hintText: l10n.confirmPasswordHint,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(onPressed: onToggleConfirmPasswordVisibility, icon: Icon(obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded)),
                  ),
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

class _RecentEmailSuggestions extends StatelessWidget {
  const _RecentEmailSuggestions({required this.title, required this.currentEmail, required this.emails, required this.onSelected});

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
          children: [for (final email in emails) ActionChip(label: Text(email), avatar: Icon(email == currentEmail ? Icons.check_circle_rounded : Icons.email_outlined, size: 18), onPressed: () => onSelected(email))],
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

class _AuthStatusCard extends StatelessWidget {
  const _AuthStatusCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.primaryPressed,
    required this.secondaryLabel,
    required this.secondaryPressed,
    required this.isLoading,
    this.input,
  });

  final IconData icon;
  final String title;
  final String description;
  final String primaryLabel;
  final VoidCallback? primaryPressed;
  final String secondaryLabel;
  final VoidCallback secondaryPressed;
  final bool isLoading;
  final Widget? input;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.24 : 0.08),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(20)),
            child: Icon(icon, size: 34, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(description, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xFF5C6672))),
          if (input != null) ...[const SizedBox(height: 24), input!],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: primaryPressed,
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
            child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2.4)) : Text(primaryLabel),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: secondaryPressed,
            style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(54)),
            child: Text(secondaryLabel),
          ),
        ],
      ),
    );
  }
}
