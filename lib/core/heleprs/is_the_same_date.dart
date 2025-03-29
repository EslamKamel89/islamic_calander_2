bool isSameDate(DateTime? a, DateTime? b) {
  if ([a, b].contains(null)) return false;
  return a!.year == b!.year && a.month == b.month && a.day == b.day;
}
