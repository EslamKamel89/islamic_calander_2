import 'package:timezone/timezone.dart' as tz;

DateTime utcToLocal(DateTime time, String currentTimeZone) {
  final timezone = tz.getLocation(currentTimeZone);
  return tz.TZDateTime.from(time, timezone);
}
