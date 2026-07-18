import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/globals/globals_var.dart';
import 'package:islamic_calander_2/core/heleprs/is_ltr.dart';
import 'package:islamic_calander_2/core/heleprs/local_notification.dart';
import 'package:islamic_calander_2/core/widgets/setting_drop_down.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/all_prays_time_widget.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/custom_bottom_sheet.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/islamic_wisdom_card.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/next_prayer_widget.dart';
import 'package:islamic_calander_2/main.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> with RouteAware {
  final animationDuration = const Duration(seconds: 1);
  final longAnimationDuration = const Duration(seconds: 3);
  final shortAnimationDuration = const Duration(milliseconds: 500);
  bool bottomSheetOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void initState() {
    WakelockPlus.enable();
    init();
    notificationService.requestPermissions();
    super.initState();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Future init() async {
    // await positionFetchedTrigger();
    // await checkPermissionsLoop();
  }
  @override
  void didPopNext() {
    bottomNavigationBarIndex = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // prt('sh cleared');
    // serviceLocator<SharedPreferences>().clear();
    return Stack(
      children: [
        Container(width: context.width, height: context.height, color: Colors.white),
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AssetsData.homepageBackground), fit: BoxFit.cover),
          ),
          width: context.width,
          height: context.height,
        ).animate().fade(duration: longAnimationDuration, begin: 0, end: 1),
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            // appBar: AppBar(
            //   backgroundColor: Colors.white.withOpacity(0.2),
            //   foregroundColor: Colors.black,
            //   actions: const [SettingsDropdown()],
            // ),
            // drawer: const DefaultDrawer(opacity: 0.7),
            bottomNavigationBar: CustomBottomNavBar(
              key: Key(bottomNavigationBarIndex.toString()),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Text(
                  //   customNow().toIso8601String().split('T')[1],
                  //   style: const TextStyle(fontSize: 20),
                  // ),
                  SizedBox(
                    // color: Colors.red,
                    width: double.infinity,
                    // height: 800.h,
                    // padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          // HomepageHeader(
                          //     animationDuration: animationDuration, secondaryAnimationDuration: shortAnimationDuration),
                          // DateWidget(
                          //   animationDuration: animationDuration,
                          // ).animate().fade(duration: animationDuration, begin: 0, end: 1),
                          Stack(
                            children: [
                              const NextPrayerWidget(),
                              Builder(builder: (context) {
                                context.locale;
                                return Positioned.directional(
                                  top: 10,
                                  end: 20,
                                  textDirection: isEnglish() ? ltr : rtl,
                                  child: const SettingsDropdown(),
                                );
                              })
                            ],
                          ),
                          SizedBox(height: 10.h),
                          // ElevatedButton(
                          //     onPressed: () {
                          //       // notificationService.showBasicNotification();
                          //       // notificationService.schedulePrayerNotification('Fajr',
                          //       //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)));
                          //       notificationService.showAllPendingNotifications();
                          //     },
                          //     child: const Text('Test')),
                          const AllPraysTimeWidget(),
                          // const PrayerTimes2Widget().animate().fade(duration: animationDuration, begin: 0, end: 1),
                          SizedBox(height: 10.h),
                          const IslamicWisdomCard(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (false)
          Positioned(
            bottom: 100.h,
            right: 10,
            left: 10,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  showCustomBottomSheet();
                },
                child: Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.w),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Image.asset(
                          AssetsData.globe2,
                          fit: BoxFit.cover,
                        )
                            .animate(onPlay: (controller) => controller.repeat())
                            .rotate(duration: 6000.ms, begin: 0, end: 2)
                        // .then()
                        // .rotate(duration: 4000.ms, begin: 2, end: 0),
                        )
                    .animate()
                    .move(
                        duration: 3000.ms,
                        begin: Offset(0, -context.height),
                        end: Offset.zero,
                        curve: Curves.bounceOut),
              ),
            ),
          )
      ],
    );
  }
}

void showCustomBottomSheet() {
  final context = navigatorKey.currentContext;
  if (context == null) return;
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
