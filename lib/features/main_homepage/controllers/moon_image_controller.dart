import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/api_service/end_points.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/globals.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';

class MoonImageController {
  ApiConsumer api = serviceLocator();

  Future<ApiResponseModel<String>> moonImage({required Position position, required DateTime dateTime}) async {
    final t = prt('moonImage - MoonImageController');
    try {
      final response = await api.get(
        EndPoint.moonPhaseEndPoint,
        data: _requestData(position, dateTime),
      );
      return pr(
          ApiResponseModel(
            response: ResponseEnum.success,
            data: response['data']['imageUrl'],
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

  Map<String, dynamic> _requestData(Position position, DateTime dateTime) {
    return {
      "format": "png",
      "style": {
        "moonStyle": "default",
        "backgroundStyle": "solid",
        "backgroundColor": "transparent",
        "headingColor": "transparent",
        "textColor": "transparent"
      },
      "observer": {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "date": DateFormat('yyyy-MM-dd', 'en').format(dateTime),
      },
      "view": {"type": "landscape-simple", "orientation": "south-up"}
    };
  }
}
