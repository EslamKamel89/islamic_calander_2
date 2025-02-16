import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
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

Future<void> checkUserCountry() async {
  // final t = prt('checkUserCountry');
  try {
    if (positionNotifier.value == null) return;
    // pr(positionNotifier.value, '$t - positionNotifier.value');
    final sp = serviceLocator<SharedPreferences>();
    final cachedCalcValue = sp.getInt(ShPrefKey.calcPrayerTimeSetting);
    if (cachedCalcValue != null) return;
    // pr(cachedCalcValue, '$t - cachedCalcValue');
    List<Placemark> placemarks =
        await placemarkFromCoordinates(positionNotifier.value!.latitude, positionNotifier.value!.longitude);
    if (placemarks.isEmpty) return;
    // pr(placemarks, '$t - placemarks');
    String? country = placemarks.first.country;
    if (country == null) return;
    // pr(country, '$t - country');
    final userCountry = country.toLowerCase();
    final monitoredCountries = [
      'united states of america',
      'united states',
      'united arab emirates',
      'egypt',
      // 'saudi arabia',
      'kuwait',
      'qatar',
      'france',
      'morocco',
    ];
    if (!monitoredCountries.contains(userCountry)) return;
    // pr('country found', t);
    switch (country) {
      case 'united states of america':
        sp.setInt(ShPrefKey.calcPrayerTimeSetting, IslamicOrganization.islamicSocietyNorthAmerica.value);
        selectedPrayersNotifier.value = IslamicOrganization.islamicSocietyNorthAmerica;
        break;
      case 'united states':
        sp.setInt(ShPrefKey.calcPrayerTimeSetting, IslamicOrganization.islamicSocietyNorthAmerica.value);
        selectedPrayersNotifier.value = IslamicOrganization.islamicSocietyNorthAmerica;
        break;
      case 'united arab emirates':
        sp.setInt(ShPrefKey.calcPrayerTimeSetting, IslamicOrganization.dubai.value);
        selectedPrayersNotifier.value = IslamicOrganization.dubai;
        break;
      case 'egypt':
        sp.setInt(ShPrefKey.calcPrayerTimeSetting, IslamicOrganization.egyptianGeneralAuthority.value);
        selectedPrayersNotifier.value = IslamicOrganization.egyptianGeneralAuthority;
        break;
      case 'kuwait':
        sp.setInt(ShPrefKey.calcPrayerTimeSetting, IslamicOrganization.kuwait.value);
        selectedPrayersNotifier.value = IslamicOrganization.kuwait;
        break;
      case 'qatar':
        sp.setInt(ShPrefKey.calcPrayerTimeSetting, IslamicOrganization.qatar.value);
        selectedPrayersNotifier.value = IslamicOrganization.qatar;
        break;
      case 'france':
        sp.setInt(ShPrefKey.calcPrayerTimeSetting, IslamicOrganization.unionOrganizationIslamicDeFrance.value);
        selectedPrayersNotifier.value = IslamicOrganization.unionOrganizationIslamicDeFrance;
        break;
      case 'morocco':
        sp.setInt(ShPrefKey.calcPrayerTimeSetting, IslamicOrganization.morocco.value);
        selectedPrayersNotifier.value = IslamicOrganization.morocco;
        break;
    }
  } catch (e) {
    pr("Error occurred during geocoding: $e", 'checkUserCountry');
  }
}
