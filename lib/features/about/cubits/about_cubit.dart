import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/features/about/models/about_model.dart';

class AboutCubit extends Cubit<ApiResponseModel<AboutModel>> {
  // final MoonImageController controller = serviceLocator<MoonImageController>();

  AboutCubit() : super(ApiResponseModel<AboutModel>(response: ResponseEnum.initial));
  Future fetch({bool showInfo = false}) async {
    final t = prt('fetch - AboutCubit');

    emit(pr(state.copyWith(errorMessage: null, response: ResponseEnum.loading), t));

    // emit(pr(
    //     await controller.moonImage(
    //         position: position!, dateTime: dateTime!, showInfo: showInfo),
    //     t)
    //     );
  }
}
