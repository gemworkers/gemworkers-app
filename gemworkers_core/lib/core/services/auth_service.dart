import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static SupabaseClient get _client => Supabase.instance.client;

  // TODO remove before production — allows testing without a Supabase account.
  static final ValueNotifier<bool> devBypass = ValueNotifier(false);

  /// Returns null on success, or a human-readable error message on failure.
  static Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
      return null;
    } on AuthException catch (e) {
      return _friendlyError(e.message);
    } catch (_) {
      return 'Network error. Check your connection and try again.';
    }
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  static User? get currentUser => _client.auth.currentUser;

  static String? get currentUserEmail => _client.auth.currentUser?.email;

  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  static String _friendlyError(String raw) {
    final msg = raw.toLowerCase();
    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid email or password')) {
      return 'Incorrect email or password.';
    }
    if (msg.contains('email not confirmed')) {
      return 'Please confirm your email address before signing in.';
    }
    if (msg.contains('too many requests') || msg.contains('rate limit')) {
      return 'Too many sign-in attempts. Wait a moment and try again.';
    }
    return raw;
  }
}
