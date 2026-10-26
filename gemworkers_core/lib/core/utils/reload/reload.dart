/// Reloads the admin page (web). No-op on other platforms.
library;

export 'reload_stub.dart' if (dart.library.js_interop) 'reload_web.dart';
