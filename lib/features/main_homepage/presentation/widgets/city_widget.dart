import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/widgets/sizer.dart';
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
          // const Icon(Icons.location_on, color: Colors.red),
          Lot.Lottie.asset(
            AssetsData.map,
            width: 40,
            height: 50,
            fit: BoxFit.cover,
          ),
          const Sizer(),
          Text(deviceLocation ?? '',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }
}
