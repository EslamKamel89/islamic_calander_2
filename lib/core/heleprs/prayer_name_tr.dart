import 'package:islamic_calander_2/core/widgets/language_selector.dart';

String prayerNameTr(String prayer) {
  prayer = prayer.toLowerCase().trim();
  final translations = {
    'fajr': ['Fajr', 'الفجر'],
    'sunrise': ['Sunrise', 'الشروق'],
    'dhuhr': ['Dhuhr', 'الظهر'],
    'asr': ['Asr', 'العصر'],
    'sunset': ['Sunset', 'الغروب'],
    'maghrib': ['Maghrib', 'المغرب'],
    'isha': ['Isha', 'العشاء'],
    'imsak': ['Imsak', 'الإمساك'],
    'midnight': ['Midnight', 'منتصف الليل'],
    'firstthird': ['Firstthird', 'الثلث الأول'],
    'lastthird': ['Lastthird', 'الثلث الأخير'],
  };
  return isLTR() ? (translations[prayer]?[0] ?? '') : (translations[prayer]?[1] ?? '');
}
