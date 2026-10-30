import 'dart:typed_data';

Future<({Uint8List full, Uint8List card})> photoJpegs(Uint8List bytes) async =>
    (full: bytes, card: bytes);
