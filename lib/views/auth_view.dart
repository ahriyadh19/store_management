import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/controllers/auth_controller.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

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
    return BlocListener<AuthController, AuthState>(
      listenWhen: (previous, current) => previous.message != current.message,
      listener: (context, state) {
        if (state.userEmail != null && state.userEmail!.isNotEmpty) {
          _emailController.text = state.userEmail!;
        }

        final message = state.message;
        if (message == null || message.isEmpty) {
          return;
        }

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
                        title: 'Confirm your email',
                        description: 'We sent a confirmation link to ${state.userEmail ?? _emailController.text}. On Linux desktop the link usually opens in your browser instead of returning to the app.',
                        input: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'If the app does not open after you confirm, copy the final browser address and paste it here to finish confirmation.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF5C6672)),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _confirmationLinkController,
                              minLines: 2,
                              maxLines: 4,
                              decoration: const InputDecoration(labelText: 'Confirmation link', hintText: 'https://...token_hash=... or https://...code=...', border: OutlineInputBorder()),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        context.read<AuthController>().add(AuthConfirmationResent(email: state.userEmail ?? _emailController.text));
                                      },
                                child: const Text('Resend email'),
                              ),
                            ),
                          ],
                        ),
                        primaryLabel: 'Complete confirmation',
                        primaryPressed: state.isLoading
                            ? null
                            : () {
                                context.read<AuthController>().add(AuthConfirmationLinkSubmitted(email: state.userEmail ?? _emailController.text, confirmationLink: _confirmationLinkController.text));
                              },
                        secondaryLabel: 'Back to sign in',
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
                        title: isResetSent ? 'Reset password' : 'Forgot password?',
                        description: isResetSent
                            ? 'A reset link was sent to ${state.userEmail ?? _emailController.text}. Use the link in your email to choose a new password.'
                            : 'Enter your email and we will send you a reset password link.',
                        input: isResetSent
                            ? null
                            : TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(labelText: 'Email', hintText: 'name@store.com', border: OutlineInputBorder()),
                              ),
                        primaryLabel: isResetSent ? 'Send again' : 'Send reset link',
                        primaryPressed: state.isLoading
                            ? null
                            : () {
                                context.read<AuthController>().add(AuthPasswordResetSubmitted(email: _emailController.text));
                              },
                        secondaryLabel: 'Back to sign in',
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
                          Container(
                            height: 64,
                            width: 64,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              Icons.lock_open_rounded,
                              size: 34,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isSignIn ? 'Sign in' : 'Create account',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isSignIn
                                ? 'Use your email and password to continue.'
                                : 'Create your account and profile for the store app.',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: const Color(0xFF5C6672),
                                ),
                          ),
                          const SizedBox(height: 24),
                          SegmentedButton<AuthScreen>(
                            segments: const [
                              ButtonSegment(value: AuthScreen.signIn, label: Text('Sign in')),
                              ButtonSegment(value: AuthScreen.signUp, label: Text('Sign up')),
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
                              decoration: const InputDecoration(labelText: 'Name', hintText: 'Store owner name', border: OutlineInputBorder()),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(labelText: 'Username', hintText: 'store_owner', border: OutlineInputBorder()),
                            ),
                            const SizedBox(height: 16),
                          ],
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              hintText: 'name@store.com',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'At least 6 characters',
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
                                labelText: 'Confirm password',
                                hintText: 'Re-enter your password',
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
                                        ..showSnackBar(SnackBar(content: const Text('Passwords do not match.'), backgroundColor: Theme.of(context).colorScheme.error));
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
                                : Text(isSignIn ? 'Continue' : 'Create account'),
                          ),
                          if (isSignIn) ...[
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  context.read<AuthController>().add(const AuthScreenChanged(AuthScreen.forgotPassword));
                                },
                                child: const Text('Forgot password?'),
                              ),
                            ),
                          ],
                          const SizedBox(height: 14),
                          Text(
                            isSignIn
                                ? 'Use your Supabase email and password to continue.'
                                : 'Name, username, email, password, and confirm password are used to create your profile.',
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
