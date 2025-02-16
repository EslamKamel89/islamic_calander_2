// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/api_service/end_points.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/globals/globals_var.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:islamic_calander_2/features/main_homepage/models/prayers_time_model.dart';

class PrayersController {
  ApiConsumer api = serviceLocator();
  Future<ApiResponseModel<PrayersTimeModel>> prayerTime(PrayerTimeParams params) async {
    final t = prt('prayerTime - PrayersControllers');
    try {
      final response = await api.get(
        EndPoint.prayerTimesEndPoint(params.date ?? DateTime.now()),
        queryParameter: params.toMap(),
      );
      return pr(
          ApiResponseModel(
            response: ResponseEnum.success,
            data: PrayersTimeModel.fromJson(response['data']['timings']),
          ),
          t);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occured');
      }
      BuildContext? context = navigatorKey.currentContext;
      if (context != null) {
        showSnackbar('Error', errorMessage, true);
      }
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failure), t);
    }
  }
}
