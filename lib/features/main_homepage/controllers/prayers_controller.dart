import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/api_service/end_points.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/globals/calc_method_settings.dart';
import 'package:islamic_calander_2/core/heleprs/format_date.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:islamic_calander_2/features/main_homepage/models/prayers_time_model.dart';

final Map<String, ApiResponseModel<PrayersTimeModel>> _cache = {};
final Map<String, Future<ApiResponseModel<PrayersTimeModel>>> _inFlight = {};

class PrayersController {
  final ApiConsumer api = serviceLocator();

  Future<ApiResponseModel<PrayersTimeModel>> prayerTime(PrayerTimeParams params) async {
    final t = prt('prayerTime - PrayersController');

    if (params.method == IslamicOrganization.auto) {
      params.method =
          (await getPrayerCalcMethodByPosition()) ?? IslamicOrganization.muslimWorldLeague;
    } else {
      params.method = selectedPrayersMethod;
    }

    final date = params.date ?? DateTime.now();
    final key = params.toKey(date);

    final cached = _cache[key];
    if (cached != null) {
      return pr(cached, '$t (memory cache)');
    }

    final running = _inFlight[key];
    if (running != null) {
      return await running;
    }

    final future = _fetchPrayerTime(params, date, key, t);

    _inFlight[key] = future;

    return await future;
  }

  Future<ApiResponseModel<PrayersTimeModel>> _fetchPrayerTime(
    PrayerTimeParams params,
    DateTime date,
    String key,
    String t,
  ) async {
    try {
      final response = await api.get(
        EndPoint.prayerTimesEndPoint(date),
        queryParameter: params.toMap(),
      );

      final result = pr(
        ApiResponseModel(
          response: ResponseEnum.success,
          data: PrayersTimeModel.fromJson(
            response['data']['timings'],
            date: formatDateForApi(date),
          ),
        ),
        t,
      );

      _cache[key] = result;

      return result;
    } catch (e) {
      String errorMessage = e.toString();

      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occurred');
      }

      // final context = navigatorKey.currentContext;

      // if (context != null) {
      //   showSnackbar('Error', errorMessage, true);
      // }

      return pr(
        ApiResponseModel(
          errorMessage: errorMessage,
          response: ResponseEnum.failure,
        ),
        t,
      );
    } finally {
      _inFlight.remove(key);
    }
  }
}
