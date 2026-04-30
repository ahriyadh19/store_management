import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/services/app_preferences_controller.dart';
import 'package:store_management/views/components/auth_form_panel.dart';

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
                                          AuthRecentEmailSuggestions(
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

                          return AuthFormPanel(
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
