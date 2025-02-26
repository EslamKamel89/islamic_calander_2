// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/api_service/end_points.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/features/date_conversion/data/models/selected_date_conversion_model.dart';

class HomeRepoDataSource {
  final ApiConsumer api;
  HomeRepoDataSource({
    required this.api,
  });
  Future<SelectedDateConversionModel> getDateConversion(DateTime selectedDate) async {
    String year = DateFormat('yyyy').format(selectedDate);
    String month = DateFormat('MMM').format(selectedDate).toLowerCase();
    String day = DateFormat('d').format(selectedDate);
    final t = prt('getDateConversion - HomeRepoDataSource');
    final data = await api.get(EndPoint.dateConversionEndPoint, queryParameter: {
      'year': year,
      'month': month,
      'day': day,
    });
    SelectedDateConversionModel model = pr(SelectedDateConversionModel.fromJson(jsonDecode(data)), t);
    return model;
  }
}
