import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';
import 'package:lottie/lottie.dart' as Lot;

class CityWidget extends StatefulWidget {
  const CityWidget({super.key});

  @override
  State<CityWidget> createState() => _CityWidgetState();
}

class _CityWidgetState extends State<CityWidget> {
  String? deviceLocation;
  @override
  void initState() {
    getCityName().then((city) {
      if (mounted) {
        setState(() {
          deviceLocation = city;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (deviceLocation == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (deviceLocation == null)
            Opacity(
              opacity: 0.1,
              child: Lot.Lottie.asset(
                AssetsData.map,
                width: 40,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          if (deviceLocation != null)
            SizedBox(
              child: Lot.Lottie.asset(
                AssetsData.map,
                width: 40,
                height: 50,
                fit: BoxFit.cover,
              ),
            ).animate().moveX(duration: 1000.ms, begin: 200, end: 0),
          const SizedBox(width: 5),
          if (deviceLocation != null)
            Expanded(
              child: AutoSizeText(
                deviceLocation!,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ).animate().moveX(duration: 1000.ms, begin: 200, end: 0),
        ],
      ),
    );
  }
}
