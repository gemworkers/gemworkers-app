import 'package:flutter/widgets.dart';

export 'turnstile_stub.dart' if (dart.library.js_interop) 'turnstile_web.dart';

/// Lets the parent reset the Turnstile widget (tokens are single-use, so it
/// must be reset after every failed sign-in attempt).
class TurnstileController {
  VoidCallback? _reset;

  /// Called by the widget implementation; not for page code.
  void attach(VoidCallback? reset) => _reset = reset;

  void reset() => _reset?.call();
}
