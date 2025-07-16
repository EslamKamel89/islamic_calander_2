// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:islamic_calander_2/core/router/app_routes_names.dart';
// import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/grid_item.dart';
// import 'package:islamic_calander_2/utils/assets/assets.dart';
// import 'package:url_launcher/url_launcher.dart';

// class MainpageBottomSheetWidget extends StatefulWidget {
//   const MainpageBottomSheetWidget({
//     super.key,
//   });

//   @override
//   State<MainpageBottomSheetWidget> createState() => _MainpageBottomSheetWidgetState();
// }

// class _MainpageBottomSheetWidgetState extends State<MainpageBottomSheetWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//         height: 600.h,
//         width: double.infinity,
//         color: Colors.black.withOpacity(0.5),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: GridItem(
//                     title: "DATE_CONVERSION".tr(),
//                     image: AssetsData.dateConversionIcon,
//                     onTap: () {
//                       Navigator.of(context).pushNamed(AppRoutesNames.dateConversionView);
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: GridItem(
//                     title: 'MOON_PHASE'.tr(),
//                     image: AssetsData.moonIcon,
//                     onTap: () async {
//                       Navigator.of(context).pushNamed(AppRoutesNames.moonPhaseView);
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: GridItem(
//                     title: 'ECLIPSE'.tr(),
//                     image: AssetsData.moonEclipseIcon,
//                     onTap: () async {
//                       Navigator.of(context).pushNamed(AppRoutesNames.eclipseView);
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: GridItem(
//                     title: 'FIND_QIBLA'.tr(),
//                     image: AssetsData.compass,
//                     onTap: () {
//                       Navigator.of(context).pushNamed(AppRoutesNames.qiblaFinderView);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: GridItem(
//                     title: 'MOSQUES'.tr(),
//                     image: AssetsData.mosque,
//                     onTap: () async {
//                       // const url = "geo:0,0?q=mosque";
//                       const url =
//                           'https://www.google.com/maps/search/mosques+near+me/@31.0437726,31.3662496,15z/data=!3m1!4b1?entry=ttu&g_ep=EgoyMDI1MDMxNy4wIKXMDSoASAFQAw%3D%3D';
//                       await launchUrl(Uri.parse(url));
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: GridItem(
//                     title: 'HALAL'.tr(),
//                     image: AssetsData.hallalResturant,
//                     onTap: () async {
//                       // const url = "geo:0,0?q=halal+restraurant";
//                       const url =
//                           'https://www.google.com/maps/search/halal+restraurant+near+me/@31.0437726,31.3662496,15z/data=!3m1!4b1?entry=ttu&g_ep=EgoyMDI1MDMxNy4wIKXMDSoASAFQAw%3D%3D';
//                       await launchUrl(Uri.parse(url));
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: GridItem(
//                     title: 'WORLD_PRAYERS_2'.tr(),
//                     image: AssetsData.globe,
//                     onTap: () async {
//                       Navigator.of(context).pushNamed(AppRoutesNames.worldPrayersView);
//                     },
//                   ),
//                 ),
//                 Expanded(
//                   child: GridItem(
//                     title: "TASKS".tr(),
//                     image: AssetsData.task,
//                     onTap: () async {
//                       Navigator.of(context).pushNamed(AppRoutesNames.tasksView);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: GridItem(
//                     title: 'ABOUT'.tr(),
//                     image: AssetsData.about,
//                     onTap: () async {
//                       Navigator.of(context).pushNamed(AppRoutesNames.aboutView);
//                     },
//                   ),
//                 ),
//                 const Expanded(child: SizedBox()),
//                 const Expanded(child: SizedBox()),
//                 const Expanded(child: SizedBox()),
//               ],
//             ),
//           ],
//         ));
//   }
// }

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_calander_2/core/heleprs/is_ltr.dart';
import 'package:islamic_calander_2/core/router/app_routes_names.dart';
import 'package:islamic_calander_2/core/widgets/sizer.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/grid_item.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/share_app.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            height: 600.h,
            width: double.infinity,
            color: Colors.black.withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     InkWell(
                //         onTap: () {
                //           Navigator.of(context).pop();
                //         },
                //         child: Material(
                //           borderRadius: BorderRadius.circular(1000),
                //           elevation: 10,
                //           color: Colors.transparent,
                //           child: Padding(
                //             padding: const EdgeInsets.all(3),
                //             child: Icon(
                //               MdiIcons.close,
                //               color: Colors.white,
                //               size: 30,
                //             ),
                //           ),
                //         ))
                //   ],
                // ),
                // const Sizer(),
                Row(
                  children: [
                    // Expanded(
                    //   child: GridItem(
                    //     title: "DATE_CONVERSION".tr(),
                    //     image: AssetsData.dateConversionIcon,
                    //     onTap: () {
                    //       Navigator.of(context).pushNamed(AppRoutesNames.dateConversionView);
                    //     },
                    //   ),
                    // ),
                    // Expanded(
                    //   child: GridItem(
                    //     title: 'MOON_PHASE'.tr(),
                    //     image: AssetsData.moonIcon,
                    //     onTap: () async {
                    //       Navigator.of(context).pushNamed(AppRoutesNames.moonPhaseView);
                    //     },
                    //   ),
                    // ),
                    Expanded(
                      child: GridItem(
                        title: 'ECLIPSE'.tr(),
                        image: AssetsData.moonEclipseIcon,
                        onTap: () async {
                          Navigator.of(context).pushNamed(AppRoutesNames.eclipseView);
                        },
                      ),
                    ),
                    Expanded(
                      child: GridItem(
                        title: 'FIND_QIBLA'.tr(),
                        image: AssetsData.compass,
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutesNames.qiblaFinderView);
                        },
                      ),
                    ),
                    Expanded(
                      child: GridItem(
                        title: 'MOSQUES'.tr(),
                        image: AssetsData.mosque,
                        onTap: () async {
                          // const url = "geo:0,0?q=mosque";
                          const url =
                              'https://www.google.com/maps/search/mosques+near+me/@31.0437726,31.3662496,15z/data=!3m1!4b1?entry=ttu&g_ep=EgoyMDI1MDMxNy4wIKXMDSoASAFQAw%3D%3D';
                          await launchUrl(Uri.parse(url));
                        },
                      ),
                    ),
                    Expanded(
                      child: GridItem(
                        title: 'HALAL'.tr(),
                        image: AssetsData.hallalResturant,
                        onTap: () async {
                          // const url = "geo:0,0?q=halal+restraurant";
                          const url =
                              'https://www.google.com/maps/search/halal+restraurant+near+me/@31.0437726,31.3662496,15z/data=!3m1!4b1?entry=ttu&g_ep=EgoyMDI1MDMxNy4wIKXMDSoASAFQAw%3D%3D';
                          await launchUrl(Uri.parse(url));
                        },
                      ),
                    ),
                  ],
                ),
                const Sizer(),
                Row(
                  children: [
                    // Expanded(
                    //   child: GridItem(
                    //     title: 'WORLD_PRAYERS_2'.tr(),
                    //     image: AssetsData.globe,
                    //     onTap: () async {
                    //       Navigator.of(context).pushNamed(AppRoutesNames.worldPrayersView);
                    //     },
                    //   ),
                    // ),
                    Expanded(
                      child: GridItem(
                        title: "TASKS".tr(),
                        image: AssetsData.task,
                        onTap: () async {
                          Navigator.of(context).pushNamed(AppRoutesNames.tasksView);
                        },
                      ),
                    ),
                    Expanded(
                      child: GridItem(
                        title: 'ABOUT'.tr(),
                        image: AssetsData.about,
                        onTap: () async {
                          Navigator.of(context).pushNamed(AppRoutesNames.aboutView);
                        },
                      ),
                    ),
                    Expanded(
                      child: GridItem(
                        title: 'SHARE_APP'.tr(),
                        image: AssetsData.share,
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const Dialog(
                                  child: ShareAppWidget(),
                                );
                              });
                        },
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    )
                  ],
                ),
                // Row(
                //   children: [

                //     const Expanded(child: SizedBox()),
                //     const Expanded(child: SizedBox()),
                //   ],
                // ),
              ],
            )),
        Positioned.directional(
          textDirection: getTextDirection(),
          bottom: 20,
          end: 10,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
                // child: const Text('close', style: TextStyle(fontSize: 16, color: Colors.white))),
                child: Icon(
                  MdiIcons.arrowDownBoldOutline,
                  color: Colors.white,
                  size: 25,
                )),
          ),
        )
      ],
    );
  }
}
