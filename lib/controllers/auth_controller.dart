import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/models/users.dart';
import 'package:store_management/services/auth_repository.dart';

enum AuthScreen { signIn, signUp, forgotPassword, confirmEmail, resetPassword }

enum AuthStatus { initial, submitting, authenticated, confirmEmailRequired, passwordResetSent, failure }

sealed class AuthEvent {
	const AuthEvent();
}

final class AuthStarted extends AuthEvent {
	const AuthStarted();
	}

final class AuthScreenChanged extends AuthEvent {
  const AuthScreenChanged(this.screen);

  final AuthScreen screen;
}

final class AuthSubmitted extends AuthEvent {
  const AuthSubmitted({required this.email, required this.password, this.name = '', this.username = ''});

	final String email;
	final String password;
  final String name;
  final String username;
}

final class AuthPasswordResetSubmitted extends AuthEvent {
  const AuthPasswordResetSubmitted({required this.email});

  final String email;
}

final class AuthConfirmationResent extends AuthEvent {
  const AuthConfirmationResent({required this.email});

  final String email;
}

final class AuthConfirmationLinkSubmitted extends AuthEvent {
  const AuthConfirmationLinkSubmitted({required this.email, required this.confirmationLink});

  final String email;
  final String confirmationLink;
}

final class AuthSignedOut extends AuthEvent {
	const AuthSignedOut();
}

final class AuthState {
	const AuthState({
		this.screen = AuthScreen.signIn,
		this.status = AuthStatus.initial,
		this.message,
		this.userEmail,
		this.user,
	});

  final AuthScreen screen;
	final AuthStatus status;
	final String? message;
	final String? userEmail;
  final User? user;

	bool get isLoading => status == AuthStatus.submitting;
	bool get isAuthenticated => status == AuthStatus.authenticated;

	AuthState copyWith({
		AuthScreen? screen,
		AuthStatus? status,
		String? message,
		bool clearMessage = false,
		String? userEmail,
		bool clearUserEmail = false,
		User? user, bool clearUser = false,
	}) {
		return AuthState(
      screen: screen ?? this.screen,
			status: status ?? this.status,
			message: clearMessage ? null : (message ?? this.message),
			userEmail: clearUserEmail ? null : (userEmail ?? this.userEmail),
      user: clearUser ? null : (user ?? this.user),
		);
	}
}

class AuthController extends Bloc<AuthEvent, AuthState> {
	AuthController({required AuthRepository authRepository})
			: _authRepository = authRepository,
				super(
					AuthState(
						status: authRepository.currentUserEmail == null ? AuthStatus.initial : AuthStatus.authenticated,
						userEmail: authRepository.currentUserEmail,
					),
				) {
    on<AuthStarted>(_onStarted);
    on<AuthScreenChanged>(_onScreenChanged);
		on<AuthSubmitted>(_onSubmitted);
    on<AuthPasswordResetSubmitted>(_onPasswordResetSubmitted);
    on<AuthConfirmationResent>(_onConfirmationResent);
    on<AuthConfirmationLinkSubmitted>(_onConfirmationLinkSubmitted);
		on<AuthSignedOut>(_onSignedOut);

    if (_authRepository.hasCurrentSession) {
      add(const AuthStarted());
    }
	}

	final AuthRepository _authRepository;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final user = await _authRepository.getCurrentUserProfile();
    if (user == null) {
      return;
    }

		emit(
			state.copyWith(
				status: AuthStatus.authenticated, userEmail: user.email, user: user));
  }

  void _onScreenChanged(AuthScreenChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(screen: event.screen,
				status: AuthStatus.initial,
				clearMessage: true,
				clearUser: event.screen != AuthScreen.confirmEmail,
			),
		);
	}

	Future<void> _onSubmitted(AuthSubmitted event, Emitter<AuthState> emit) async {
    final name = event.name.trim();
    final username = event.username.trim();
		final email = event.email.trim();
		final password = event.password.trim();

    if (state.screen == AuthScreen.signUp && name.isEmpty) {
      emit(state.copyWith(status: AuthStatus.failure, message: 'Name is required.'));
      return;
    }

    if (state.screen == AuthScreen.signUp && username.isEmpty) {
      emit(state.copyWith(status: AuthStatus.failure, message: 'Username is required.'));
      return;
    }

    if (state.screen == AuthScreen.signUp && !_isValidUsername(username)) {
      emit(state.copyWith(status: AuthStatus.failure, message: 'Username can use letters, numbers, and underscores only.'));
      return;
    }

		if (email.isEmpty || password.isEmpty) {
			emit(
				state.copyWith(
					status: AuthStatus.failure,
					message: 'Email and password are required.',
				),
			);
			return;
		}

		if (!email.contains('@')) {
			emit(
				state.copyWith(
					status: AuthStatus.failure,
					message: 'Enter a valid email address.',
				),
			);
			return;
		}

		if (password.length < 6) {
			emit(
				state.copyWith(
					status: AuthStatus.failure,
					message: 'Password must be at least 6 characters.',
				),
			);
			return;
		}

		emit(state.copyWith(status: AuthStatus.submitting, clearMessage: true));

		try {
      final result = state.screen == AuthScreen.signIn
					? await _authRepository.signIn(email: email, password: password)
					: await _authRepository.signUp(name: name, email: email, password: password, username: username);

      if (result.status == AuthActionStatus.confirmEmail) {
        emit(state.copyWith(screen: AuthScreen.confirmEmail, status: AuthStatus.confirmEmailRequired, message: result.message, userEmail: result.email ?? email, user: result.user));
        return;
      }

			emit(
				state.copyWith(
					status: AuthStatus.authenticated,
					message: result.message, userEmail: result.email ?? email, user: result.user));
    } catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, message: _buildAuthErrorMessage(error)));
    }
  }

  Future<void> _onPasswordResetSubmitted(AuthPasswordResetSubmitted event, Emitter<AuthState> emit) async {
    final email = event.email.trim();
    if (email.isEmpty || !email.contains('@')) {
      emit(state.copyWith(status: AuthStatus.failure, message: 'Enter a valid email address.'));
      return;
    }

    emit(state.copyWith(status: AuthStatus.submitting, clearMessage: true));

    try {
      final result = await _authRepository.sendPasswordReset(email: email);
      emit(state.copyWith(screen: AuthScreen.resetPassword, status: AuthStatus.passwordResetSent, message: result.message, userEmail: result.email ?? email));
    } catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, message: _buildAuthErrorMessage(error)));
    }
  }

  Future<void> _onConfirmationResent(AuthConfirmationResent event, Emitter<AuthState> emit) async {
    final email = event.email.trim();
    if (email.isEmpty) {
      return;
    }

    emit(state.copyWith(status: AuthStatus.submitting, clearMessage: true));

    try {
      await _authRepository.resendSignUpConfirmation(email: email);
      emit(state.copyWith(screen: AuthScreen.confirmEmail, status: AuthStatus.confirmEmailRequired, message: 'Confirmation email sent again to $email.', userEmail: email,
				),
			);
		} catch (error) {
			emit(
				state.copyWith(
					status: AuthStatus.failure,
					message: _buildAuthErrorMessage(error),
				),
			);
		}
	}

  Future<void> _onConfirmationLinkSubmitted(AuthConfirmationLinkSubmitted event, Emitter<AuthState> emit) async {
    final email = event.email.trim();
    final confirmationLink = event.confirmationLink.trim();

    if (email.isEmpty || !email.contains('@')) {
      emit(state.copyWith(status: AuthStatus.failure, message: 'Enter a valid email address.'));
      return;
    }

    if (confirmationLink.isEmpty) {
      emit(state.copyWith(status: AuthStatus.failure, message: 'Paste the confirmation link from your email.'));
      return;
    }

    emit(state.copyWith(status: AuthStatus.submitting, clearMessage: true));

    try {
      final result = await _authRepository.completeEmailConfirmation(email: email, confirmationLink: confirmationLink);

      if (result.status == AuthActionStatus.authenticated) {
        emit(state.copyWith(status: AuthStatus.authenticated, message: result.message, userEmail: result.email ?? email, user: result.user));
        return;
      }

      emit(state.copyWith(screen: AuthScreen.signIn, status: AuthStatus.initial, message: result.message, userEmail: result.email ?? email, clearUser: true));
    } catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, message: _buildAuthErrorMessage(error)));
    }
  }

	Future<void> _onSignedOut(AuthSignedOut event, Emitter<AuthState> emit) async {
		await _authRepository.signOut();
		emit(
			state.copyWith(
				screen: AuthScreen.signIn,
				status: AuthStatus.initial,
				clearMessage: true,
				clearUserEmail: true,
				clearUser: true,
			),
		);
	}

	String _buildAuthErrorMessage(Object error) {
		final message = error.toString();

		if (message.startsWith('AuthException(')) {
			return message.substring('AuthException('.length, message.length - 1);
		}

		return message;
	}

  bool _isValidUsername(String value) {
    final usernamePattern = RegExp(r'^[a-zA-Z0-9_]{3,30}$');
    return usernamePattern.hasMatch(value);
  }
}