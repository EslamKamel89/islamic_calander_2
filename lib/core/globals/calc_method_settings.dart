import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/core/static_data/shared_prefrences_key.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<IslamicOrganization> selectedPrayersNotifier =
    ValueNotifier<IslamicOrganization>(selectedPrayersMethod);
IslamicOrganization selectedPrayersMethod = () {
  final sp = serviceLocator<SharedPreferences>();
  final cachedCalcValue = sp.getInt(ShPrefKey.calcPrayerTimeSetting);
  if (cachedCalcValue == null) return IslamicOrganization.muslimWorldLeague;
  return IslamicOrganization.values
      .firstWhere((calcMethod) => calcMethod.value == cachedCalcValue);
}();

void cachePrayerMehtod() {
  selectedPrayersNotifier.addListener(() {
    pr(selectedPrayersNotifier.value.value,
        'Caching prayer caluclation method');
    serviceLocator<SharedPreferences>().setInt(
      ShPrefKey.calcPrayerTimeSetting,
      selectedPrayersNotifier.value.value,
    );
  });
}

Future<void> checkUserCountry() async {
  final t = prt('checkUserCountry');
  try {
    if (positionNotifier.value == null) return;
    pr(positionNotifier.value, '$t - positionNotifier.value');
    final sp = serviceLocator<SharedPreferences>();
    final cachedCalcValue = sp.getInt(ShPrefKey.calcPrayerTimeSetting);
    pr(cachedCalcValue, '$t - cachedCalcValue');
    if (cachedCalcValue != null) return;
    IslamicOrganization? calcMethod = await getPrayerCalcMethodByPosition();
    sp.setInt(ShPrefKey.calcPrayerTimeSetting, calcMethod?.value ?? 3);
    selectedPrayersNotifier.value =
        calcMethod ?? IslamicOrganization.muslimWorldLeague;
  } catch (e) {
    pr("Error occurred during geocoding: $e", 'checkUserCountry');
  }
}

/// Returns JSON-compatible enum names keyed by uppercase ISO country codes.
/// For example: {"US": "islamicSocietyNorthAmerica"}.
/// Replace the fixed data with a backend request and decoding here when ready.
Future<Map<String, String>> fetchPrayerCalculationMethodsByCountry() async {
  return const {
    'US': 'islamicSocietyNorthAmerica',
    'AE': 'dubai',
    'EG': 'egyptianGeneralAuthority',
    'KW': 'kuwait',
    'QA': 'qatar',
    'FR': 'unionOrganizationIslamicDeFrance',
    'MA': 'morocco',
  };
}

Future<IslamicOrganization?> getPrayerCalcMethodByPosition() async {
  final t = prt('getPrayerCalcMethodByPosition');
  try {
    if (positionNotifier.value == null) return null;
    pr(positionNotifier.value, '$t - positionNotifier.value');
    List<Placemark> placemarks = await placemarkFromCoordinates(
        positionNotifier.value!.latitude, positionNotifier.value!.longitude);
    if (placemarks.isEmpty) return null;
    pr(placemarks, '$t - placemarks');
    final countryCode = placemarks.first.isoCountryCode?.trim().toUpperCase();
    if (countryCode == null || countryCode.isEmpty) return null;
    pr(countryCode, '$t - countryCode');
    final methodsByCountry = await fetchPrayerCalculationMethodsByCountry();
    final methodName = methodsByCountry[countryCode];
    final result = IslamicOrganization.values.asNameMap()[methodName];
    return pr(result, '$t - result');
  } catch (e) {
    pr("Error occurred during geocoding: $e", t);
  }
  return null;
}
