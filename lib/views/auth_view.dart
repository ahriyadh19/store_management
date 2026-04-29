import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/controllers/auth_controller.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/views/components/language_switcher.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key, required this.localeController});

  final LocaleController localeController;

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

        final color = state.status == AuthStatus.failure
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: color,
            ),
          );
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
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
                            Text(
                              l10n.confirmEmailPasteHint,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF5C6672)),
                            ),
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

                      return _AuthStatusCard(
                        icon: isResetSent ? Icons.password_rounded : Icons.lock_reset_rounded,
                        title: isResetSent ? l10n.resetPassword : l10n.forgotPasswordTitle,
                        description: isResetSent
                            ? l10n.resetPasswordSentDescription(state.userEmail ?? _emailController.text) : l10n.forgotPasswordDescription,
                        input: isResetSent
                            ? null
                            : TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(labelText: l10n.email, hintText: l10n.emailHint, border: const OutlineInputBorder()),
                              ),
                        primaryLabel: isResetSent ? l10n.sendAgain : l10n.sendResetLink,
                        primaryPressed: state.isLoading
                            ? null
                            : () {
                                context.read<AuthController>().add(AuthPasswordResetSubmitted(email: _emailController.text));
                              },
                        secondaryLabel: l10n.backToSignIn,
                        secondaryPressed: () {
                          context.read<AuthController>().add(const AuthScreenChanged(AuthScreen.signIn));
                        },
                        isLoading: state.isLoading,
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 28,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: LanguageSwitcher(localeController: widget.localeController),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isSignIn ? l10n.signIn : l10n.createAccount,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isSignIn
                                ? l10n.signInSubtitle : l10n.signUpSubtitle,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xFF5C6672),
                                ),
                          ),
                          const SizedBox(height: 24),
                          SegmentedButton<AuthScreen>(
                            segments: [
                              ButtonSegment(value: AuthScreen.signIn, label: Text(l10n.signIn)),
                              ButtonSegment(value: AuthScreen.signUp, label: Text(l10n.signUp)),
                            ],
                            selected: {state.screen},
                            onSelectionChanged: (selection) {
                              context.read<AuthController>().add(
                                    AuthScreenChanged(selection.first),
                                  );
                            },
                          ),
                          const SizedBox(height: 24),
                          if (isSignUp) ...[
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(labelText: l10n.name, hintText: l10n.nameHint, border: const OutlineInputBorder()),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(labelText: l10n.username, hintText: l10n.usernameHint, border: const OutlineInputBorder()),
                            ),
                            const SizedBox(height: 16),
                          ],
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(labelText: l10n.email, hintText: l10n.emailHint, border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: l10n.password,
                              hintText: l10n.passwordHint,
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                icon: Icon(_obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                              ),
                            ),
                          ),
                          if (isSignUp) ...[
                            const SizedBox(height: 16),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                labelText: l10n.confirmPassword,
                                hintText: l10n.confirmPasswordHint,
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    if (isSignUp && _passwordController.text != _confirmPasswordController.text) {
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(SnackBar(content: Text(l10n.message(AppMessageKey.passwordsDoNotMatch)), backgroundColor: Theme.of(context).colorScheme.error));
                                      return;
                                    }

                                    context.read<AuthController>().add(
                                          AuthSubmitted(
                                            name: _nameController.text,
                                            username: _usernameController.text,
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          ),
                                        );
                                  },
                            style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                            ),
                            child: state.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2.4),
                                  )
                                : Text(isSignIn ? l10n.continueLabel : l10n.createAccount),
                          ),
                          if (isSignIn) ...[
                            const SizedBox(height: 12),
                            Align(
                              alignment: AlignmentDirectional.center,
                              child: TextButton(
                                onPressed: () {
                                  context.read<AuthController>().add(const AuthScreenChanged(AuthScreen.forgotPassword));
                                },
                                child: Text(l10n.forgotPasswordAction),
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                          Text(
                            isSignIn
                                ? l10n.signInFooter : l10n.signUpFooter,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF5C6672),
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 28, offset: Offset(0, 16))],
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
