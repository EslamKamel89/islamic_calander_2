import 'package:islamic_calander_2/core/heleprs/format_date.dart';

class EndPoint {
  static const String baseUrl = "https://gaztec.org";
  static const String dateConversionEndPoint = "$baseUrl/moon/getdate.php";
  static const String dateConversionLunarEndPoint =
      "$baseUrl/moon/getdatelunar.php";
  static const String dateInfoYearEndPoint = "$baseUrl/moon/getyear.php";
  static const String dateInfoMonthEndPoint = "$baseUrl/moon/getmonth.php";
  static const String getMoonPhaseEndPoint = "$baseUrl/moon/getphase.php";
  static const String getEclipseEndPoint = "$baseUrl/moon/getecllipse.php";
  // https://api.aladhan.com/v1/timings/01-01-2025?latitude=51.5194682&longitude=-0.1360365&method=3&shafaq=general&tune=5%2C3%2C5%2C7%2C9%2C-1%2C0%2C8%2C-6&timezonestring=UTC&calendarMethod=UAQ
  static String prayerTimesEndPoint(DateTime date) =>
      'https://api.aladhan.com/v1/timings/${formatDateForApi(date)}';
}
