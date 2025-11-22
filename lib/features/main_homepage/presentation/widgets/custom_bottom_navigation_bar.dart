import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:islamic_calander_2/core/router/app_routes_names.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/main_homepage.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

int bottomNavigationBarIndex = 0;

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  void _onItemTapped(int index) {
    if (index != 3) {
      setState(() {
        bottomNavigationBarIndex = index;
      });
    }
    final route = _getRouteNameForIndex(index);
    if (route != "MORE") {
      // Navigator.of(context).pushNamedAndRemoveUntil(_getRouteNameForIndex(index), (_) => false);
      Navigator.of(context).pushNamed(_getRouteNameForIndex(index));
    } else {
      showCustomBottomSheet();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ...List.generate(
              4,
              (index) {
                final isActive = bottomNavigationBarIndex == index;
                return GestureDetector(
                  onTap: () {
                    _onItemTapped(index);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        duration: const Duration(milliseconds: 900),
                        scale: isActive ? 1.4 : 1.0,
                        child: Image.asset(
                          _getIconForIndex(index),
                          width: 30,
                          height: 30,
                          // color: isActive ? Colors.deepPurpleAccent : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getLabelForIndex(index),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? Colors.deepPurpleAccent : Colors.grey,
                        ),
                      ).animate().slideY(begin: 0.5, end: 0).fadeIn(),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return AssetsData.home;
      case 1:
        return AssetsData.dateConversionIcon;
      case 2:
        return AssetsData.moonIcon;
      // case 2:
      //   return AssetsData.moonEclipseIcon;
      case 3:
        return AssetsData.more;
      default:
        return '';
    }
  }

  String _getRouteNameForIndex(int index) {
    switch (index) {
      case 0:
        return AppRoutesNames.mainHomepage;
      case 1:
        return AppRoutesNames.dateConversionView;
      case 2:
        return AppRoutesNames.moonPhaseView;
      // case 2:
      //   return AppRoutesNames.eclipseView;
      case 3:
        return "MORE";
      default:
        return '';
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return "HOME".tr();
      case 1:
        return "DATE_CONVERSION".tr();
      case 2:
        return 'MOON_PHASE'.tr();
      // case 2:
      //   return 'ECLIPSE'.tr();
      case 3:
        return 'MORE'.tr();
      default:
        return '';
    }
  }
}
