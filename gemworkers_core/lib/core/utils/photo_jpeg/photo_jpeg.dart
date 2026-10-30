/// Turns a picked photo into the two JPEGs stored on Bunny (sql/media_bunny.sql):
/// the full photo (longest side ≤ 2000 px) and a small card copy (800 px wide)
/// for shop grids. Web admin uses the browser's canvas; other platforms send
/// the original bytes for both.
library;

export 'photo_jpeg_stub.dart' if (dart.library.js_interop) 'photo_jpeg_web.dart';
