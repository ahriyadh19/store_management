import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_management/services/auth_repository.dart';

enum AuthMode { signIn, signUp }

enum AuthStatus { initial, submitting, authenticated, failure }

sealed class AuthEvent {
	const AuthEvent();
}

final class AuthModeChanged extends AuthEvent {
	const AuthModeChanged(this.mode);

	final AuthMode mode;
}

final class AuthSubmitted extends AuthEvent {
	const AuthSubmitted({required this.email, required this.password});

	final String email;
	final String password;
}

final class AuthSignedOut extends AuthEvent {
	const AuthSignedOut();
}

final class AuthState {
	const AuthState({
		this.mode = AuthMode.signIn,
		this.status = AuthStatus.initial,
		this.message,
		this.userEmail,
	});

	final AuthMode mode;
	final AuthStatus status;
	final String? message;
	final String? userEmail;

	bool get isLoading => status == AuthStatus.submitting;
	bool get isAuthenticated => status == AuthStatus.authenticated;

	AuthState copyWith({
		AuthMode? mode,
		AuthStatus? status,
		String? message,
		bool clearMessage = false,
		String? userEmail,
		bool clearUserEmail = false,
	}) {
		return AuthState(
			mode: mode ?? this.mode,
			status: status ?? this.status,
			message: clearMessage ? null : (message ?? this.message),
			userEmail: clearUserEmail ? null : (userEmail ?? this.userEmail),
		);
	}
}

class AuthController extends Bloc<AuthEvent, AuthState> {
	AuthController({required AuthRepository authRepository})
			: _authRepository = authRepository,
				super(
					AuthState(
						status: authRepository.currentUserEmail == null
								? AuthStatus.initial
								: AuthStatus.authenticated,
						userEmail: authRepository.currentUserEmail,
					),
				) {
		on<AuthModeChanged>(_onModeChanged);
		on<AuthSubmitted>(_onSubmitted);
		on<AuthSignedOut>(_onSignedOut);
	}

	final AuthRepository _authRepository;

	void _onModeChanged(AuthModeChanged event, Emitter<AuthState> emit) {
		emit(
			state.copyWith(
				mode: event.mode,
				status: AuthStatus.initial,
				clearMessage: true,
			),
		);
	}

	Future<void> _onSubmitted(AuthSubmitted event, Emitter<AuthState> emit) async {
		final email = event.email.trim();
		final password = event.password.trim();

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
			final userEmail = state.mode == AuthMode.signIn
					? await _authRepository.signIn(email: email, password: password)
					: await _authRepository.signUp(email: email, password: password);

			final message = state.mode == AuthMode.signIn
					? 'Signed in successfully.'
					: 'Account created successfully. Check your email if confirmation is enabled.';

			emit(
				state.copyWith(
					status: AuthStatus.authenticated,
					message: message,
					userEmail: userEmail ?? email,
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

	Future<void> _onSignedOut(AuthSignedOut event, Emitter<AuthState> emit) async {
		await _authRepository.signOut();
		emit(
			state.copyWith(
				mode: AuthMode.signIn,
				status: AuthStatus.initial,
				clearMessage: true,
				clearUserEmail: true,
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
}