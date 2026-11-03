const _bengaliDigits = '০১২৩৪৫৬৭৮৯';

/// Converts Bengali (Bangla) numerals to ASCII digits so numeric parsing
/// works regardless of which digit script the user typed in.
String toAsciiDigits(String input) {
  final buf = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    final i = _bengaliDigits.indexOf(ch);
    buf.write(i == -1 ? ch : i.toString());
  }
  return buf.toString();
}

num? parseLocaleNum(String input) {
  final t = toAsciiDigits(input).trim();
  return t.isEmpty ? null : num.tryParse(t);
}

/// Converts ASCII digits to Bengali numerals, for display.
String toBanglaDigits(String input) {
  const bn = '০১২৩৪৫৬৭৮৯';
  final buf = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    final i = '0123456789'.indexOf(ch);
    buf.write(i == -1 ? ch : bn[i]);
  }
  return buf.toString();
}
