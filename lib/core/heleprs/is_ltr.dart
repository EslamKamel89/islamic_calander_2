import 'package:easy_localization/easy_localization.dart' as EasyLocalization;
import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/globals/globals_var.dart';

bool isEnglish() {
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) return true;
  return context.locale.languageCode != 'ar';
}

TextDirection getTextDirection() {
  return isEnglish() ? TextDirection.ltr : TextDirection.rtl;
}
