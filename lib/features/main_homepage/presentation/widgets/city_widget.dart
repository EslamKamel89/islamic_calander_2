import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/globals/globals_var.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/core/widgets/loading_widget.dart';
import 'package:islamic_calander_2/features/main_homepage/models/location_info_model.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';
import 'package:lottie/lottie.dart' as Lot;

class CityWidget extends StatefulWidget {
  const CityWidget({super.key});

  @override
  State<CityWidget> createState() => _CityWidgetState();
}

class _CityWidgetState extends State<CityWidget> {
  String? deviceLocation;
  ApiResponseModel<LocationInfoModel> locationInfoApi = ApiResponseModel<LocationInfoModel>(
    response: ResponseEnum.initial,
  );
  @override
  void initState() {
    _getLocationData();
    super.initState();
  }

  Future _getLocationData() async {
    final positionInMemory = serviceLocator<GeoPosition>().getPositionInMemory();
    if (positionInMemory != null) {
      await _request(positionInMemory);
      return;
    }
    positionNotifier.addListener(() async {
      if (positionNotifier.value == null) return;
      await _request(positionNotifier.value!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ltr,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Lot.Lottie.asset(
                AssetsData.map,
                width: 40,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            // .animate().moveX(duration: 1000.ms, begin: 200, end: 0),
            const SizedBox(width: 5),
            Expanded(
              child: locationInfoApi.response == ResponseEnum.success
                  ? AutoSizeText(
                      // child: Text(
                      _locationStr(locationInfoApi.data),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    )
                  : LoadingWidget(rowCount: 1, height: 15, space: 5, width: context.width - 50),
            )
            // .animate().moveX(duration: 1000.ms, begin: 200, end: 0),
          ],
        ),
      ),
    );
  }

  Future _request(Position position) async {
    final t = prt('_fetchLocationData - CityWidget');
    String url = "https://gaztec.org/moon/json.php?lat=${position.latitude}&lon=${position.longitude}";
    final api = serviceLocator<ApiConsumer>();
    try {
      setState(() {
        locationInfoApi = ApiResponseModel(response: ResponseEnum.loading);
      });
      final response = await api.get(url);
      setState(() {
        locationInfoApi = pr(
            ApiResponseModel(
              response: ResponseEnum.success,
              data: LocationInfoModel.fromMap(jsonDecode(response)),
            ),
            t);
      });
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occured');
      }
      showSnackbar('Error', errorMessage, true);
      setState(() {
        locationInfoApi = pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failure), t);
      });
    }
  }

  String _locationStr(LocationInfoModel? model) {
    if (model == null) return '';
    String result = '';
    if (model.one != null) result = '$result${model.one} ';
    if (model.two != null) result = '$result${model.two} ';
    if (model.three != null) result = '$result${model.three} ';
    if (model.four != null) result = '$result${model.four} ';
    return result;
  }
}
