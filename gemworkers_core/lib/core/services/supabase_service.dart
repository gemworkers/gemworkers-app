import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl =
      'https://cvqzidqnwthzfodhzepz.supabase.co';

  static const String supabaseKey =
      'sb_publishable__4htrYdFPPYqB7U9voroCg_qNlJKfuS';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabaseKey,
    );
  }

  static SupabaseClient get client =>
      Supabase.instance.client;
}