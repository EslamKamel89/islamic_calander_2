import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/api_service/dio_consumer.dart';
import 'package:islamic_calander_2/core/router/app_router.dart';
import 'package:islamic_calander_2/core/router/middleware.dart';
import 'package:islamic_calander_2/features/date_conversion/data/data_source/date_conversion_data_source.dart';
import 'package:islamic_calander_2/features/date_conversion/data/repos/date_conversion_repo_impl.dart';
import 'package:islamic_calander_2/features/date_conversion/domain/repo/date_conversion_repo.dart';
import 'package:islamic_calander_2/features/date_info/data/data_source/date_info_remote_data_source.dart';
import 'package:islamic_calander_2/features/date_info/data/repo/date_year_repo_imp.dart';
import 'package:islamic_calander_2/features/date_info/domain/repo/date_year_repo.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/prayers_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt serviceLocator = GetIt.instance;

Future initServiceLocator() async {
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: serviceLocator()));
  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(() => prefs);
  serviceLocator.registerLazySingleton<AppMiddleWare>(() => AppMiddleWare(sharedPreferences: serviceLocator()));
  serviceLocator.registerLazySingleton<AppRouter>(() => AppRouter(appMiddleWare: serviceLocator()));
  serviceLocator.registerLazySingleton<HomeRepoDataSource>(() => HomeRepoDataSource(api: serviceLocator()));
  serviceLocator
      .registerLazySingleton<DateConversionRepo>(() => DateConversionRepoImpl(homeRepoDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<DateInfoRemoteDataSource>(() => DateInfoRemoteDataSource(api: serviceLocator()));
  serviceLocator
      .registerLazySingleton<DateInfoRepo>(() => DateInfoRepoImpl(dateInfoRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<PrayersController>(() => PrayersController());
}
