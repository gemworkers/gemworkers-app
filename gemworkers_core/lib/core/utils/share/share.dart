/// Opens the phone's share menu for a link (web). Returns false when the
/// browser can't share (computers) — then copy the link instead.
library;

export 'share_stub.dart' if (dart.library.js_interop) 'share_web.dart';
