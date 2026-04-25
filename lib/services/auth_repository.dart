import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  String? get currentUserEmail;

  Future<String?> signIn({required String email, required String password});

  Future<String?> signUp({required String email, required String password});

  Future<void> signOut();
}

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({GoTrueClient? authClient})
      : _authClient = authClient ?? Supabase.instance.client.auth;

  final GoTrueClient _authClient;

  @override
  String? get currentUserEmail => _authClient.currentUser?.email;

  @override
  Future<String?> signIn({required String email, required String password}) async {
    final response = await _authClient.signInWithPassword(
      email: email,
      password: password,
    );

    return response.user?.email ?? email;
  }

  @override
  Future<String?> signUp({required String email, required String password}) async {
    final response = await _authClient.signUp(
      email: email,
      password: password,
    );

    return response.user?.email ?? email;
  }

  @override
  Future<void> signOut() {
    return _authClient.signOut();
  }
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.seedEmail});

  final String? seedEmail;
  String? _currentUserEmail;

  @override
  String? get currentUserEmail => _currentUserEmail ?? seedEmail;

  @override
  Future<String?> signIn({required String email, required String password}) async {
    _currentUserEmail = email;
    return _currentUserEmail;
  }

  @override
  Future<String?> signUp({required String email, required String password}) async {
    _currentUserEmail = email;
    return _currentUserEmail;
  }

  @override
  Future<void> signOut() async {
    _currentUserEmail = null;
  }
}