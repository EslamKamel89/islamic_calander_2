// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'prayer_time_by_position_cubit.dart';

class PrayerTimeByPositionState {
  LatLng? position;
  PrayerTimes? prayerTimes;
  String? currentTimeZone;
  ResponseEnum? response;
  PrayerTimeByPositionState({
    this.position,
    this.prayerTimes,
    this.currentTimeZone,
    this.response,
  });

  @override
  String toString() {
    return 'PrayerTimeByPositionState(position: $position, prayerTimes: $prayerTimes, currentTimeZone: $currentTimeZone, response: $response)';
  }

  PrayerTimeByPositionState copyWith({
    LatLng? position,
    PrayerTimes? prayerTimes,
    String? currentTimeZone,
    ResponseEnum? response,
  }) {
    return PrayerTimeByPositionState(
      position: position ?? this.position,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      currentTimeZone: currentTimeZone ?? this.currentTimeZone,
      response: response ?? this.response,
    );
  }
}
