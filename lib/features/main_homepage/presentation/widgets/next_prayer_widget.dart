import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/features/main_homepage/cubits/prayer_times_today/prayers_times_today_cubit.dart';
import 'package:islamic_calander_2/features/main_homepage/cubits/prayer_times_today/prayers_times_today_state.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';

class NextPrayerWidget extends StatelessWidget {
  const NextPrayerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayersTimesTodayCubit, PrayersTimesTodayState>(
      builder: (context, state) {
        // if (state.nextPrayer == null || state.timeRemaining == null) return const SizedBox();
        if (state.response != ResponseEnum.success) {
          return const PrayerCard(prayerName: '', timeRemaining: Duration(seconds: 0))
              .animate(onPlay: (controller) => controller.repeat)
              .fade(duration: 500.ms, begin: 0, end: 0.5);
        }
        return PrayerCard(
            prayerName: state.nextPrayer ?? '', timeRemaining: state.timeRemaining ?? const Duration(seconds: 0));
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
        // padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          // Gradient background for an attractive look
          gradient: LinearGradient(
            colors: [context.primaryColor.withOpacity(0.4), context.primaryColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Islamic themed icon; you can replace with a custom asset if needed.
            // Icon(
            //   MdiIcons.mosque,
            //   color: Colors.white,
            //   size: 40.w,
            // ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  AssetsData.islamicBorder,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Next Prayer',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    prayerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
