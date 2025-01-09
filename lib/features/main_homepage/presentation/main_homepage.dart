import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/widgets/default_drawer.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/date_widget.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/explore_more.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/homepage_header.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/prayer_times.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final animationDuration = const Duration(seconds: 1);
  final longAnimationDuration = const Duration(seconds: 5);
  final shortAnimationDuration = const Duration(milliseconds: 500);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(width: context.width, height: context.height, color: Colors.white),
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage(AssetsData.homepageBackground), fit: BoxFit.cover),
          ),
          width: context.width,
          height: context.height,
        ).animate().fade(duration: longAnimationDuration, begin: 0, end: 1),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white.withOpacity(0.2),
            foregroundColor: Colors.black,
          ),
          drawer: const DefaultDrawer(opacity: 0.7),
          body: Column(
            children: [
              SizedBox(
                // color: Colors.red,
                width: double.infinity,
                height: 600.h,
                // padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      HomepageHeader(
                          animationDuration: animationDuration, secondaryAnimationDuration: shortAnimationDuration),
                      DateWidget(
                        animationDuration: animationDuration,
                      ).animate().fade(duration: animationDuration, begin: 0, end: 1),
                      SizedBox(height: 10.h),
                      const PrayerTimes(),
                      const ExploreMore(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
