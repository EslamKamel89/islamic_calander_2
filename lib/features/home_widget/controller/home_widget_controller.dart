// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:home_widget/home_widget.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/heleprs/format_date.dart';
import 'package:islamic_calander_2/core/heleprs/int_parse.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/prayers_controller.dart';
import 'package:islamic_calander_2/features/main_homepage/models/prayers_time_model.dart';

class HomeWidgetController {
  static const String t = 'HomeWidgetController';
  static const String appGroupId = 'group.islamicwidget';
  // static const String androidWidgetName = 'IslamicWidget';
  static const String iosWidgetName = 'IslamicWidget';

  static void syncHomeWidgetState(HomeWidgetState state) {
    // return;
    HomeWidget.setAppGroupId(appGroupId);
    pr(state, t);
    HomeWidget.saveWidgetData(
      'data',
      state.prayers,
    );
    HomeWidget.saveWidgetData(
      'gerogrianDate',
      state.greogrianDate?.trim() ?? '',
    );
    HomeWidget.saveWidgetData(
      'currentHijri',
      state.currentHijri?.trim() ?? '',
    );
    HomeWidget.saveWidgetData(
      'newHijri',
      // 'hello world',
      state.newHijri?.trim().replaceAll('I', '') ?? '',
    );
    HomeWidget.saveWidgetData('nextPrayer', state.nextPrayer);
    HomeWidget.saveWidgetData('nextPrayerTime', state.nextPrayerTime);
    HomeWidget.updateWidget(
      iOSName: iosWidgetName,
      //  androidName: androidWidgetName
    );
  }

  static void updateHomeWidgetPrayersTime(PrayersTimeModel? model) {
    if (model == null) return;
    homeWidgetState = homeWidgetState.copyWith(
        prayers:
            "${_formatDateTime(model.fajr)},${_formatDateTime(model.sunrise)},${_formatDateTime(model.dhuhr)},${_formatDateTime(model.asr)},${_formatDateTime(model.maghrib)},${_formatDateTime(model.isha)}");
    syncHomeWidgetState(homeWidgetState);
  }

  static void updateNextPrayer(String? nextPrayer, String? timeLeft) {
    homeWidgetState = homeWidgetState.copyWith(nextPrayer: nextPrayer, nextPrayerTime: timeLeft);
    syncHomeWidgetState(homeWidgetState);
  }

  static void updateHomeWidgetHijriDate(String? currnentHijri, String? newHijri) {
    homeWidgetState = homeWidgetState.copyWith(
      greogrianDate: formateDateEgnlish(DateTime.now()),
      currentHijri: currnentHijri,
      newHijri: newHijri,
    );
    syncHomeWidgetState(homeWidgetState);
  }

  static void getPrayerTimes() {
    positionNotifier.addListener(() async {
      // pr('listener in HomeWidgetController is called because position is changed: ${positionNotifier.value}');
      if (positionNotifier.value == null) return;
      final params = PrayerTimeParams(
        latitude: positionNotifier.value!.latitude,
        longitude: positionNotifier.value!.longitude,
        method: IslamicOrganization.muslimWorldLeague,
        latitudeAdjustmentMethod: LatitudeAdjustmentMethod.angleBased,
        date: DateTime.now(),
      );
      final prayersResponse = await serviceLocator<PrayersController>().prayerTime(params);
      if (prayersResponse.response != ResponseEnum.success) return;
      // pr(prayersResponse.data, t);

      updateHomeWidgetPrayersTime(prayersResponse.data);
    });
  }

  static String? _formatDateTime(String? time) {
    if (time == null) return null;
    String? amOrpm;
    String? hourStr = time.split(':').first;
    String? minStr = time.split(':').last;
    if ([hourStr, minStr, time].contains(null)) {
      return null;
    }
    int? hour = intParse(hourStr);
    amOrpm = hour != null && hour >= 12 ? 'PM' : 'AM';
    hour = hour == null
        ? null
        : hour > 12
            ? hour - 12
            : hour;
    return '${hour.toString().padLeft(2, '0')}:$minStr\n$amOrpm\n';
  }
}

var homeWidgetState = HomeWidgetState();

class HomeWidgetState {
  final String? prayers;
  final String? greogrianDate;
  final String? currentHijri;
  final String? newHijri;
  final String? nextPrayer;
  final String? nextPrayerTime;
  HomeWidgetState({
    this.prayers,
    this.greogrianDate,
    this.currentHijri,
    this.newHijri,
    this.nextPrayer,
    this.nextPrayerTime,
  });

  HomeWidgetState copyWith({
    String? prayers,
    String? greogrianDate,
    String? currentHijri,
    String? newHijri,
    String? nextPrayer,
    String? nextPrayerTime,
  }) {
    return HomeWidgetState(
      prayers: prayers ?? this.prayers,
      greogrianDate: greogrianDate ?? this.greogrianDate,
      currentHijri: currentHijri ?? this.currentHijri,
      newHijri: newHijri ?? this.newHijri,
      nextPrayer: nextPrayer ?? this.nextPrayer,
      nextPrayerTime: nextPrayerTime ?? this.nextPrayerTime,
    );
  }

  @override
  String toString() {
    return 'HomeWidgetState(prayers: $prayers, greogrianDate: $greogrianDate, currentHijri: $currentHijri, newHijri: $newHijri, nextPrayer: $nextPrayer, nextPrayerTime: $nextPrayerTime)';
  }
}
