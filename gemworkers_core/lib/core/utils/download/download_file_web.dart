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
