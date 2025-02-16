import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/features/main_homepage/cubits/update_next_prayer_api/update_next_prayer_api_cubit.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/city_widget.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/moon_phase_image.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';

class NextPrayerWidget extends StatefulWidget {
  const NextPrayerWidget({
    super.key,
  });

  @override
  State<NextPrayerWidget> createState() => _NextPrayerWidgetState();
}

class _NextPrayerWidgetState extends State<NextPrayerWidget> {
  Widget cityWidget = const CityWidget();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateNextPrayerApiCubit, UpdateNextPrayerApiState>(
      builder: (context, state) {
        // if (state.nextPrayer == null || state.timeRemaining == null) return const SizedBox();
        if (state.response != ResponseEnum.success) {
          return PrayerCard2(prayerName: '', timeRemaining: const Duration(seconds: 0), cityWidget: cityWidget)
              .animate(onPlay: (controller) => controller.repeat)
              .fade(duration: 500.ms, begin: 0, end: 0.5);
        }
        return PrayerCard2(
          prayerName: state.nextPrayer ?? '',
          timeRemaining: state.timeRemaining ?? const Duration(seconds: 0),
          cityWidget: cityWidget,
        );
      },
    );
  }
}

class PrayerCard2 extends StatefulWidget {
  final String prayerName;
  final Duration timeRemaining;
  final Widget cityWidget;
  const PrayerCard2({
    super.key,
    required this.prayerName,
    required this.timeRemaining,
    required this.cityWidget,
  });

  @override
  State<PrayerCard2> createState() => _PrayerCard2State();
}

class _PrayerCard2State extends State<PrayerCard2> {
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
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: context.height / 4),
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
              SizedBox(
                width: double.infinity,
                height: context.height * 0.3,
              ),
              const Positioned(left: 0, child: MoonPhaseImage()),
              Positioned(
                right: 0,
                child: SizedBox(
                  width: context.width * 0.55,
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
                      // Text(
                      //   customNow().toString(),
                      //   style: const TextStyle(
                      //     color: Colors.white70,
                      //     fontSize: 20,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Transform.translate(
                        offset: Offset(-40.w, 0),
                        child: widget.cityWidget,
                      ),
                      const SizedBox(height: 5),
                      // const NewHijrWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
                  const SizedBox(height: 10),
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
                  // Text(
                  //   customNow().toString(),
                  //   style: const TextStyle(
                  //     color: Colors.white70,
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  const CityWidget(),
                  const SizedBox(height: 5),
                  // const NewHijrWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
