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

/// True on phones/tablets, where the share menu (Instagram, TikTok, YouTube…) exists.
bool get canShareFiles {
  final ua = web.window.navigator.userAgent;
  return RegExp(r'Android|iPhone|iPad|Mobi').hasMatch(ua);
}

/// Step 1 (may take a few seconds): fetch the video into memory as a file.
Future<Object> fetchFileForShare(String url, String filename) async {
  final res = await web.window.fetch(url.toJS).toDart;
  if (!res.ok) throw Exception('download failed (${res.status})');
  final blob = await res.blob().toDart;
  return web.File([blob].toJS, filename, web.FilePropertyBag(type: 'video/mp4'));
}

/// Step 2 (a fresh tap, so the phone allows it): open the phone's share menu.
/// Returns false when this phone can't share files (then download instead).
Future<bool> shareFile(Object file) async {
  final f = file as web.File;
  final data = web.ShareData(files: [f].toJS);
  if (!web.window.navigator.canShare(data)) return false;
  try {
    await web.window.navigator.share(data).toDart;
  } catch (_) {
    // Closing the share menu without choosing an app also lands here.
  }
  return true;
}

/// Saves an already-fetched file (fallback when sharing isn't possible).
void saveFile(Object file) {
  final f = file as web.File;
  final href = web.URL.createObjectURL(f);
  final a = web.HTMLAnchorElement()
    ..href = href
    ..download = f.name;
  web.document.body?.append(a);
  a.click();
  a.remove();
  web.URL.revokeObjectURL(href);
}
