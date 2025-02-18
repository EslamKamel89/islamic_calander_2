import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
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
  LocationInfoModel? locationInfoModel;
  @override
  void initState() {
    // getCityName().then((city) {
    //   if (mounted) {
    //     setState(() {
    //       deviceLocation = city;
    //     });
    //   }
    // });
    _getLocationData();
    super.initState();
  }

  Future _getLocationData() async {
    final positionInMemory = serviceLocator<GeoPosition>().getPositionInMemory();
    if (positionInMemory != null) {
      await _fetchLocationData(positionInMemory);
      return;
    }
    positionNotifier.addListener(() async {
      if (positionNotifier.value == null) return;
      await _fetchLocationData(positionNotifier.value!);
    });
  }

  Future _fetchLocationData(Position position) async {
    final t = prt('_fetchLocationData - CityWidget');
    String url =
        "https://geocode.maps.co/reverse?lat=${position.latitude}&lon=${position.longitude}&api_key=67b4428a29c7f011243342irgc1dd0e";
    final api = serviceLocator<ApiConsumer>();
    try {
      final response = await api.get(url);
      setState(() {
        locationInfoModel = LocationInfoModel.fromJson(response['address']);
      });
      pr(locationInfoModel, t);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occured');
      }
      showSnackbar('Error', errorMessage, true);
      pr(errorMessage, t);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (locationInfoModel == null) return const SizedBox();
    // locationInfoModel = null;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (locationInfoModel == null)
            Opacity(
              opacity: 0.8,
              child: Lot.Lottie.asset(
                AssetsData.map,
                width: 40,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          if (locationInfoModel == null)
            Container(
              width: 100.w,
              height: 100.w,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          if (locationInfoModel != null)
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
          if (locationInfoModel != null)
            Expanded(
              child: AutoSizeText(
                // child: Text(
                _locationStr(locationInfoModel!),
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
          // .animate().moveX(duration: 1000.ms, begin: 200, end: 0),
        ],
      ),
    );
  }

  String _locationStr(LocationInfoModel model) {
    String result = '';
    if (model.county != null && model.state == null) result = '$result${model.county}\n';
    if (model.state != null && model.county == null) result = '$result${model.state}\n';
    if (model.city != null && ![model.county, model.state].contains(model.city)) result = '$result${model.city}\n';
    if (model.country != null) result = '$result${model.country}';
    return result;
  }
}
