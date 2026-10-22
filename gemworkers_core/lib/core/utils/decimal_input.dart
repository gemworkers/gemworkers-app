/// Parses a typed decimal (weight, size, cost). Decimal keyboards in NL show
/// "," instead of ".", so "2,35" and "2.35" both give 2.35. Null if empty or
/// not a number.
double? parseDecimalInput(String input) =>
    double.tryParse(input.trim().replaceAll(',', '.'));
