// ignore_for_file: public_member_api_docs, sort_constructors_first
class PrayersTimeModel {
  String? fajr;
  String? sunrise;
  String? dhuhr;
  String? asr;
  String? sunset;
  String? maghrib;
  String? isha;
  String? imsak;
  String? midnight;
  String? firstthird;
  String? lastthird;
  NextPrayerModel getNextPrayer() {
    DateTime now = DateTime.now();
    DateTime? fajrTime = fajr == null
        ? null
        : now.copyWith(hour: int.parse(fajr!.split(':').first), minute: int.parse(fajr!.split(':').last), second: 0);
    DateTime? dhuhrTime = dhuhr == null
        ? null
        : now.copyWith(hour: int.parse(dhuhr!.split(':').first), minute: int.parse(dhuhr!.split(':').last), second: 0);
    DateTime? asrTime = asr == null
        ? null
        : now.copyWith(hour: int.parse(asr!.split(':').first), minute: int.parse(asr!.split(':').last), second: 0);
    DateTime? maghribTime = maghrib == null
        ? null
        : now.copyWith(
            hour: int.parse(maghrib!.split(':').first), minute: int.parse(maghrib!.split(':').last), second: 0);
    DateTime? ishaTime = isha == null
        ? null
        : now.copyWith(hour: int.parse(isha!.split(':').first), minute: int.parse(isha!.split(':').last), second: 0);
    if (ishaTime != null && now.isAfter(ishaTime)) {
      return NextPrayerModel(nextPrayer: 'Fajr');
    }
    if (maghribTime != null && now.isAfter(maghribTime)) {
      return NextPrayerModel(nextPrayer: 'Isha', nextPrayerTime: ishaTime);
    }
    if (asrTime != null && now.isAfter(asrTime)) {
      return NextPrayerModel(nextPrayer: 'Maghrib', nextPrayerTime: maghribTime);
    }
    if (dhuhrTime != null && now.isAfter(dhuhrTime)) {
      return NextPrayerModel(nextPrayer: 'Asr', nextPrayerTime: asrTime);
    }
    if (fajrTime != null && now.isAfter(fajrTime)) {
      return NextPrayerModel(nextPrayer: 'Dhuhr', nextPrayerTime: dhuhrTime);
    }
    return NextPrayerModel(nextPrayer: 'Error');
  }

  DateTime? fajrDateTime() {
    DateTime now = DateTime.now();
    DateTime? fajrTime = fajr == null
        ? null
        : now.copyWith(hour: int.parse(fajr!.split(':').first), minute: int.parse(fajr!.split(':').last), second: 0);
    return fajrTime;
  }

  PrayersTimeModel({
    this.fajr,
    this.sunrise,
    this.dhuhr,
    this.asr,
    this.sunset,
    this.maghrib,
    this.isha,
    this.imsak,
    this.midnight,
    this.firstthird,
    this.lastthird,
  });

  @override
  String toString() {
    return 'PrayersTimeModel(fajr: $fajr, sunrise: $sunrise, dhuhr: $dhuhr, asr: $asr, sunset: $sunset, maghrib: $maghrib, isha: $isha, imsak: $imsak, midnight: $midnight, firstthird: $firstthird, lastthird: $lastthird)';
  }

  factory PrayersTimeModel.fromJson(Map<String, dynamic> json) {
    return PrayersTimeModel(
      fajr: json['Fajr'] as String?,
      sunrise: json['Sunrise'] as String?,
      dhuhr: json['Dhuhr'] as String?,
      asr: json['Asr'] as String?,
      sunset: json['Sunset'] as String?,
      maghrib: json['Maghrib'] as String?,
      isha: json['Isha'] as String?,
      imsak: json['Imsak'] as String?,
      midnight: json['Midnight'] as String?,
      firstthird: json['Firstthird'] as String?,
      lastthird: json['Lastthird'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'Fajr': fajr,
        'Sunrise': sunrise,
        'Dhuhr': dhuhr,
        'Asr': asr,
        'Sunset': sunset,
        'Maghrib': maghrib,
        'Isha': isha,
        'Imsak': imsak,
        'Midnight': midnight,
        'Firstthird': firstthird,
        'Lastthird': lastthird,
      };
}

class NextPrayerModel {
  String? nextPrayer;
  DateTime? nextPrayerTime;
  NextPrayerModel({
    this.nextPrayer,
    this.nextPrayerTime,
  });

  @override
  String toString() => 'NextPrayerModel(nextPrayer: $nextPrayer, nextPrayerTime: $nextPrayerTime)';
}
