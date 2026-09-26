import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/api_service/end_points.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
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
    selectedPrayersNotifier.value = calcMethod ?? IslamicOrganization.muslimWorldLeague;
  } catch (e) {
    pr("Error occurred during geocoding: $e", 'checkUserCountry');
  }
}

Future<Map<String, dynamic>>? _inMemoryPrayerCalculationMethodsCache;

Future<Map<String, dynamic>> fetchPrayerCalculationMethodsByCountry() {
  // Share the decoded result with concurrent callers and retain it on success.
  return _inMemoryPrayerCalculationMethodsCache ??=
      _fetchPrayerCalculationMethodsByCountry().catchError((Object e) {
    // Failed requests must not prevent a later retry.
    _inMemoryPrayerCalculationMethodsCache = null;
    String errorMessage = e.toString();
    if (e is DioException) {
      errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occurred');
    }
    showSnackbar('Error', errorMessage, true);
    pr(errorMessage, 'fetchPrayerCalculationMethodsByCountry - errorMessage');
    return <String, dynamic>{};
  });
}

Future<Map<String, dynamic>> _fetchPrayerCalculationMethodsByCountry() async {
  final ApiConsumer api = serviceLocator();
  // The endpoint returns string-encoded JSON, so this decode is intentional.
  final response = jsonDecode(await api.get(EndPoint.prayerCalculationMethod));
  pr(response, 'fetchPrayerCalculationMethodsByCountry - response-raw');
  return Map<String, dynamic>.from(response as Map);
  // return const {
  //   'US': 'islamicSocietyNorthAmerica',
  //   'AE': 'dubai',
  //   'EG': 'egyptianGeneralAuthority',
  //   'KW': 'kuwait',
  //   'QA': 'qatar',
  //   'FR': 'unionOrganizationIslamicDeFrance',
  //   'MA': 'morocco',
  // };
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
    var countryCode = placemarks.first.isoCountryCode?.trim().toUpperCase();
    if (countryCode == null || countryCode.isEmpty) return null;
    // countryCode = 'AE';
    pr(countryCode, '$t - countryCode');
    final methodsByCountry = await fetchPrayerCalculationMethodsByCountry();
    pr(methodsByCountry, '$t - methodsByCountry');
    final methodName = methodsByCountry[countryCode];
    pr(methodName, '$t - methodName');
    final result = IslamicOrganization.values.asNameMap()[methodName];
    return pr(result, '$t - result');
  } catch (e) {
    pr("Error occurred during geocoding: $e", t);
  }
  return null;
}
