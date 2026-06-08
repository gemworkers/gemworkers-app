import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static SupabaseClient get _client => Supabase.instance.client;

  // Remove this before shipping. Allows testing without a Supabase account.
  static final ValueNotifier<bool> devBypass = ValueNotifier(false);

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  static User? get currentUser => _client.auth.currentUser;

  static String? get currentUserEmail => _client.auth.currentUser?.email;

  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;
}
