import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<({Uint8List full, Uint8List card})> photoJpegs(Uint8List bytes) async {
  final blob = web.Blob([bytes.toJS].toJS);
  final url = web.URL.createObjectURL(blob);
  try {
    final img = web.HTMLImageElement()..src = url;
    await img.decode().toDart;
    final w = img.naturalWidth, h = img.naturalHeight;
    if (w == 0 || h == 0) throw Exception('This photo could not be read');
    final full = await _jpeg(img, w, h, w > h ? 2000 / w : 2000 / h, 0.9);
    final card = await _jpeg(img, w, h, 800 / w, 0.82);
    return (full: full, card: card);
  } finally {
    web.URL.revokeObjectURL(url);
  }
}

// Never enlarges; white background so transparent PNGs don't turn black.
Future<Uint8List> _jpeg(web.HTMLImageElement img, int w, int h, double scale, double quality) async {
  final s = scale < 1 ? scale : 1.0;
  final cw = (w * s).round(), ch = (h * s).round();
  final canvas = web.HTMLCanvasElement()
    ..width = cw
    ..height = ch;
  final ctx = canvas.getContext('2d') as web.CanvasRenderingContext2D;
  ctx.fillStyle = '#ffffff'.toJS;
  ctx.fillRect(0, 0, cw, ch);
  ctx.imageSmoothingQuality = 'high';
  ctx.drawImage(img, 0, 0, cw, ch);
  final done = Completer<Uint8List>();
  canvas.toBlob(
    ((web.Blob? b) {
      if (b == null) {
        done.completeError(Exception('Could not make the JPEG'));
        return;
      }
      b.arrayBuffer().toDart.then((buf) => done.complete(buf.toDart.asUint8List()),
          onError: done.completeError);
    }).toJS,
    'image/jpeg',
    quality.toJS,
  );
  return done.future;
}
