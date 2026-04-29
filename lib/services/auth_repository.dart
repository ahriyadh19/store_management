import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:store_management/localization/app_localizations.dart';
import 'package:store_management/models/users.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

const _authRedirectTo = String.fromEnvironment('AUTH_REDIRECT_TO');

enum AuthActionStatus { authenticated, confirmEmail, passwordResetSent }

enum AuthSessionStatus { signedIn, signedOut, passwordRecovery }

class AuthActionResult {
  const AuthActionResult({required this.status, this.user, this.email, this.messageKey});

  final AuthActionStatus status;
  final User? user;
  final String? email;
  final AppMessageKey? messageKey;
}

class AuthSessionSnapshot {
  const AuthSessionSnapshot({required this.status, this.user, this.email, this.messageKey});

  final AuthSessionStatus status;
  final User? user;
  final String? email;
  final AppMessageKey? messageKey;
}

abstract class AuthRepository {
  String? get currentUserEmail;
  bool get hasCurrentSession;
  Stream<AuthSessionSnapshot> get authStateChanges;

  Future<User?> getCurrentUserProfile();

  Future<AuthSessionSnapshot?> restoreSessionFromIncomingLink();

  Future<AuthActionResult> signIn({required String email, required String password});

  Future<AuthActionResult> signUp({required String name, required String email, required String password, required String username});

  Future<AuthActionResult> sendPasswordReset({required String email});

  Future<AuthActionResult> completeEmailConfirmation({required String email, required String confirmationLink});

  Future<AuthActionResult> completePasswordReset({required String email, required String resetLink, required String password});

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
  Stream<AuthSessionSnapshot> get authStateChanges => _authClient.onAuthStateChange.asyncMap((data) async {
    final session = data.session;
    final authUser = session?.user ?? _authClient.currentUser;

    switch (data.event) {
      case AuthChangeEvent.passwordRecovery:
        return AuthSessionSnapshot(
          status: AuthSessionStatus.passwordRecovery,
          user: await _loadUserProfile(authUserId: authUser?.id, fallbackEmail: authUser?.email, fallbackName: authUser?.userMetadata?['name'] as String?),
          email: authUser?.email,
        );
      case AuthChangeEvent.signedIn:
      case AuthChangeEvent.initialSession:
      case AuthChangeEvent.tokenRefreshed:
      case AuthChangeEvent.userUpdated:
      case AuthChangeEvent.mfaChallengeVerified:
        if (authUser == null) {
          return const AuthSessionSnapshot(status: AuthSessionStatus.signedOut);
        }

        return AuthSessionSnapshot(
          status: AuthSessionStatus.signedIn,
          user: await _loadUserProfile(authUserId: authUser.id, fallbackEmail: authUser.email, fallbackName: authUser.userMetadata?['name'] as String?),
          email: authUser.email,
        );
      case AuthChangeEvent.signedOut:
        return const AuthSessionSnapshot(status: AuthSessionStatus.signedOut);
      default:
        return const AuthSessionSnapshot(status: AuthSessionStatus.signedOut);
    }
  });

  @override
  Future<User?> getCurrentUserProfile() async {
    final currentUser = _authClient.currentUser;
    if (currentUser == null) {
      return null;
    }

    return _loadUserProfile(authUserId: currentUser.id, fallbackEmail: currentUser.email);
  }

  @override
  Future<AuthSessionSnapshot?> restoreSessionFromIncomingLink() async {
    if (!kIsWeb) {
      return null;
    }

    final uri = Uri.base;
    if (!_containsSessionParams(uri) && !_containsOtpParams(uri)) {
      return null;
    }

    await _applyLinkSession(
      link: uri.toString(),
      email: currentUserEmail ?? '',
      requiredOtpTypes: const {OtpType.signup, OtpType.invite, OtpType.email, OtpType.emailChange, OtpType.magiclink, OtpType.recovery},
      requiredMessageKey: AppMessageKey.confirmationLinkRequired,
      fullMessageKey: AppMessageKey.confirmationLinkFullRequired,
      missingMessageKey: AppMessageKey.confirmationLinkMissingDetails,
    );

    final authUser = _authClient.currentUser;
    final params = _extractLinkParameters(uri);
    final otpType = _parseOtpType(params['type']);
    final isRecovery = otpType == OtpType.recovery;
    final user = await _loadUserProfile(authUserId: authUser?.id, fallbackEmail: authUser?.email, fallbackName: authUser?.userMetadata?['name'] as String?);

    return AuthSessionSnapshot(
      status: isRecovery ? AuthSessionStatus.passwordRecovery : (_authClient.currentSession == null ? AuthSessionStatus.signedOut : AuthSessionStatus.signedIn),
      user: user,
      email: user?.email ?? authUser?.email,
      messageKey: isRecovery ? AppMessageKey.passwordResetInstructionsSent : (_authClient.currentSession == null ? AppMessageKey.emailConfirmedSignIn : AppMessageKey.emailConfirmedSuccessfully),
    );
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
    final emailRedirectTo = _resolveEmailRedirectTo();
    final response = await _authClient.signUp(
      email: email,
      password: password,
      emailRedirectTo: emailRedirectTo, data: {'name': name.trim(), 'username': normalizedUsername});

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
    await _authClient.resetPasswordForEmail(email, redirectTo: _resolveEmailRedirectTo());

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

    await _applyLinkSession(
      link: trimmedLink,
      email: trimmedEmail,
      requiredOtpTypes: const {OtpType.signup, OtpType.invite, OtpType.email, OtpType.emailChange, OtpType.magiclink},
      requiredMessageKey: AppMessageKey.confirmationLinkRequired,
      fullMessageKey: AppMessageKey.confirmationLinkFullRequired,
      missingMessageKey: AppMessageKey.confirmationLinkMissingDetails,
    );

    final currentUser = _authClient.currentUser;
    final user = await _loadUserProfile(authUserId: currentUser?.id, fallbackEmail: currentUser?.email ?? trimmedEmail);

    if (_authClient.currentSession == null) {
      return AuthActionResult(status: AuthActionStatus.confirmEmail, email: user?.email ?? currentUser?.email ?? trimmedEmail, user: user, messageKey: AppMessageKey.emailConfirmedSignIn);
    }

    return AuthActionResult(status: AuthActionStatus.authenticated, email: user?.email ?? currentUser?.email ?? trimmedEmail, user: user, messageKey: AppMessageKey.emailConfirmedSuccessfully);
  }

  @override
  Future<AuthActionResult> completePasswordReset({required String email, required String resetLink, required String password}) async {
    final trimmedEmail = email.trim();
    final trimmedLink = resetLink.trim();
    final trimmedPassword = password.trim();

    if (trimmedLink.isEmpty) {
      throw AuthException(AppMessageKey.resetLinkRequired.name);
    }

    await _applyLinkSession(
      link: trimmedLink,
      email: trimmedEmail,
      requiredOtpTypes: const {OtpType.recovery},
      requiredMessageKey: AppMessageKey.resetLinkRequired,
      fullMessageKey: AppMessageKey.resetLinkFullRequired,
      missingMessageKey: AppMessageKey.resetLinkMissingDetails,
    );

    await _authClient.updateUser(UserAttributes(password: trimmedPassword));

    final currentUser = _authClient.currentUser;
    final user = await _loadUserProfile(authUserId: currentUser?.id, fallbackEmail: currentUser?.email ?? trimmedEmail);

    return AuthActionResult(status: AuthActionStatus.authenticated, email: user?.email ?? currentUser?.email ?? trimmedEmail, user: user, messageKey: AppMessageKey.passwordUpdatedSuccessfully);
  }

  @override
  Future<void> resendSignUpConfirmation({required String email}) {
    return _authClient.resend(type: OtpType.signup, email: email, emailRedirectTo: _resolveEmailRedirectTo());
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

  String? _resolveEmailRedirectTo() {
    if (_authRedirectTo.isNotEmpty) {
      return _authRedirectTo;
    }

    if (kIsWeb && (Uri.base.scheme == 'http' || Uri.base.scheme == 'https')) {
      return Uri.base.replace(query: null, fragment: null).toString();
    }

    return null;
  }

  Future<void> _applyLinkSession({
    required String link,
    required String email,
    required Set<OtpType> requiredOtpTypes,
    required AppMessageKey requiredMessageKey,
    required AppMessageKey fullMessageKey,
    required AppMessageKey missingMessageKey,
  }) async {
    final uri = Uri.tryParse(link);
    if (uri == null || !uri.hasScheme) {
      throw AuthException(fullMessageKey.name);
    }

    if (_containsSessionParams(uri)) {
      await _authClient.getSessionFromUrl(uri);
      return;
    }

    final params = _extractLinkParameters(uri);
    final tokenHash = params['token_hash'];
    final otpType = _parseOtpType(params['type']);

    if (tokenHash == null || otpType == null || !requiredOtpTypes.contains(otpType)) {
      throw AuthException(missingMessageKey.name);
    }

    await _authClient.verifyOTP(email: email.trim().isEmpty ? null : email.trim(), tokenHash: tokenHash, type: otpType);
  }

  bool _containsSessionParams(Uri uri) {
    final params = _extractLinkParameters(uri);
    return params.containsKey('code') || params.containsKey('access_token');
  }

  bool _containsOtpParams(Uri uri) {
    final params = _extractLinkParameters(uri);
    return params.containsKey('token_hash') || params.containsKey('type');
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
  FakeAuthRepository({this.seedEmail, this.seedName = 'Demo User', this.startupSnapshot});

  final String? seedEmail;
  final String seedName;
  final AuthSessionSnapshot? startupSnapshot;
  User? _currentUser;

  final StreamController<AuthSessionSnapshot> _authStateChanges = StreamController<AuthSessionSnapshot>.broadcast();

  @override
  String? get currentUserEmail => _currentUser?.email ?? seedEmail;

  @override
  bool get hasCurrentSession => currentUserEmail != null;

  @override
  Stream<AuthSessionSnapshot> get authStateChanges => _authStateChanges.stream;

  @override
  Future<User?> getCurrentUserProfile() async {
    return _currentUser;
  }

  @override
  Future<AuthSessionSnapshot?> restoreSessionFromIncomingLink() async {
    return startupSnapshot;
  }

  @override
  Future<AuthActionResult> signIn({required String email, required String password}) async {
    _currentUser = _buildUser(email: email, name: seedName, username: email.split('@').first);
    _authStateChanges.add(AuthSessionSnapshot(status: AuthSessionStatus.signedIn, user: _currentUser, email: email));

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
  Future<AuthActionResult> completePasswordReset({required String email, required String resetLink, required String password}) async {
    _currentUser = _currentUser ?? _buildUser(email: email, name: seedName, username: email.split('@').first);
    return AuthActionResult(status: AuthActionStatus.authenticated, user: _currentUser, email: email, messageKey: AppMessageKey.passwordUpdatedSuccessfully);
  }

  @override
  Future<void> resendSignUpConfirmation({required String email}) async {}

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _authStateChanges.add(const AuthSessionSnapshot(status: AuthSessionStatus.signedOut));
  }

  void emitSession(AuthSessionSnapshot snapshot) {
    _authStateChanges.add(snapshot);
  }

  User _buildUser({required String email, required String name, required String username}) {
    final now = DateTime.now();
    return User(id: 1, name: name, email: email, username: username, status: 1, createdAt: now, updatedAt: now);
  }
}