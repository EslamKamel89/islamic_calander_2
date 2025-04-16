// ignore_for_file: dead_code

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/api_service/end_points.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/core/widgets/loading_widget.dart';
import 'package:islamic_calander_2/features/main_homepage/models/temperature_model/temperature_model.dart';
import 'package:islamic_calander_2/features/main_homepage/models/temperature_model/weather.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';
import 'package:islamic_calander_2/utils/styles/styles.dart';
import 'package:lottie/lottie.dart' as Lot;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CurrentTemperatureWidget extends StatefulWidget {
  const CurrentTemperatureWidget({super.key});

  @override
  State<CurrentTemperatureWidget> createState() => _CurrentTemperatureWidgetState();
}

ApiResponseModel<TemperatureModel> currentTemp = ApiResponseModel();

class _CurrentTemperatureWidgetState extends State<CurrentTemperatureWidget> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  Future _init() async {
    if (currentTemp.data != null) return;
    final positionInMemory = serviceLocator<GeoPosition>().getPositionInMemory();
    if (positionInMemory != null) {
      await _fetchTemperature(
        positionInMemory.longitude,
        positionInMemory.latitude,
      );
      return;
    }
    positionNotifier.addListener(() async {
      if (positionNotifier.value == null) return;
      await _fetchTemperature(positionNotifier.value!.longitude, positionNotifier.value!.latitude);
    });
  }

  Future _fetchTemperature(double long, double lat) async {
    final t = prt('_fetchTemperature - CurrentTemperatureWidget');
    String url = EndPoint.temperature(long, lat);
    final api = serviceLocator<ApiConsumer>();
    try {
      setState(() {
        currentTemp = ApiResponseModel(response: ResponseEnum.loading);
      });
      final response = await api.get(url);
      setState(() {
        currentTemp = pr(
            ApiResponseModel(
              response: ResponseEnum.success,
              data: TemperatureModel.fromJson(response),
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
        currentTemp =
            pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failure), t);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    final lotte = Lot.Lottie.asset(
      _getLottie(),
      width: 40,
      height: 50,
      fit: BoxFit.cover,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: lotte,
          ),
          // .animate().moveX(duration: 1000.ms, begin: 200, end: 0),
          const SizedBox(width: 10),
          Expanded(
            child: currentTemp.response == ResponseEnum.success
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      txt(currentTemp.data?.main?.temp?.toString() ?? '',
                          c: Colors.white, e: St.reg18),
                      Icon(MdiIcons.temperatureCelsius, color: Colors.white)
                    ],
                  )
                : LoadingWidget(rowCount: 1, height: 15, space: 5, width: context.width - 50),
          )
          // .animate().moveX(duration: 1000.ms, begin: 200, end: 0),
        ],
      ),
    );
  }

  String _getLottie() {
    final weatherEnum = currentTemp.data?.weather?[0].classifyWeather() ?? WeatherEnum.sunny;
    // return AssetsData.sunny;
    // return AssetsData.stormy;
    // return AssetsData.rainny;
    // return AssetsData.snowy;
    // return AssetsData.foggie;
    // return AssetsData.cloudy;
    switch (weatherEnum) {
      case WeatherEnum.unknown:
        return AssetsData.sunny;
      case WeatherEnum.stormy:
        return AssetsData.stormy;
      case WeatherEnum.rainy:
        return AssetsData.rainny;
      case WeatherEnum.snowy:
        return AssetsData.snowy;
      case WeatherEnum.foggy:
        return AssetsData.foggie;
      case WeatherEnum.sunny:
        return AssetsData.sunny;
      case WeatherEnum.cloudy:
        return AssetsData.cloudy;
    }
  }
}
