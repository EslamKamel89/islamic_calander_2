import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/prayers_controller.dart';
import 'package:islamic_calander_2/features/main_homepage/models/prayers_time_model.dart';

part 'update_next_prayer_api_state.dart';

class UpdateNextPrayerApiCubit extends Cubit<UpdateNextPrayerApiState> {
  final PrayersController controller = serviceLocator();
  Timer? timer;
  PrayerTimeParams? params;
  UpdateNextPrayerApiCubit() : super(UpdateNextPrayerApiState(response: ResponseEnum.initial));
  Future init() async {
    if (params == null) {
      Position? position = await determinePosition();
      if (position == null) {
        showSnackbar('Error', "Can't fetch location", true);
        return;
      }
      params = PrayerTimeParams(
        latitude: position.latitude,
        longitude: position.longitude,
        latitudeAdjustmentMethod: LatitudeAdjustmentMethod.angleBased,
        method: IslamicOrganization.muslimWorldLeague,
        date: DateTime.now(),
      );
    }
    emit(state.copyWith(response: ResponseEnum.loading));
    timer ??= Timer.periodic(const Duration(seconds: 1), (_) async {
      await _nextPrayerPeriodicFunction();
    });
  }

  Future _nextPrayerPeriodicFunction() async {
    const t = '_nextPrayerPeriodicFunction - UpdateNextPrayerApiCubit';
    DateTime now = DateTime.now();
    if (params!.date?.day != now.day || state.prayerTimeModel == null) {
      params!.date = now;
      state.prayerTimeModel = (await controller.prayerTime(params!)).data;
    }
    if (state.prayerTimeModel == null) {
      pr('Error Occured: prayerTimeModel is null', t);
      return;
    }
    NextPrayerModel nextPrayerModel = state.prayerTimeModel!.getNextPrayer();
    if (nextPrayerModel.nextPrayer == 'Fajr') {
      state.prayerTimeModel =
          (await controller.prayerTime(params!.copyWith(date: now.add(const Duration(days: 1))))).data;
      DateTime? fajrTime = state.prayerTimeModel?.fajrDateTime();
      emit(
        state.copyWith(
            nextPrayer: nextPrayerModel.nextPrayer,
            nextPrayerTime: fajrTime,
            prayerTimeModel: state.prayerTimeModel,
            timeRemaining: fajrTime?.difference(now),
            response: ResponseEnum.success),
      );
    } else {
      emit(
        state.copyWith(
            nextPrayer: nextPrayerModel.nextPrayer,
            nextPrayerTime: nextPrayerModel.nextPrayerTime,
            prayerTimeModel: state.prayerTimeModel,
            timeRemaining: nextPrayerModel.nextPrayerTime?.difference(now),
            response: ResponseEnum.success),
      );
    }
  }
}
