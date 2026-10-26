import 'dart:js_interop';

import 'package:web/web.dart' as web;

Future<bool> shareLink(String url, String title) async {
  try {
    final data = web.ShareData(title: title, text: '$title — GemWorkers', url: url);
    if (!web.window.navigator.canShare(data)) return false;
    await web.window.navigator.share(data).toDart;
    return true;
  } catch (_) {
    return false;   // cancelled or not supported
  }
}
