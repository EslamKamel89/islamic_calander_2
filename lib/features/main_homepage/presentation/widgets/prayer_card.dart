import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/city_widget.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/moon_phase_image.dart';

class PrayerCard extends StatefulWidget {
  final String prayerName;
  final Duration timeRemaining;
  const PrayerCard({
    super.key,
    required this.prayerName,
    required this.timeRemaining,
  });

  @override
  State<PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<PrayerCard> {
  @override
  Widget build(BuildContext context) {
    // Format the remaining time as HH:MM:SS.
    final hours = widget.timeRemaining.inHours;
    final minutes = widget.timeRemaining.inMinutes.remainder(60);
    final seconds = widget.timeRemaining.inSeconds.remainder(60);
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
      child: SizedBox(
        // constraints: BoxConstraints(minHeight: context.height / 4),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.black, Colors.black, Colors.black87, Colors.black54, Color(0xFF0D3B66)],
              stops: [0.0, 0.5, 0.65, 0.8, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
                // height: context.height * 0.3,
              ),
              const Positioned(left: 0, child: MoonPhaseImage()),
              Container(
                width: context.width,
                padding: EdgeInsets.only(left: context.width * 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 10,
                      // width: double.infinity,
                    ),
                    const Text(
                      'Next Prayer',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.prayerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Time Remaining:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
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

                    Transform.translate(
                      offset: Offset(-40.w, 0),
                      child: const CityWidget(),
                    ),
                    const SizedBox(height: 5),
                    // const NewHijrWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrayerCardLoading extends StatelessWidget {
  const PrayerCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
