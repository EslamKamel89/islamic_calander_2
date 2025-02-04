import 'dart:async';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/heleprs/get_local_timezone.dart';
import 'package:islamic_calander_2/core/widgets/custom_fading_widget.dart';
import 'package:islamic_calander_2/features/main_homepage/cubits/update_next_prayer_info/update_next_prayer_info_cubit.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';
import 'package:islamic_calander_2/utils/styles/styles.dart';
import 'package:timezone/timezone.dart' as tz;

class AllPraysTimeWidget extends StatefulWidget {
  const AllPraysTimeWidget({
    super.key,
  });

  @override
  State<AllPraysTimeWidget> createState() => _AllPraysTimeWidgetState();
}

class _AllPraysTimeWidgetState extends State<AllPraysTimeWidget> {
  Position? _currentPosition;
  PrayerTimes? _prayerTimes;
  String? _nextPrayer;
  Duration? _timeRemaining;
  String? _currentTimeZone;
  Timer? _timer;
  late UpdateNextPrayerInfoCubit _nextPrayerController;
  @override
  void initState() {
    super.initState();
    _nextPrayerController = context.read<UpdateNextPrayerInfoCubit>();
    determinePosition().then((position) {
      if (position == null) return;
      _currentPosition = position;
      getLocalTimezone().then((localTimeZone) {
        _currentTimeZone = localTimeZone;
        _getPrayerTimes();
        _timer = Timer.periodic(1000.ms, (_) {
          _calculateNextPrayer();
        });
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _getPrayerTimes() {
    if (_currentPosition != null) {
      final coordinates = Coordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );
      final params = CalculationMethod.muslimWorldLeague();
      params.madhab = Madhab.hanafi;

      final date = DateTime.now();
      _prayerTimes = PrayerTimes(
        coordinates: coordinates,
        date: date,
        calculationParameters: params,
        precision: true,
      );
    }
  }

  void _calculateNextPrayer() {
    if (_prayerTimes == null) return;

    final now = DateTime.now();
    final prayers = {
      'Fajr': _prayerTimes!.fajr,
      'Dhuhr': _prayerTimes!.dhuhr,
      'Asr': _prayerTimes!.asr,
      'Maghrib': _prayerTimes!.maghrib,
      'Isha': _prayerTimes!.isha,
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
      _nextPrayer = nextPrayerName;
      _timeRemaining = nextPrayerTime.difference(now);
      _nextPrayerController.update(UpdateNextPrayerInfoState(nextPrayer: _nextPrayer, timeRemaining: _timeRemaining));
    }
    // pr(_nextPrayer, 'next prayer');
    // pr(_timeRemaining, 'time remaining');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        borderRadius: BorderRadius.circular(15.w),
        elevation: 2,
        shadowColor: Colors.grey.withOpacity(0.3),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.w),
            color: Colors.white,
          ),
          child: _prayerTimes != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 5.w),
                    PrayTimeWidget(
                      pray: 'العشاء',
                      imagePath: AssetsData.one,
                      dateTime: _prayerTimes?.fajr,
                      currentTimeZone: _currentTimeZone!,
                    ),
                    PrayTimeWidget(
                      pray: 'المغرب',
                      imagePath: AssetsData.two,
                      dateTime: _prayerTimes?.dhuhr,
                      currentTimeZone: _currentTimeZone!,
                    ),
                    PrayTimeWidget(
                      pray: 'العصر',
                      imagePath: AssetsData.three,
                      dateTime: _prayerTimes?.asr,
                      currentTimeZone: _currentTimeZone!,
                    ),
                    PrayTimeWidget(
                      pray: 'الظهر',
                      imagePath: AssetsData.four,
                      dateTime: _prayerTimes?.maghrib,
                      currentTimeZone: _currentTimeZone!,
                    ),
                    PrayTimeWidget(
                      pray: 'الفجر',
                      imagePath: AssetsData.five,
                      dateTime: _prayerTimes?.isha,
                      currentTimeZone: _currentTimeZone!,
                    ),
                    SizedBox(width: 5.w),
                  ],
                )
              : Container(
                  height: 120.h,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class PrayTimeWidget extends StatelessWidget {
  const PrayTimeWidget(
      {super.key, required this.pray, required this.imagePath, required this.dateTime, required this.currentTimeZone});
  final String pray;
  final DateTime? dateTime;
  final String imagePath;
  final String currentTimeZone;
  @override
  Widget build(BuildContext context) {
    if (dateTime == null) return const SizedBox();
    DateTime localTime = _utcToLocal(dateTime!);
    String amOrpm = 'AM';
    int hour = localTime.hour > 12 ? localTime.hour - 12 : localTime.hour;
    amOrpm = localTime.hour >= 12 ? 'PM' : 'AM';
    String hoursStr = hour.toString().length == 1 ? '0$hour' : hour.toString();
    String minutesStr = localTime.minute.toString().length == 1 ? '0${localTime.minute}' : localTime.minute.toString();

    return SizedBox(
      height: 120.h,
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          txt(pray),
          dateTime == null
              ? CustomFadingWidget(
                  child: _buildImage(),
                )
              : _buildImage(),
          dateTime == null
              ? CustomFadingWidget(child: txt('00:00', e: St.reg14))
              : txt('$hoursStr:$minutesStr\n$amOrpm', e: St.reg14),
        ],
      ),
    );
  }

  DateTime _utcToLocal(DateTime time) {
    final timezone = tz.getLocation(currentTimeZone);
    return tz.TZDateTime.from(time, timezone);
  }

  Container _buildImage() {
    return Container(
      width: 30.w,
      height: 30.w,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: Image.asset(imagePath, fit: BoxFit.fill),
    );
  }
}
