import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/router/app_routes_names.dart';
import 'package:islamic_calander_2/core/router/middleware.dart';
import 'package:islamic_calander_2/core/widgets/splash_screen.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/date_conversion_view.dart';
import 'package:islamic_calander_2/features/date_info/presentation/date_month_view.dart';
import 'package:islamic_calander_2/features/date_info/presentation/date_year_view.dart';
import 'package:islamic_calander_2/features/date_info/presentation/moon_info_view.dart';

class AppRouter {
  AppMiddleWare appMiddleWare;
  AppRouter({required this.appMiddleWare});
  Route? onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    String? routeName = appMiddleWare.middlleware(routeSettings.name);
    switch (routeName) {
      case AppRoutesNames.splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
          settings: routeSettings,
        );
      case AppRoutesNames.dateConversionView:
        return MaterialPageRoute(
          builder: (context) => const DateConversionView(),
          settings: routeSettings,
        );
      case AppRoutesNames.dateYearView:
        return MaterialPageRoute(
          builder: (context) => const DateYearView(),
          settings: routeSettings,
        );
      case AppRoutesNames.dateMonthView:
        return MaterialPageRoute(
          builder: (context) => const DateMonthView(),
          settings: routeSettings,
        );
      case AppRoutesNames.moonPhaseView:
        return MaterialPageRoute(
          builder: (context) => const MoonInfoView(),
          settings: routeSettings,
        );
      default:
        return null;
    }
  }
}
