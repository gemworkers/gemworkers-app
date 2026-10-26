// Protected materials (sql/protected_materials.sql): which questions a stone
// needs before it can be listed. SAME word lists as public._protected_flags —
// the database makes the final decision; this only shows the questions.

class ProtectedFlags {
  final bool banned;   // ivory, tortoiseshell, rhino
  final bool cites;    // coral, shells, fossils, …
  final bool diamond;
  final bool rough;    // rough / uncut diamond
  const ProtectedFlags({this.banned = false, this.cites = false, this.diamond = false, this.rough = false});

  bool get any => banned || cites || diamond;
}

final _banned = RegExp(r'\b(tortoise|tortoiseshell|hawksbill|rhino)');
final _ivory = RegExp(r'\bivory\b');
final _ivoryOk = RegExp(r'\b(mammoth|fossil|fossili[sz]ed|walrus)\b');
final _cites = RegExp(
    r'\b(coral|corals|conch|clam|clams|tridacna|shell|shells|seashell|seashells|nautilus|'
    r'fossil|fossils|fossili[sz]ed|ammonite|ammonites|mammoth|dinosaur|walrus|abalone)\b');
final _diamond = RegExp(r'\bdiamonds?\b');
final _rough = RegExp(r'(rough|uncut)');
final _roughWord = RegExp(r'\b(rough|uncut)\b');

/// [text]: title, gem type, variety, species, gemstones used, description,
/// jewellery type, matrix. [shape]: shape + cut.
ProtectedFlags protectedFlags({required List<String?> text, required List<String?> shape, String? gemType}) {
  final t = text.whereType<String>().join(' ').toLowerCase();
  final s = shape.whereType<String>().join(' ').toLowerCase();
  final banned = _banned.hasMatch(t) || (_ivory.hasMatch(t) && !_ivoryOk.hasMatch(t));
  final diamond = (gemType ?? '').toLowerCase().startsWith('diamond') ||
      (_diamond.hasMatch(t) && !t.contains('herkimer'));
  return ProtectedFlags(
    banned: banned,
    cites: _cites.hasMatch(t),
    diamond: diamond,
    rough: diamond && (_rough.hasMatch(s) || _roughWord.hasMatch(t)),
  );
}
