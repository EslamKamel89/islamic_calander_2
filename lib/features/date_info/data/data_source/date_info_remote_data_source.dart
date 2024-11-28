// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/api_service/end_points.dart';
import 'package:islamic_calander_2/core/enums/month_enums.dart';
import 'package:islamic_calander_2/core/enums/moon_phase_enums.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/features/date_info/data/models/date_info_model.dart';
import 'package:islamic_calander_2/features/date_info/domain/entities/moon_info_model.dart';

class DateInfoRemoteDataSource {
  final ApiConsumer api;
  DateInfoRemoteDataSource({
    required this.api,
  });
  Future<List<DateInfoModel>> getDateInfoYear(int year) async {
    final t = prt('getDateInfoYear - DateInfoRemoteDataSource');
    final data = await api.get(EndPoint.dateInfoYearEndPoint, queryParameter: {
      'year': year,
    });
    List dataList = jsonDecode(data);
    pr(dataList, '$t - raw respnose');
    List<DateInfoModel> models = dataList.map<DateInfoModel>((json) => DateInfoModel.fromJson(json)).toList();
    pr(models, '$t - parsed respnose');
    return models;
  }

  Future<List<DateInfoModel>> getDateInfoMonth(int year, MonthEnum month) async {
    final t = prt('getDateInfoYear - DateInfoRemoteDataSource');
    final data = await api.get(EndPoint.dateInfoMonthEndPoint, queryParameter: {
      'year': year,
      'month': month.toShortString(),
    });
    List dataList = jsonDecode(data);
    pr(dataList, '$t - raw respnose');
    List<DateInfoModel> models = dataList.map<DateInfoModel>((json) => DateInfoModel.fromJson(json)).toList();
    pr(models, '$t - parsed respnose');
    return models;
  }

  Future<List<MoonInfoModel>> getMoonInfoMonth(int year, MoonPhaseEnum moonPhase) async {
    final t = prt('getDateInfoYear - DateInfoRemoteDataSource');
    final data = await api.get(EndPoint.getMoonPhaseEndPoint, queryParameter: {
      'year': year,
      'phase': moonPhase.toShortString(),
    });
    List dataList = jsonDecode(data);
    pr(dataList, '$t - raw respnose');
    List<MoonInfoModel> models = dataList.map<MoonInfoModel>((json) => MoonInfoModel.fromJson(json)).toList();
    pr(models, '$t - parsed respnose');
    return models;
  }
}
