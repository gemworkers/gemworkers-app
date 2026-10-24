/// Opens a link in a new browser tab (web admin). No-op on other platforms.
library;

export 'open_url_stub.dart' if (dart.library.js_interop) 'open_url_web.dart';
