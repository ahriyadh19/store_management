import 'dart:async';

import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

enum AuthActionStatus { authenticated, confirmEmail, passwordResetSent }

class AuthActionResult {
  const AuthActionResult({required this.status, this.user, this.email, this.messageKey});

  final AuthActionStatus status;
  final User? user;
  final String? email;
  final AppMessageKey? messageKey;
}

abstract class AuthRepository {
  String? get currentUserEmail;
  bool get hasCurrentSession;

  Future<User?> getCurrentUserProfile();

  Future<AuthActionResult> signIn({required String email, required String password});

  Future<AuthActionResult> signUp({required String name, required String email, required String password, required String username});

  Future<AuthActionResult> sendPasswordReset({required String email});

  Future<AuthActionResult> completeEmailConfirmation({required String email, required String confirmationLink});

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

    return AuthActionResult(status: AuthActionStatus.authenticated, user: user, email: user?.email ?? response.user?.email ?? email, messageKey: AppMessageKey.signedInSuccessfully);
  }

  @override
  Future<AuthActionResult> signUp({required String name, required String email, required String password, required String username}) async {
    final normalizedUsername = _normalizeUsername(username);
    final response = await _authClient.signUp(
      email: email,
      password: password,
      data: {'name': name.trim(), 'username': normalizedUsername});

    if (response.session != null && response.user != null) {
      await _upsertProfile(authUserId: response.user!.id, email: response.user?.email ?? email, name: name, username: normalizedUsername);
    }

    final user = await _loadUserProfile(authUserId: response.user?.id, fallbackEmail: response.user?.email ?? email, fallbackName: name, fallbackUsername: normalizedUsername);

    final hasSession = response.session != null;

    return AuthActionResult(
      status: hasSession ? AuthActionStatus.authenticated : AuthActionStatus.confirmEmail,
      user: user,
      email: user?.email ?? response.user?.email ?? email,
      messageKey: hasSession ? AppMessageKey.accountCreatedSuccessfully : AppMessageKey.accountCreatedConfirmEmail,
    );
  }

  @override
  Future<AuthActionResult> sendPasswordReset({required String email}) async {
    await _authClient.resetPasswordForEmail(email);

    return AuthActionResult(status: AuthActionStatus.passwordResetSent, email: email, messageKey: AppMessageKey.passwordResetInstructionsSent,
    );
  }

  @override
  Future<AuthActionResult> completeEmailConfirmation({required String email, required String confirmationLink}) async {
    final trimmedEmail = email.trim();
    final trimmedLink = confirmationLink.trim();

    if (trimmedLink.isEmpty) {
      throw AuthException(AppMessageKey.confirmationLinkRequired.name);
    }

    final uri = Uri.tryParse(trimmedLink);
    if (uri == null || !uri.hasScheme) {
      throw AuthException(AppMessageKey.confirmationLinkFullRequired.name);
    }

    if (_containsSessionParams(uri)) {
      await _authClient.getSessionFromUrl(uri);
    } else {
      final params = _extractLinkParameters(uri);
      final tokenHash = params['token_hash'];
      final otpType = _parseOtpType(params['type']);

      if (tokenHash == null || otpType == null) {
        throw AuthException(AppMessageKey.confirmationLinkMissingDetails.name);
      }

      await _authClient.verifyOTP(email: trimmedEmail.isEmpty ? null : trimmedEmail, tokenHash: tokenHash, type: otpType);
    }

    final currentUser = _authClient.currentUser;
    final user = await _loadUserProfile(authUserId: currentUser?.id, fallbackEmail: currentUser?.email ?? trimmedEmail);

    if (_authClient.currentSession == null) {
      return AuthActionResult(status: AuthActionStatus.confirmEmail, email: user?.email ?? currentUser?.email ?? trimmedEmail, user: user, messageKey: AppMessageKey.emailConfirmedSignIn);
    }

    return AuthActionResult(status: AuthActionStatus.authenticated, email: user?.email ?? currentUser?.email ?? trimmedEmail, user: user, messageKey: AppMessageKey.emailConfirmedSuccessfully);
  }

  @override
  Future<void> resendSignUpConfirmation({required String email}) {
    return _authClient.resend(type: OtpType.signup, email: email);
  }

  @override
  Future<void> signOut() {
    return _authClient.signOut();
  }

  Future<User?> _loadUserProfile({required String? authUserId, required String? fallbackEmail, String? fallbackName, String? fallbackUsername}) async {
    if (authUserId == null) {
      return _buildFallbackUser(email: fallbackEmail, name: fallbackName, username: fallbackUsername);
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

    return _buildFallbackUser(email: fallbackEmail, name: fallbackName, username: fallbackUsername);
  }

  Future<User?> _fetchProfile(String authUserId) async {
    final row = await _client.from('users').select().eq('auth_user_id', authUserId).maybeSingle();

    if (row == null) {
      return null;
    }

    return User.fromMap(Map<String, dynamic>.from(row));
  }

  Future<void> _upsertProfile({required String authUserId, required String email, required String name, required String username}) {
    return _client.from('users').upsert({'auth_user_id': authUserId, 'email': email, 'name': name.trim(), 'username': _normalizeUsername(username), 'status': 1}, onConflict: 'auth_user_id');
  }

  User? _buildFallbackUser({required String? email, String? name, String? username}) {
    if (email == null || email.isEmpty) {
      return null;
    }

    final now = DateTime.now();
    final usernameBase = _normalizeUsername(username ?? email.split('@').first);

    return User(name: name?.trim().isNotEmpty == true ? name!.trim() : usernameBase, email: email, username: usernameBase.isEmpty ? 'user' : usernameBase, status: 1, createdAt: now, updatedAt: now);
  }

  String _normalizeUsername(String value) {
    final normalized = value.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    return normalized.isEmpty ? 'user' : normalized;
  }

  bool _containsSessionParams(Uri uri) {
    final params = _extractLinkParameters(uri);
    return params.containsKey('code') || params.containsKey('access_token');
  }

  Map<String, String> _extractLinkParameters(Uri uri) {
    final params = <String, String>{...uri.queryParameters};
    final fragment = uri.fragment;

    if (fragment.isEmpty) {
      return params;
    }

    final fragmentQuery = fragment.contains('?') ? fragment.substring(fragment.indexOf('?') + 1) : fragment;
    if (fragmentQuery.isEmpty || !fragmentQuery.contains('=')) {
      return params;
    }

    params.addAll(Uri.splitQueryString(fragmentQuery));
    return params;
  }

  OtpType? _parseOtpType(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'sms':
        return OtpType.sms;
      case 'phonechange':
      case 'phone_change':
        return OtpType.phoneChange;
      case 'signup':
        return OtpType.signup;
      case 'invite':
        return OtpType.invite;
      case 'magiclink':
      case 'magic_link':
        return OtpType.magiclink;
      case 'recovery':
        return OtpType.recovery;
      case 'emailchange':
      case 'email_change':
        return OtpType.emailChange;
      case 'email':
        return OtpType.email;
      default:
        return null;
    }
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
    _currentUser = _buildUser(email: email, name: seedName, username: email.split('@').first);

    return AuthActionResult(status: AuthActionStatus.authenticated, user: _currentUser, email: email, messageKey: AppMessageKey.signedInSuccessfully);
  }

  @override
  Future<AuthActionResult> signUp({required String name, required String email, required String password, required String username}) async {
    _currentUser = _buildUser(email: email, name: name, username: username);

    return AuthActionResult(status: AuthActionStatus.confirmEmail, user: _currentUser, email: email, messageKey: AppMessageKey.accountCreatedConfirmEmail);
  }

  @override
  Future<AuthActionResult> sendPasswordReset({required String email}) async {
    return AuthActionResult(status: AuthActionStatus.passwordResetSent, email: email, messageKey: AppMessageKey.passwordResetInstructionsSent);
  }

  @override
  Future<AuthActionResult> completeEmailConfirmation({required String email, required String confirmationLink}) async {
    return AuthActionResult(status: AuthActionStatus.authenticated, user: _currentUser, email: email, messageKey: AppMessageKey.emailConfirmedSuccessfully);
  }

  @override
  Future<void> resendSignUpConfirmation({required String email}) async {}

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  User _buildUser({required String email, required String name, required String username}) {
    final now = DateTime.now();
    return User(id: 1, name: name, email: email, username: username, status: 1, createdAt: now, updatedAt: now);
  }
}