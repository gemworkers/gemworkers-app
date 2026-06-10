import 'package:flutter/material.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/user_profile_service.dart';

class NoProfilePage extends StatelessWidget {
  const NoProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final email = AuthService.currentUserEmail ?? '';

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.manage_accounts_outlined,
                    size: 72, color: Colors.grey.shade400),
                const SizedBox(height: 24),
                Text(
                  'Account not set up yet',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  email.isNotEmpty
                      ? 'Signed in as $email.\n\nYour account exists but has no profile. Ask the owner to add your profile in Supabase.'
                      : 'Your account has no profile. Ask the owner to set it up.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 32),
                OutlinedButton.icon(
                  onPressed: () async {
                    UserProfileService.instance.clear();
                    await AuthService.signOut();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
