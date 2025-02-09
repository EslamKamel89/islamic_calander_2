import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/router/app_routes_names.dart';
import 'package:islamic_calander_2/core/widgets/default_drawer.dart';
import 'package:islamic_calander_2/core/widgets/setting_drop_down.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/all_prays_time_widget.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/explore_more.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/grid_item.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/next_prayer_widget.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';
import 'package:url_launcher/url_launcher.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final animationDuration = const Duration(seconds: 1);
  final longAnimationDuration = const Duration(seconds: 3);
  final shortAnimationDuration = const Duration(milliseconds: 500);
  bool bottomSheetOpen = false;
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then(
      (value) {
        showCustomBottomSheet();
      },
    );
    super.initState();
  }

  void Function(Duration timeRemaning, String nextPrayer)? updateNextPrayerInfo;

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
            actions: const [SettingsDropdown()],
          ),
          drawer: const DefaultDrawer(opacity: 0.7),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  // color: Colors.red,
                  width: double.infinity,
                  height: 800.h,
                  // padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // HomepageHeader(
                        //     animationDuration: animationDuration, secondaryAnimationDuration: shortAnimationDuration),
                        // DateWidget(
                        //   animationDuration: animationDuration,
                        // ).animate().fade(duration: animationDuration, begin: 0, end: 1),
                        const NextPrayerWidget(),
                        SizedBox(height: 10.h),
                        const AllPraysTimeWidget(),
                        // const PrayerTimes2Widget().animate().fade(duration: animationDuration, begin: 0, end: 1),
                        SizedBox(height: 10.h),
                        // const PrayerTimes(),
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
            return const MainpageBottomSheetWidget();
          },
        );
      },
    );
  }
}

class MainpageBottomSheetWidget extends StatefulWidget {
  const MainpageBottomSheetWidget({
    super.key,
  });

  @override
  State<MainpageBottomSheetWidget> createState() => _MainpageBottomSheetWidgetState();
}

class _MainpageBottomSheetWidgetState extends State<MainpageBottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        height: 600.h,
        width: double.infinity,
        color: Colors.black.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: GridItem(
                    title: 'Date Conversion',
                    image: AssetsData.dateConversionIcon,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutesNames.dateConversionView);
                    },
                  ),
                ),
                Expanded(
                  child: GridItem(
                    title: 'Moon Phase',
                    image: AssetsData.moonIcon,
                    onTap: () async {
                      Navigator.of(context).pushNamed(AppRoutesNames.moonPhaseView);
                    },
                  ),
                ),
                Expanded(
                  child: GridItem(
                    title: 'Eclipse',
                    image: AssetsData.moonEclipseIcon,
                    onTap: () async {
                      Navigator.of(context).pushNamed(AppRoutesNames.eclipseView);
                    },
                  ),
                ),
                Expanded(
                  child: GridItem(
                    title: 'Find Qibla',
                    image: AssetsData.compass,
                    onTap: () {
                      Navigator.of(context).pushNamed(AppRoutesNames.qiblaFinderView);
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: GridItem(
                    title: 'Mosques',
                    image: AssetsData.mosque,
                    onTap: () async {
                      const url = "geo:0,0?q=mosque";
                      await launchUrl(Uri.parse(url));
                    },
                  ),
                ),
                Expanded(
                  child: GridItem(
                    title: 'Halal Restruants',
                    image: AssetsData.hallalResturant,
                    onTap: () async {
                      const url = "geo:0,0?q=halal+restraurant";
                      await launchUrl(Uri.parse(url));
                    },
                  ),
                ),
                Expanded(
                  child: GridItem(
                    title: 'World Prayers',
                    image: AssetsData.globe,
                    onTap: () async {
                      Navigator.of(context).pushNamed(AppRoutesNames.worldPrayersView);
                    },
                  ),
                ),
                const Expanded(child: SizedBox())
              ],
            ),
          ],
        )
        // StaggeredGrid.count(
        //   // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   //   crossAxisCount: 3,
        //   //   mainAxisSpacing: 8,
        //   //   crossAxisSpacing: 8,
        //   //   // childAspectRatio: 1, // Width/height ratio (1 = square)
        //   //   mainAxisExtent: 170.h,
        //   // ),
        //   crossAxisCount: 3,

        //   mainAxisSpacing: 3,
        //   crossAxisSpacing: 4,
        //   children: [
        //     StaggeredGridTile.count(
        //       crossAxisCellCount: 1,
        //       mainAxisCellCount: 1.25,
        //       child: GridItem(
        //         title: 'Find Qibla',
        //         image: AssetsData.compass,
        //         onTap: () {
        //           Navigator.of(context).pushNamed(AppRoutesNames.qiblaFinderView);
        //         },
        //       ),
        //     ),
        //     StaggeredGridTile.count(
        //       crossAxisCellCount: 1,
        //       mainAxisCellCount: 1.25,
        //       child: GridItem(
        //         title: 'Mosques',
        //         image: AssetsData.mosque,
        //         onTap: () {
        //           Navigator.of(context).pushNamed(AppRoutesNames.qiblaFinderView);
        //         },
        //       ),
        //     ),
        //     StaggeredGridTile.count(
        //       crossAxisCellCount: 1,
        //       mainAxisCellCount: 1.25,
        //       child: GridItem(
        //         title: 'Halal Restruants',
        //         image: AssetsData.hallalResturant,
        //         onTap: () {
        //           Navigator.of(context).pushNamed(AppRoutesNames.qiblaFinderView);
        //         },
        //       ),
        //     ),
        // const StaggeredGridTile.count(
        //   crossAxisCellCount: 3,
        //   mainAxisCellCount: 2,
        //   child: NextPrayerWidget(),
        //   // child: NextPrayerWidget(),
        //     // ),
        //   ],
        // ),
        );
  }
}
