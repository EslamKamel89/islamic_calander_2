import 'dart:async';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/heleprs/get_local_timezone.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/features/main_homepage/cubits/prayer_times_today/prayers_times_today_state.dart';

class PrayersTimesTodayCubit extends Cubit<PrayersTimesTodayState> {
  PrayersTimesTodayCubit() : super(PrayersTimesTodayState(response: ResponseEnum.initial));
  Future getPrayersTimesToday() async {
    final t = prt('getPrayersTimesToday - PrayersTimesTodayCubit');
    emit(state.copyWith(response: ResponseEnum.loading));
    Position? currentPosition = await determinePosition();
    if (currentPosition == null) return pr('currentPosition is null', t);
    String currentTimeZone = await getLocalTimezone();

    final coordinates = Coordinates(
      currentPosition.latitude,
      currentPosition.longitude,
    );
    final params = CalculationMethod.muslimWorldLeague();
    params.madhab = Madhab.hanafi;

    final date = DateTime.now();
    PrayerTimes prayerTimes = PrayerTimes(
      coordinates: coordinates,
      date: date,
      calculationParameters: params,
      precision: true,
    );

    Timer timer = Timer.periodic(1000.ms, (_) {
      _calculateNextPrayer();
    });
    emit(pr(
        state.copyWith(
          currentPosition: currentPosition,
          prayerTimes: prayerTimes,
          currentTimeZone: currentTimeZone,
          timer: timer,
          response: ResponseEnum.success,
        ),
        t));
  }

  void _calculateNextPrayer() {
    if (state.prayerTimes == null) return;

    final now = DateTime.now();
    final prayers = {
      'Fajr': state.prayerTimes!.fajr,
      'Dhuhr': state.prayerTimes!.dhuhr,
      'Asr': state.prayerTimes!.asr,
      'Maghrib': state.prayerTimes!.maghrib,
      'Isha': state.prayerTimes!.isha,
    };

    DateTime? nextPrayerTime;
    String? nextPrayerName;

    for (final entry in prayers.entries) {
      if (entry.value?.isAfter(now) == true) {
        nextPrayerTime = entry.value;
        nextPrayerName = entry.key;
        break;
      }
    }

    if (nextPrayerTime != null && nextPrayerName != null) {
      emit(state.copyWith(
        nextPrayer: nextPrayerName,
        timeRemaining: nextPrayerTime.difference(now),
      ));
    }
    // pr(_nextPrayer, 'next prayer');
    // pr(_timeRemaining, 'time remaining');
  }

  @override
  Future<void> close() {
    state.timer?.cancel();
    return super.close();
  }
}
