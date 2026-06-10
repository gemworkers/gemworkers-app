import 'package:flutter/foundation.dart';

import 'seller_service.dart';
import '../../models/user_profile.dart';
import '../../repositories/user_profile_repository.dart';

enum AppAuthState { initial, loading, ready, noProfile }

class UserProfileService {
  static final UserProfileService instance = UserProfileService._();
  UserProfileService._();

  final ValueNotifier<AppAuthState> appState =
      ValueNotifier(AppAuthState.initial);

  UserProfile? _profile;
  String? _loadedUserId;

  UserProfile? get profile => _profile;
  String? get loadedUserId => _loadedUserId;

  // null profile in ready state means dev bypass → treat as owner
  bool get isOwner => _profile == null || _profile!.role == 'owner';
  bool get isSeller => _profile?.role == 'seller';
  String? get sellerId => _profile?.sellerId;

  // For inserts: seller's own seller_id, or kCurrentSellerId for owner/dev.
  String get effectiveSellerId => _profile?.sellerId ?? kCurrentSellerId;

  bool get shouldFilterBySeller => isSeller && _profile?.sellerId != null;

  // Called when dev bypass is activated.
  void setDevOwner() {
    _profile = null;
    _loadedUserId = null;
    appState.value = AppAuthState.ready;
  }

  Future<void> loadForUser(String userId) async {
    // Skip if we already loaded this user's profile successfully.
    if (_loadedUserId == userId && appState.value == AppAuthState.ready) return;
    _loadedUserId = userId;
    appState.value = AppAuthState.loading;
    try {
      _profile = await UserProfileRepository().getProfile(userId);
      appState.value =
          _profile != null ? AppAuthState.ready : AppAuthState.noProfile;
    } catch (_) {
      _profile = null;
      appState.value = AppAuthState.noProfile;
    }
  }

  void clear() {
    _profile = null;
    _loadedUserId = null;
    appState.value = AppAuthState.initial;
  }
}
