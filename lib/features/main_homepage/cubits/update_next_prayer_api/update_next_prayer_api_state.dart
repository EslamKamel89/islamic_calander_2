// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'update_next_prayer_api_cubit.dart';

class UpdateNextPrayerApiState {
  String? nextPrayer;
  Duration? timeRemaining;
  DateTime? nextPrayerTime;
  PrayersTimeModel? prayerTimeModel;
  ResponseEnum? response;
  UpdateNextPrayerApiState({
    this.nextPrayer,
    this.timeRemaining,
    this.nextPrayerTime,
    this.prayerTimeModel,
    this.response,
  });

  UpdateNextPrayerApiState copyWith({
    String? nextPrayer,
    Duration? timeRemaining,
    DateTime? nextPrayerTime,
    PrayersTimeModel? prayerTimeModel,
    ResponseEnum? response,
  }) {
    return UpdateNextPrayerApiState(
      nextPrayer: nextPrayer ?? this.nextPrayer,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
      prayerTimeModel: prayerTimeModel ?? this.prayerTimeModel,
      response: response ?? this.response,
    );
  }

  @override
  String toString() {
    return 'UpdateNextPrayerApiState(nextPrayer: $nextPrayer, timeRemaining: $timeRemaining, nextPrayerTime: $nextPrayerTime, prayerTimeModel: $prayerTimeModel, response: $response)';
  }
}
