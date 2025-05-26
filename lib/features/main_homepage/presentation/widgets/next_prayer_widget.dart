import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_calander_2/core/heleprs/prayer_name_tr.dart';
import 'package:islamic_calander_2/features/home_widget/controller/home_widget_controller.dart';
import 'package:islamic_calander_2/features/main_homepage/cubits/update_next_prayer_api/update_next_prayer_api_cubit.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/prayer_card.dart';

class NextPrayerWidget extends StatefulWidget {
  const NextPrayerWidget({
    super.key,
  });

  @override
  State<NextPrayerWidget> createState() => _NextPrayerWidgetState();
}

class _NextPrayerWidgetState extends State<NextPrayerWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateNextPrayerApiCubit, UpdateNextPrayerApiState>(
      builder: (context, state) {
        // if (state.nextPrayer == null || state.timeRemaining == null) return const SizedBox();
        // if (state.response != ResponseEnum.success) {
        //   return const PrayerCard(prayerName: '', timeRemaining: Duration(seconds: 0))
        //       .animate(onPlay: (controller) => controller.repeat)
        //       .fade(duration: 500.ms, begin: 0, end: 0.5);
        // }
        HomeWidgetController.updateNextPrayer(state.nextPrayer, _formateTimeRemaining(state.timeRemaining));
        return PrayerCard(
          prayerName: state.nextPrayer != null ? prayerNameTr(state.nextPrayer!) : 'CALC'.tr(),
          timeRemaining: state.timeRemaining ?? const Duration(seconds: 0),
        );
      },
    );
  }

  String _formateTimeRemaining(Duration? timeRemaining) {
    if (timeRemaining == null) return '00:00';
    final hours = timeRemaining.inHours;
    final minutes = timeRemaining.inMinutes.remainder(60);
    final seconds = timeRemaining.inSeconds.remainder(60);
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
