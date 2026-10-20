import 'package:flutter/widgets.dart';

import 'turnstile_widget.dart';

/// Non-web builds: Turnstile is unavailable, so render nothing.
class TurnstileWidget extends StatelessWidget {
  const TurnstileWidget({
    super.key,
    required this.siteKey,
    required this.controller,
    required this.onToken,
  });

  final String siteKey;
  final TurnstileController controller;

  /// Receives a fresh token, or null when it expires / errors / is reset.
  final ValueChanged<String?> onToken;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
