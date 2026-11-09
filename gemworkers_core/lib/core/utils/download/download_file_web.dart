import 'dart:js_interop';

import 'package:web/web.dart' as web;

void downloadTextFile(String filename, String content, {String mime = 'text/csv'}) {
  // BOM so Excel opens UTF-8 (€, accents) correctly.
  final blob = web.Blob(['﻿$content'.toJS].toJS, web.BlobPropertyBag(type: '$mime;charset=utf-8'));
  final url = web.URL.createObjectURL(blob);
  final a = web.HTMLAnchorElement()
    ..href = url
    ..download = filename;
  web.document.body?.append(a);
  a.click();
  a.remove();
  web.URL.revokeObjectURL(url);
}

/// Downloads a file from a link (e.g. a stone's Bunny video) and saves it.
/// The request carries this site's referrer, so Bunny's hotlink rule allows it.
Future<void> downloadUrlFile(String url, String filename) async {
  final res = await web.window.fetch(url.toJS).toDart;
  if (!res.ok) throw Exception('download failed (${res.status})');
  final blob = await res.blob().toDart;
  final href = web.URL.createObjectURL(blob);
  final a = web.HTMLAnchorElement()
    ..href = href
    ..download = filename;
  web.document.body?.append(a);
  a.click();
  a.remove();
  web.URL.revokeObjectURL(href);
}
