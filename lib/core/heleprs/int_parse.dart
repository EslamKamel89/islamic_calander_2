int? intParse(String? input, {int? fallback}) {
  if (input == null) return null;
  final trimmed = input.trim();
  if (trimmed.isEmpty) return fallback;

  final buffer = StringBuffer();
  bool sawSign = false;
  bool sawDigits = false;

  for (final rune in trimmed.runes) {
    if (rune >= 0x30 && rune <= 0x39) {
      buffer.writeCharCode(rune);
      sawDigits = true;
      continue;
    }

    if (rune >= 0x0660 && rune <= 0x0669) {
      final ascii = (rune - 0x0660) + 0x30;
      buffer.writeCharCode(ascii);
      sawDigits = true;
      continue;
    }

    if (rune >= 0x06F0 && rune <= 0x06F9) {
      final ascii = (rune - 0x06F0) + 0x30;
      buffer.writeCharCode(ascii);
      sawDigits = true;
      continue;
    }

    if ((rune == 0x2B || rune == 0x2D) && !sawSign && !sawDigits) {
      buffer.writeCharCode(rune);
      sawSign = true;
      continue;
    }

    if (rune == 0x2E || rune == 0x066B) {
      break;
    }

    if (rune == 0x2C || rune == 0x066C || rune == 0x20 || rune == 0x00A0) {
      continue;
    }

    if (rune == 0x060C) continue;

    break;
  }

  final normalized = buffer.toString();

  if (normalized.isEmpty || normalized == '+' || normalized == '-') {
    return fallback;
  }

  final parsed = int.tryParse(normalized);
  return parsed ?? fallback;
}

extension SafeParseIntExtension on String {
  int? toSafeInt({int? fallback}) => intParse(this, fallback: fallback);
}
