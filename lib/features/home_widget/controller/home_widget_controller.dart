import 'dart:convert';
import 'dart:io';

import 'package:home_widget/home_widget.dart';
import 'package:islamic_calander_2/core/heleprs/format_date.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/prayers_controller.dart';
import 'package:islamic_calander_2/features/main_homepage/models/prayers_time_model.dart';

/// Parses a model's own local calendar date, never the current day's date.
DateTime? widgetPrayerDate(String? date, String? time) {
  final d = RegExp(r'^(\d{2})-(\d{2})-(\d{4})$').firstMatch(date ?? '');
  final t = RegExp(r'^(\d{1,2}):(\d{2})(?:\s+\([^)]*\))?$').firstMatch(time?.trim() ?? '');
  if (d == null || t == null) return null;
  final day = int.parse(d[1]!);
  final month = int.parse(d[2]!);
  final year = int.parse(d[3]!);
  final hour = int.parse(t[1]!);
  final minute = int.parse(t[2]!);
  if (hour > 23 || minute > 59) return null;
  final result = DateTime(year, month, day, hour, minute);
  return result.year == year &&
          result.month == month &&
          result.day == day &&
          result.hour == hour &&
          result.minute == minute
      ? result
      : null;
}

NextPrayerModel nextWidgetPrayer(List<PrayersTimeModel> prayers, DateTime now) {
  final result = NextPrayerModel();
  for (final day in prayers) {
    for (final prayer in {
      'Fajr': day.fajr,
      'Dhuhr': day.dhuhr,
      'Asr': day.asr,
      'Maghrib': day.maghrib,
      'Isha': day.isha
    }.entries) {
      final date = widgetPrayerDate(day.date, prayer.value);
      if (date != null &&
          date.isAfter(now) &&
          (result.nextPrayerTime == null || date.isBefore(result.nextPrayerTime!))) {
        result.nextPrayer = prayer.key;
        result.nextPrayerTime = date;
      }
    }
  }
  return result;
}

class HomeWidgetState {
  final List<PrayersTimeModel> prayers;
  final String? greogrianDate;
  final String? currentHijri;
  final String? newHijri;
  HomeWidgetState(
      {List<PrayersTimeModel> prayers = const [],
      this.greogrianDate,
      this.currentHijri,
      this.newHijri})
      : prayers = List.unmodifiable(prayers);

  // Derived on access so these values cannot become stale while Dart is running.
  String? get nextPrayer => nextWidgetPrayer(prayers, DateTime.now()).nextPrayer;
  DateTime? get nextPrayerTime => nextWidgetPrayer(prayers, DateTime.now()).nextPrayerTime;

  HomeWidgetState copyWith(
          {List<PrayersTimeModel>? prayers,
          String? greogrianDate,
          String? currentHijri,
          String? newHijri}) =>
      HomeWidgetState(
          prayers: prayers ?? this.prayers,
          greogrianDate: greogrianDate ?? this.greogrianDate,
          currentHijri: currentHijri ?? this.currentHijri,
          newHijri: newHijri ?? this.newHijri);
}

var homeWidgetState = HomeWidgetState();

/// Isolated fetch coordinator: a completed newer request always wins.
class HomeWidgetScheduleLoader {
  final Future<PrayersTimeModel?> Function(PrayerTimeParams) fetch;
  int _generation = 0;
  HomeWidgetScheduleLoader(this.fetch);

  Future<List<PrayersTimeModel>?> load(PrayerTimeParams params, DateTime now) async {
    final generation = ++_generation;
    final days = <String, PrayersTimeModel>{};
    for (var i = 0; i < 12; i++) {
      if (generation != _generation) return null;
      final date = DateTime(now.year, now.month, now.day + i);
      try {
        final model = await fetch(params.copyWith(date: date));
        if (model != null && widgetPrayerDate(model.date, '00:00') != null) {
          days[model.date!] = model;
        }
      } catch (error) {
        pr(error, 'HomeWidgetScheduleLoader');
      }
    }
    if (generation != _generation || days.isEmpty) return null;
    return days.values.toList()
      ..sort((a, b) =>
          widgetPrayerDate(a.date, '00:00')!.compareTo(widgetPrayerDate(b.date, '00:00')!));
  }
}

/// Keeps schedule and date writes ordered, and reloads only after persistence.
class HomeWidgetStorageWriter {
  final Future<void> Function() initialize;
  final Future<void> Function(String, String) write;
  final Future<void> Function() reload;
  Future<void> _pending = Future.value();

  HomeWidgetStorageWriter({required this.initialize, required this.write, required this.reload});

  Future<void> save(Map<String, String> values) {
    final snapshot = Map<String, String>.of(values);
    _pending = _pending.then((_) async {
      await initialize();
      for (final entry in snapshot.entries) {
        await write(entry.key, entry.value);
      }
      await reload();
    }).catchError((Object error) {
      pr(error, 'HomeWidgetStorageWriter');
    });
    return _pending;
  }
}

class HomeWidgetController {
  static const appGroupId = 'group.islamicwidget';
  static const iosWidgetName = 'IslamicWidget';
  static PrayerTimeParams? prayerParams;
  static final _loader = HomeWidgetScheduleLoader(
      (params) async => (await serviceLocator<PrayersController>().prayerTime(params)).data);
  static final _writer = HomeWidgetStorageWriter(
    initialize: () async {
      await HomeWidget.setAppGroupId(appGroupId);
    },
    write: (key, value) async {
      await HomeWidget.saveWidgetData<String>(key, value);
    },
    reload: () async {
      await HomeWidget.updateWidget(iOSName: iosWidgetName);
    },
  );

  static Future<void> _save(Map<String, String> values) => _writer.save(values);

  static Future<void> updateHomeWidgetState({PrayerTimeParams? params}) async {
    if (!Platform.isIOS) return;
    if (params != null) prayerParams = params.copyWith();
    final effective = prayerParams?.copyWith();
    if (effective?.latitude == null || effective?.longitude == null) return;
    final prayers = await _loader.load(effective!, DateTime.now());
    if (prayers == null) return;
    homeWidgetState = homeWidgetState.copyWith(prayers: prayers);
    await _save({
      'prayer_schedule': jsonEncode({
        'version': 1,
        'prayers': prayers.map((day) => day.toJson()).toList(),
      })
    });
  }

  static Future<void> updateHomeWidgetHijriDate(String? currentHijri, String? newHijri) async {
    if (!Platform.isIOS) return;
    homeWidgetState = homeWidgetState.copyWith(
        greogrianDate: formateDateEgnlish(DateTime.now()),
        currentHijri: currentHijri,
        newHijri: newHijri);
    await _save({
      'gerogrianDate': homeWidgetState.greogrianDate?.trim() ?? '',
      'currentHijri': homeWidgetState.currentHijri?.trim() ?? '',
      'newHijri': homeWidgetState.newHijri?.trim().replaceAll('I', '') ?? '',
    });
  }
}
