import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/router/app_routes_names.dart';
import 'package:islamic_calander_2/core/widgets/default_drawer.dart';
import 'package:islamic_calander_2/features/main_homepage/cubits/update_next_prayer_info/update_next_prayer_info_cubit.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/date_widget.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/explore_more.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/grid_item.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/homepage_header.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/prayer_times_2.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
                        const PrayerTimes2Widget().animate().fade(duration: animationDuration, begin: 0, end: 1),
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
      child: StaggeredGrid.count(
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 3,
        //   mainAxisSpacing: 8,
        //   crossAxisSpacing: 8,
        //   // childAspectRatio: 1, // Width/height ratio (1 = square)
        //   mainAxisExtent: 170.h,
        // ),
        crossAxisCount: 4,

        mainAxisSpacing: 3,
        crossAxisSpacing: 4,
        children: [
          StaggeredGridTile.count(
            crossAxisCellCount: 1,
            mainAxisCellCount: 2,
            child: GridItem(
              title: 'Find Qibla',
              image: AssetsData.compass,
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutesNames.qiblaFinderView);
              },
            ),
          ),
          const StaggeredGridTile.count(
            crossAxisCellCount: 3,
            mainAxisCellCount: 2,
            child: NextPrayerWidget(),
            // child: NextPrayerWidget(),
          ),
        ],
      ),
    );
  }
}

class NextPrayerWidget extends StatelessWidget {
  const NextPrayerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateNextPrayerInfoCubit, UpdateNextPrayerInfoState>(
      builder: (context, state) {
        if (state.nextPrayer == null || state.timeRemaining == null) return const SizedBox();
        return PrayerCard(prayerName: state.nextPrayer!, timeRemaining: state.timeRemaining!);
        return Container(
          child: Stack(
            children: [
              Image.asset(
                AssetsData.islamicBorder,
                fit: BoxFit.fill,
              ),
              Positioned(
                right: 15.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10.h),
                    const Text(
                      'Next Prayer',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      pr(state.nextPrayer ?? ''),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      pr(state.timeRemaining.toString().split('.').first),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PrayerCard extends StatelessWidget {
  final String prayerName;
  final Duration timeRemaining;

  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    // Format the remaining time as HH:MM:SS.
    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes.remainder(60);
    final seconds = timeRemaining.inSeconds.remainder(60);
    final timeRemainingText = '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';

    return Card(
      elevation: 8,
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          // Gradient background for an attractive look
          gradient: LinearGradient(
            colors: [const Color(0xFF3C8CE7).withOpacity(0.6), const Color(0xFF00EAFF).withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Islamic themed icon; you can replace with a custom asset if needed.
            Icon(
              MdiIcons.mosque,
              color: Colors.white,
              size: 40.w,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Next Prayer',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prayerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Time Remaining:',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    timeRemainingText,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
