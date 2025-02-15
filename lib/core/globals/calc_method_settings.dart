import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/core/static_data/shared_prefrences_key.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<IslamicOrganization> selectedPrayersNotifier = ValueNotifier<IslamicOrganization>(selectedPrayersMethod);
IslamicOrganization selectedPrayersMethod = () {
  final sp = serviceLocator<SharedPreferences>();
  final cachedCalcValue = sp.getInt(ShPrefKey.calcPrayerTimeSetting);
  if (cachedCalcValue == null) return IslamicOrganization.muslimWorldLeague;
  return IslamicOrganization.values.firstWhere((calcMethod) => calcMethod.value == cachedCalcValue);
}();

void cachePrayerMehtod() {
  selectedPrayersNotifier.addListener(() {
    pr(selectedPrayersNotifier.value.value, 'Caching prayer caluclation method');
    serviceLocator<SharedPreferences>().setInt(
      ShPrefKey.calcPrayerTimeSetting,
      selectedPrayersNotifier.value.value,
    );
  });
}
