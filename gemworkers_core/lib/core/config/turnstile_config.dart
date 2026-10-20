import 'package:flutter/foundation.dart';

/// Cloudflare Turnstile site key (public — safe to ship in the client).
/// Leave empty to disable the check and log in without a captcha token.
const turnstileSiteKey = '0x4AAAAAAFdbCd6e9BB8EVBe';

/// Turnstile only runs on web builds and only when a site key is set.
bool get turnstileEnabled => kIsWeb && turnstileSiteKey.isNotEmpty;
