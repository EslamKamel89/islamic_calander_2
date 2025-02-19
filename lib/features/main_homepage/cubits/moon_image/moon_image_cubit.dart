import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/moon_image_controller.dart';

class MoonImageCubit extends Cubit<ApiResponseModel<String?>> {
  final MoonImageController controller = serviceLocator<MoonImageController>();
  Position? position;
  DateTime? dateTime;
  MoonImageCubit()
      : super(ApiResponseModel<String?>(response: ResponseEnum.initial));
  Future moonImage() async {
    final t = prt('moonImage - MoonImageCubit');
    if ([position, dateTime].contains(null)) {
      pr('error: position or dateTime is null', t);
      return;
    }
    emit(pr(
        state.copyWith(errorMessage: null, response: ResponseEnum.loading), t));
    pr([position!.latitude, position!.latitude, dateTime],
        '$t - moonImage params');
    emit(pr(
        await controller.moonImage(position: position!, dateTime: dateTime!),
        t));
  }
}
