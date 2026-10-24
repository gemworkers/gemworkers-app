/// Saves a text file to the user's computer (web admin). No-op elsewhere.
library;

export 'download_file_stub.dart' if (dart.library.js_interop) 'download_file_web.dart';
