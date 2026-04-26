import 'dart:async';

import 'package:store_management/models/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

enum AuthActionStatus { authenticated, confirmEmail, passwordResetSent }

class AuthActionResult {
  const AuthActionResult({required this.status, this.user, this.email, this.message});

  final AuthActionStatus status;
  final User? user;
  final String? email;
  final String? message;
}

abstract class AuthRepository {
  String? get currentUserEmail;
  bool get hasCurrentSession;

  Future<User?> getCurrentUserProfile();

  Future<AuthActionResult> signIn({required String email, required String password});

  Future<AuthActionResult> signUp({required String name, required String email, required String password});

  Future<AuthActionResult> sendPasswordReset({required String email});

  Future<void> resendSignUpConfirmation({required String email});

  Future<void> signOut();
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({SupabaseClient? client}) : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  GoTrueClient get _authClient => _client.auth;

  @override
  String? get currentUserEmail => _authClient.currentUser?.email;

  @override
  bool get hasCurrentSession => _authClient.currentSession != null;

  @override
  Future<User?> getCurrentUserProfile() async {
    final currentUser = _authClient.currentUser;
    if (currentUser == null) {
      return null;
    }

    return _loadUserProfile(authUserId: currentUser.id, fallbackEmail: currentUser.email);
  }

  @override
  Future<AuthActionResult> signIn({required String email, required String password}) async {
    final response = await _authClient.signInWithPassword(
      email: email,
      password: password,
    );

    final user = await _loadUserProfile(authUserId: response.user?.id, fallbackEmail: response.user?.email ?? email, fallbackName: response.user?.userMetadata?['name'] as String?);

    return AuthActionResult(status: AuthActionStatus.authenticated, user: user, email: user?.email ?? response.user?.email ?? email, message: 'Signed in successfully.');
  }

  @override
  Future<AuthActionResult> signUp({required String name, required String email, required String password}) async {
    final response = await _authClient.signUp(
      email: email,
      password: password,
      data: {'name': name.trim()});

    final user = await _loadUserProfile(authUserId: response.user?.id, fallbackEmail: response.user?.email ?? email, fallbackName: name);

    final hasSession = response.session != null;

    return AuthActionResult(
      status: hasSession ? AuthActionStatus.authenticated : AuthActionStatus.confirmEmail,
      user: user,
      email: user?.email ?? response.user?.email ?? email,
      message: hasSession ? 'Account created successfully.' : 'Account created. Confirm your email before signing in.',
    );
  }

  @override
  Future<AuthActionResult> sendPasswordReset({required String email}) async {
    await _authClient.resetPasswordForEmail(email);

    return AuthActionResult(status: AuthActionStatus.passwordResetSent, email: email, message: 'Password reset instructions sent to $email.',
    );
  }

  @override
  Future<void> resendSignUpConfirmation({required String email}) {
    return _authClient.resend(type: OtpType.signup, email: email);
  }

  @override
  Future<void> signOut() {
    return _authClient.signOut();
  }

  Future<User?> _loadUserProfile({required String? authUserId, required String? fallbackEmail, String? fallbackName}) async {
    if (authUserId == null) {
      return _buildFallbackUser(email: fallbackEmail, name: fallbackName);
    }

    for (var attempt = 0; attempt < 3; attempt++) {
      final profile = await _fetchProfile(authUserId);
      if (profile != null) {
        return profile;
      }

      if (attempt < 2) {
        await Future<void>.delayed(const Duration(milliseconds: 250));
      }
    }

    return _buildFallbackUser(email: fallbackEmail, name: fallbackName);
  }

  Future<User?> _fetchProfile(String authUserId) async {
    final row = await _client.from('users').select().eq('auth_user_id', authUserId).maybeSingle();

    if (row == null) {
      return null;
    }

    return User.fromMap(Map<String, dynamic>.from(row));
  }

  User? _buildFallbackUser({required String? email, String? name}) {
    if (email == null || email.isEmpty) {
      return null;
    }

    final now = DateTime.now();
    final usernameBase = email.split('@').first.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');

    return User(name: name?.trim().isNotEmpty == true ? name!.trim() : usernameBase, email: email, username: usernameBase.isEmpty ? 'user' : usernameBase, status: 1, createdAt: now, updatedAt: now);
  }
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.seedEmail, this.seedName = 'Demo User'});

  final String? seedEmail;
  final String seedName;
  User? _currentUser;

  @override
  String? get currentUserEmail => _currentUser?.email ?? seedEmail;

  @override
  bool get hasCurrentSession => currentUserEmail != null;

  @override
  Future<User?> getCurrentUserProfile() async {
    return _currentUser;
  }

  @override
  Future<AuthActionResult> signIn({required String email, required String password}) async {
    _currentUser = _buildUser(email: email, name: seedName);

    return AuthActionResult(status: AuthActionStatus.authenticated, user: _currentUser, email: email, message: 'Signed in successfully.');
  }

  @override
  Future<AuthActionResult> signUp({required String name, required String email, required String password}) async {
    _currentUser = _buildUser(email: email, name: name);

    return AuthActionResult(status: AuthActionStatus.confirmEmail, user: _currentUser, email: email, message: 'Account created. Confirm your email before signing in.');
  }

  @override
  Future<AuthActionResult> sendPasswordReset({required String email}) async {
    return AuthActionResult(status: AuthActionStatus.passwordResetSent, email: email, message: 'Password reset instructions sent to $email.');
  }

  @override
  Future<void> resendSignUpConfirmation({required String email}) async {}

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  User _buildUser({required String email, required String name}) {
    final now = DateTime.now();
    return User(id: 1, name: name, email: email, username: email.split('@').first, status: 1, createdAt: now, updatedAt: now);
  }
}