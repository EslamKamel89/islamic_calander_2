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
  final longAnimationDuration = const Duration(seconds: 3);
  final shortAnimationDuration = const Duration(milliseconds: 500);
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        showCustomBottomSheet();
      },
    );
    super.initState();
  }

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
          body: SingleChildScrollView(
            child: Column(
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
                        ExploreMore(onTap: () {
                          showCustomBottomSheet();
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showCustomBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheet(
          backgroundColor: Colors.transparent,
          onClosing: () {},
          builder: (context) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              // height: 300,
              width: double.infinity,
              color: Colors.black.withOpacity(0.5),
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  // childAspectRatio: 1, // Width/height ratio (1 = square)
                  mainAxisExtent: 170.h,
                ),
                children: const [
                  GridItem(title: 'Find Qibla', image: AssetsData.compass),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class GridItem extends StatelessWidget {
  const GridItem({
    super.key,
    required this.title,
    this.image,
  });
  final String title;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // height: 300,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (image != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(image!, height: 100.h, fit: BoxFit.cover),
            ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
