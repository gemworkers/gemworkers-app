import 'commission.dart';

/// Customs-form details (CN22 / CN23 / courier export form) built from the
/// stone. HS codes are the international 6-digit codes — starting values to
/// check, never authoritative (the US asks 10 digits, the EU 8; carriers add
/// them from the 6-digit code).
class CustomsDetails {
  final String description;
  final String hsCode;
  final String? hsNote;
  final String? netWeight; // e.g. "0.60 g (3.00 ct)"
  final String? originCountry;
  final bool diamond;
  const CustomsDetails({
    required this.description,
    required this.hsCode,
    this.hsNote,
    this.netWeight,
    this.originCountry,
    this.diamond = false,
  });
}

String _clean(Object? v) => v?.toString().trim() ?? '';

bool _has(Object? v) => _clean(v).isNotEmpty;

const _precious = ['ruby', 'sapphire', 'emerald'];

/// [i] = an inventory_items row (map).
CustomsDetails customsDetailsFor(Map<String, dynamic> i) {
  final type = _clean(i['product_type']);
  final gem = _clean(i['gem_type']);
  final variety = _clean(i['variety']);
  final species = _clean(i['species']);
  final metal = _clean(i['metal']).toLowerCase();
  final purity = _clean(i['metal_purity']);
  final jewelryType = _clean(i['jewelry_type']);
  final cutType = _clean(i['cut_type']);
  final shape = _clean(i['shape']);
  final treatment = _clean(i['treatment']).toLowerCase();
  final name = [variety, gem].where((s) => s.isNotEmpty).join(' ').trim();
  final lowerAll = '$gem $variety $species ${_clean(i['title'])}'.toLowerCase();
  final diamond = lowerAll.contains('diamond');
  final pearl = lowerAll.contains('pearl');
  final synthetic = lowerAll.contains('synthetic') || lowerAll.contains('lab-grown') ||
      lowerAll.contains('lab grown') || treatment.contains('synthetic');

  // Net weight: carats → grams (1 ct = 0.2 g), or the grams entered.
  String? weight;
  final wv = parseNumeric(i['weight_value']) ?? 0;
  final wu = _clean(i['weight_unit']).toLowerCase();
  final grams = parseNumeric(i['weight_grams']) ?? parseNumeric(i['total_weight_grams']);
  if (wv > 0 && wu == 'ct') {
    weight = '${(wv * 0.2).toStringAsFixed(2)} g (${wv.toStringAsFixed(2)} ct)';
  } else if (wv > 0) {
    weight = '${wv.toStringAsFixed(2)} $wu';
  } else if (grams != null && grams > 0) {
    weight = '${grams.toStringAsFixed(grams % 1 == 0 ? 0 : 2)} g';
  }

  final origin = _has(i['origin_country']) ? _clean(i['origin_country']) : null;

  // ── Jewellery ──────────────────────────────────────────────────────────────
  if (type == 'jewelry') {
    final piece = jewelryType.isEmpty ? 'jewellery' : jewelryType.toLowerCase();
    final withStone = name.isEmpty ? '' : ' with ${name.toLowerCase()}';
    if (metal.contains('silver')) {
      return CustomsDetails(
        description: 'Silver${purity.isEmpty ? '' : ' ($purity)'} $piece$withStone',
        hsCode: '7113.11', netWeight: weight, originCountry: origin, diamond: diamond);
    }
    if (metal.contains('gold') || metal.contains('platinum')) {
      return CustomsDetails(
        description: '${metal.contains('gold') ? 'Gold' : 'Platinum'}${purity.isEmpty ? '' : ' ($purity)'} $piece$withStone',
        hsCode: '7113.19', netWeight: weight, originCountry: origin, diamond: diamond);
    }
    if (metal.isNotEmpty) {
      return CustomsDetails(
        description: '${_cap(metal)} $piece$withStone',
        hsCode: '7117.19',
        hsNote: 'Base-metal (fashion) jewellery. If it is gold- or silver-plated precious metal, use 7113.20.',
        netWeight: weight, originCountry: origin, diamond: diamond);
    }
    return CustomsDetails(
      description: '${_cap(piece)}$withStone',
      hsCode: '7113 / 7117',
      hsNote: 'Depends on the metal: silver 7113.11, gold 7113.19, other metal 7117.19. Add the metal to the stone in Listings.',
      netWeight: weight, originCountry: origin, diamond: diamond);
  }

  // ── Mineral specimens ──────────────────────────────────────────────────────
  if (type == 'specimen') {
    final what = species.isNotEmpty ? species : (name.isEmpty ? 'mineral' : name);
    final fossil = lowerAll.contains('fossil') || lowerAll.contains('ammonite') || lowerAll.contains('amber');
    return CustomsDetails(
      description: fossil ? 'Fossil specimen: ${what.toLowerCase()}' : 'Natural mineral specimen: ${what.toLowerCase()}',
      hsCode: fossil ? '9705.29' : '2530.90',
      hsNote: fossil
          ? 'Fossils / collectors\' pieces. Some countries restrict fossils — check before shipping.'
          : 'Mineral specimen (crystal / rough, not for jewellery). If it is gem-quality rough, 7103.10 can apply.',
      netWeight: weight, originCountry: origin);
  }

  // ── Loose stones ───────────────────────────────────────────────────────────
  final rough = cutType.toLowerCase().contains('rough') || lowerAll.contains('rough');
  final cutWords = [if (shape.isNotEmpty) shape, if (cutType.isNotEmpty && !rough) cutType].join(', ');
  final state = rough ? 'rough' : 'cut${cutWords.isEmpty ? '' : ' ($cutWords)'}';
  final what = name.isEmpty ? 'gemstone' : name.toLowerCase();

  if (diamond) {
    return CustomsDetails(
      description: '${synthetic ? 'Lab-grown' : 'Natural'} diamond, loose, $state${weight == null ? '' : ', $weight'}',
      hsCode: synthetic ? '7104.21' : (rough ? '7102.31' : '7102.39'),
      hsNote: synthetic
          ? 'Lab-grown diamond.'
          : 'Natural diamonds need a Kimberley Process certificate / warranty statement — check before shipping.',
      netWeight: weight, originCountry: origin, diamond: true);
  }
  if (pearl) {
    return CustomsDetails(
      description: 'Pearl, $what${weight == null ? '' : ', $weight'}',
      hsCode: '7101.22',
      hsNote: 'Cultured pearls (worked). Natural pearls: 7101.10.',
      netWeight: weight, originCountry: origin);
  }
  if (synthetic) {
    return CustomsDetails(
      description: 'Synthetic $what, loose, $state${weight == null ? '' : ', $weight'}',
      hsCode: '7104.99', netWeight: weight, originCountry: origin);
  }
  final isPrecious = _precious.any(lowerAll.contains);
  return CustomsDetails(
    description: 'Natural $what, loose, $state${weight == null ? '' : ', $weight'}',
    hsCode: rough ? '7103.10' : (isPrecious ? '7103.91' : '7103.99'),
    hsNote: !rough && cutWords.isEmpty
        ? 'Assumed cut. If the stone is rough (uncut), use 7103.10.'
        : null,
    netWeight: weight, originCountry: origin);
}

String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
