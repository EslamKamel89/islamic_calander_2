import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/api_service/end_points.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/features/about/models/about_model.dart';

class AboutController {
  ApiConsumer api = serviceLocator();
  Future<ApiResponseModel<AboutModel>> fetch() async {
    final t = prt('fetch - AboutController');
    try {
      final response = await api.get(
        EndPoint.about,
      );
      pr(response, '$t - response');
      pr(response.runtimeType, '$t - response runtime type');

      // pr(response['about'], '$t - response[about]');
      final mode = (jsonDecode(response) as Map<String, dynamic>)['about']['mode'];
      pr(mode, 'mode -----------');
      pr(mode.runtimeType, 'mode -----------');
      final AboutModel model = AboutModel.fromJson(jsonDecode(response)['about']);
      return pr(
          ApiResponseModel(
            response: ResponseEnum.success,
            data: model,
          ),
          t);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occured');
      }
      showSnackbar('Error', errorMessage, true);
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failure), t);
    }
  }
}
