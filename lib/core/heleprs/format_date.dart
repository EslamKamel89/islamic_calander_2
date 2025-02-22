import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:islamic_calander_2/core/heleprs/is_ltr.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';

String formateDateToArabic(DateTime dateTime) {
  initializeDateFormatting();
  Intl.defaultLocale = 'en';
  // Intl.initializeDateFormatting

  String formattedDate = DateFormat('EEEE d MMMM y', 'ar_SA').format(dateTime);
  return formattedDate;
}

String formateDateDetailed(DateTime dateTime) {
  initializeDateFormatting();
  Intl.defaultLocale = isEnglish() ? 'en' : 'ar';
  // Intl.initializeDateFormatting

  String formattedDate = DateFormat("EEEE d MMM yyyy").format(dateTime);
  Intl.defaultLocale = 'en';
  return formattedDate;
}

String formateDateEgnlish(DateTime dateTime) {
  initializeDateFormatting();
  Intl.defaultLocale = 'en';
  // Intl.initializeDateFormatting

  String formattedDate = DateFormat('d MMMM y').format(dateTime);
  return formattedDate;
}

String formatDateForApi(DateTime dateTime) {
  String formattedDate = DateFormat('dd-MM-yyyy', 'en').format(dateTime);
  pr(formattedDate);
  return formattedDate;
}
