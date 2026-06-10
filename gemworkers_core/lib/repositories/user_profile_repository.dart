import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';

class UserProfileRepository {
  final _supabase = Supabase.instance.client;

  Future<UserProfile?> getProfile(String userId) async {
    final response = await _supabase
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (response == null) return null;
    return UserProfile.fromMap(response);
  }
}
