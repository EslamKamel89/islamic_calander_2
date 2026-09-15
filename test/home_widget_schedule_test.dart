import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_calander_2/features/home_widget/controller/home_widget_controller.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:islamic_calander_2/features/main_homepage/models/prayers_time_model.dart';

void main() {
  final json =
      jsonDecode(File('test/fixtures/widget_schedule.json').readAsStringSync());
  final days = (json['prayers'] as List)
      .map((day) => PrayersTimeModel.fromJson(Map<String, dynamic>.from(day),
          date: day['date']))
      .toList();

  test('next prayer uses model dates and skips sunrise at exact boundaries',
      () {
    expect(
        nextWidgetPrayer(days, DateTime(2026, 12, 31, 4)).nextPrayer, 'Fajr');
    expect(
        nextWidgetPrayer(days, DateTime(2026, 12, 31, 5)).nextPrayer, 'Dhuhr');
    expect(nextWidgetPrayer(days, DateTime(2026, 12, 31, 19)).nextPrayerTime,
        DateTime(2027, 1, 1, 5, 1));
    expect(nextWidgetPrayer(days, DateTime(2027, 1, 1)).nextPrayer, 'Fajr');
    expect(
        nextWidgetPrayer(days, DateTime(2027, 1, 1, 19, 1)).nextPrayer, isNull);
    expect(
        nextWidgetPrayer(days.reversed.toList(), DateTime(2026, 12, 31, 4))
            .nextPrayerTime,
        DateTime(2026, 12, 31, 5));
  });

  test('invalid dates and times are skipped, timezone suffixes accepted', () {
    expect(widgetPrayerDate('31-02-2026', '05:00'), isNull);
    expect(widgetPrayerDate('01-01-2027', '24:00'), isNull);
    expect(widgetPrayerDate('01-01-2027', '12:60'), isNull);
    expect(widgetPrayerDate(null, null), isNull);
    expect(widgetPrayerDate('01-01-2027', '05:01 (EET)'),
        DateTime(2027, 1, 1, 5, 1));
    expect(
        nextWidgetPrayer([
          PrayersTimeModel(date: '01-01-2027', fajr: 'bad', dhuhr: '12:01')
        ], DateTime(2027, 1, 1))
            .nextPrayer,
        'Dhuhr');
  });

  test('fetches 12 calendar days from today and replaces on repeated fetch',
      () async {
    final requested = <DateTime>[];
    final loader = HomeWidgetScheduleLoader((params) async {
      final date = params.date!;
      requested.add(date);
      return PrayersTimeModel(
          date:
              '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}',
          fajr: '05:00');
    });
    final params = PrayerTimeParams(date: DateTime(2000));
    final first = await loader.load(params, DateTime(2026, 12, 31));
    final second = await loader.load(params, DateTime(2026, 12, 31));
    expect(first, hasLength(12));
    expect(second, hasLength(12));
    expect(requested.first, DateTime(2026, 12, 31));
    expect(requested[11], DateTime(2027, 1, 11));
  });

  test(
      'partial failure retains available dates and total failure does not publish',
      () async {
    final partial = HomeWidgetScheduleLoader(
        (params) async => params.date!.day == 1 ? days.last : null);
    expect(await partial.load(PrayerTimeParams(), DateTime(2027, 1, 1)),
        hasLength(1));
    final failed = HomeWidgetScheduleLoader((_) async => null);
    expect(await failed.load(PrayerTimeParams(), DateTime(2027)), isNull);
    final duplicate = HomeWidgetScheduleLoader((_) async => days.first);
    expect(await duplicate.load(PrayerTimeParams(), DateTime(2026, 12, 31)),
        hasLength(1));
  });

  test('older request cannot publish after a newer request', () async {
    final pending = Completer<PrayersTimeModel?>();
    var calls = 0;
    final loader = HomeWidgetScheduleLoader((_) async {
      if (calls++ == 0) return pending.future;
      return days.last;
    });
    final old = loader.load(PrayerTimeParams(), DateTime(2026, 12, 31));
    final newer = await loader.load(PrayerTimeParams(), DateTime(2027, 1, 1));
    pending.complete(days.first);
    expect(newer!.single.date, '01-01-2027');
    expect(await old, isNull);
  });

  test(
      'storage waits for initialization and writes before reload, serializes date updates',
      () async {
    final initialized = Completer<void>();
    final persisted = Completer<void>();
    final calls = <String>[];
    final writer = HomeWidgetStorageWriter(
      initialize: () async {
        calls.add('init');
        await initialized.future;
      },
      write: (key, value) async {
        calls.add(key);
        await persisted.future;
      },
      reload: () async {
        calls.add('reload');
      },
    );
    final schedule = writer.save({'prayer_schedule': 'schedule'});
    final dates = writer.save({'currentHijri': 'date'});
    await Future<void>.delayed(Duration.zero);
    expect(calls, ['init']);
    initialized.complete();
    await Future<void>.delayed(Duration.zero);
    expect(calls, ['init', 'prayer_schedule']);
    persisted.complete();
    await Future.wait([schedule, dates]);
    expect(calls, [
      'init',
      'prayer_schedule',
      'reload',
      'init',
      'currentHijri',
      'reload'
    ]);
  });

  test('failed storage does not reload and subsequent writes recover',
      () async {
    var fail = true;
    var reloads = 0;
    final writer = HomeWidgetStorageWriter(
      initialize: () async {},
      write: (_, value) async {
        if (fail) throw StateError('write failed');
      },
      reload: () async {
        reloads++;
      },
    );
    await writer.save({'prayer_schedule': 'one'});
    expect(reloads, 0);
    fail = false;
    await writer.save({'prayer_schedule': 'two'});
    expect(reloads, 1);
  });

  test('missing parameters and non-iOS calls do not require plugins', () async {
    await HomeWidgetController.updateHomeWidgetState();
    expect(homeWidgetState.prayers, isEmpty);
  });
}
