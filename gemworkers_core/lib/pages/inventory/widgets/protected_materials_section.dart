import 'package:flutter/material.dart';

import '../../../core/utils/protected_materials.dart';
import 'inventory_form_widgets.dart';

/// "Protected materials" questions in Add / Edit stone — shown only when the
/// stone's text mentions ivory, coral, shells, fossils, diamonds… The answers
/// are saved with setItemCompliance; the database blocks listing without them
/// (sql/protected_materials.sql).
class ProtectedMaterialsSection extends StatelessWidget {
  final ProtectedFlags flags;
  final String? cites;                 // colour_only | permit | not_protected
  final TextEditingController permitNo;
  final String? diamond;               // colour_only | conflict_free | kimberley
  final TextEditingController kimberleyNo;
  final ValueChanged<String?> onCites;
  final ValueChanged<String?> onDiamond;
  final bool enabled;

  const ProtectedMaterialsSection({
    super.key,
    required this.flags,
    required this.cites,
    required this.permitNo,
    required this.diamond,
    required this.kimberleyNo,
    required this.onCites,
    required this.onDiamond,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!flags.any) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final small = Theme.of(context).textTheme.bodySmall;

    Widget option(String value, String label, {bool on = true}) => RadioListTile<String>(
          value: value,
          enabled: enabled && on,
          title: Text(label),
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
    // Radio groups: one answer per question.
    Widget group(String? value, ValueChanged<String?> onChanged, List<Widget> children) => RadioGroup<String>(
          groupValue: value,
          onChanged: (v) { if (enabled) onChanged(v); },
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
        );

    return Card(
      color: scheme.errorContainer.withValues(alpha: 0.35),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FormSection('Protected materials'),
            Text(
              'This item mentions a material that is protected or controlled by law. '
              'Answer below before listing — your answer is saved with the stone.',
              style: small,
            ),
            const SizedBox(height: 8),
            if (flags.banned || flags.cites) ...[
              if (flags.banned)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Ivory, tortoiseshell and rhino horn can never be sold on GemWorkers.',
                    style: TextStyle(color: scheme.error, fontWeight: FontWeight.w600),
                  ),
                ),
              group(cites, onCites, [
                option('colour_only',
                    'The word only describes a colour or shape (e.g. "ivory white", "coral pink") — the item contains no such material'),
                option('permit', 'It is a protected material (e.g. coral, giant clam, conch) and I have the export permit',
                    on: !flags.banned),
                if (cites == 'permit' && !flags.banned)
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: FormTextField('Export permit number (CITES)', permitNo),
                  ),
                option('not_protected', 'It is a species that is not protected (e.g. common shell, ammonite) — I take responsibility',
                    on: !flags.banned),
              ]),
            ],
            if (flags.diamond) ...[
              const SizedBox(height: 8),
              Text('Diamonds', style: Theme.of(context).textTheme.titleSmall),
              group(diamond, onDiamond, [
                option('conflict_free', 'Natural diamond, conflict-free (Kimberley Process) and NOT of Russian origin'),
                option('kimberley', 'Rough (uncut) diamond with a Kimberley Process certificate'),
                if (diamond == 'kimberley')
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: FormTextField('Kimberley Process certificate number', kimberleyNo),
                  ),
                option('colour_only', 'The word only describes the cut or look (e.g. "diamond cut") — no diamond'),
              ]),
              if (flags.rough && diamond == 'conflict_free')
                Text(
                  'This looks like a rough diamond: rough diamonds can only be sold with a Kimberley certificate.',
                  style: TextStyle(color: scheme.error, fontSize: 13),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
