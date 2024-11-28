import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl_standalone.dart';
import 'package:islamic_calander_2/core/globals.dart';
import 'package:islamic_calander_2/core/router/app_router.dart';
import 'package:islamic_calander_2/core/router/app_routes_names.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/core/themes/theme_cubit.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/cubits/date_conversion/date_conversion_cubit.dart';
import 'package:islamic_calander_2/features/date_info/presentation/cubits/date_month/date_month_cubit.dart';
import 'package:islamic_calander_2/features/date_info/presentation/cubits/date_year/date_year_cubit.dart';
import 'package:islamic_calander_2/features/date_info/presentation/cubits/moon_phase/moon_phase_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  await findSystemLocale();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/langs', // Path to translation files
        fallbackLocale: const Locale('en'),
        child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => ThemeCubit(),
          ),
          BlocProvider(
            create: (context) => DateConversionCubit(dateConversionRepo: serviceLocator()),
          ),
          BlocProvider(
            create: (context) => DateYearCubit(dateInfoRepo: serviceLocator()),
          ),
          BlocProvider(
            create: (context) => DateMonthCubit(dateInfoRepo: serviceLocator()),
          ),
          BlocProvider(
            create: (context) => MoonPhaseCubit(dateInfoRepo: serviceLocator()),
          ),
        ],
        child: Builder(builder: (context) {
          final themeCubit = context.watch<ThemeCubit>();
          return MaterialApp(
            navigatorKey: navigatorKey,
            theme: themeCubit.state,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutesNames.splashScreen,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            onGenerateRoute: serviceLocator<AppRouter>().onGenerateRoute,
          );
        }),
      ),
    );
  }
}
