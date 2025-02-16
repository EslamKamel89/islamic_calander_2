import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_calander_2/core/globals/calc_method_settings.dart';
import 'package:islamic_calander_2/core/heleprs/determine_position.dart';
import 'package:islamic_calander_2/core/heleprs/format_date.dart';
import 'package:islamic_calander_2/core/heleprs/int_parse.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/models/api_response_model.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';
import 'package:islamic_calander_2/core/widgets/custom_fading_widget.dart';
import 'package:islamic_calander_2/features/date_conversion/domain/repo/date_conversion_repo.dart';
import 'package:islamic_calander_2/features/date_conversion/presentation/views/widgets/data_selector.dart';
import 'package:islamic_calander_2/features/main_homepage/controllers/params.dart';
import 'package:islamic_calander_2/features/main_homepage/cubits/moon_image/moon_image_cubit.dart';
import 'package:islamic_calander_2/features/main_homepage/cubits/prayers_time_api/prayers_time_api_cubit.dart';
import 'package:islamic_calander_2/features/main_homepage/models/prayers_time_model.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';
import 'package:islamic_calander_2/utils/styles/styles.dart';

class AllPraysTimeWidget extends StatefulWidget {
  const AllPraysTimeWidget({
    super.key,
  });

  @override
  State<AllPraysTimeWidget> createState() => _AllPraysTimeWidgetState();
}

class _AllPraysTimeWidgetState extends State<AllPraysTimeWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrayerTimesApiCubit(params: PrayerTimeParams()),
      child: const AppPrayersTimeBuilder(),
    );
  }
}

class AppPrayersTimeBuilder extends StatefulWidget {
  const AppPrayersTimeBuilder({super.key});

  @override
  State<AppPrayersTimeBuilder> createState() => _AppPrayersTimeBuilderState();
}

class _AppPrayersTimeBuilderState extends State<AppPrayersTimeBuilder> {
  DateTime selectedDate = DateTime.now();
  String? newHijriDate;
  late PrayerTimesApiCubit cubit;
  late MoonImageCubit moonImageCubit;
  @override
  void initState() {
    cubit = context.read<PrayerTimesApiCubit>();
    moonImageCubit = context.read<MoonImageCubit>();
    _getPrayerTime();
    _getNewHijri();
    _selectedPrayerMethodNotifier();
    _checkUserCountryNotifier();
    super.initState();
  }

  /// i used this function to determine the prayer time calculation method based on position if there are no cached calculation method
  void _checkUserCountryNotifier() {
    positionNotifier.addListener(() async {
      await checkUserCountry();
    });
  }

  void _selectedPrayerMethodNotifier() {
    selectedPrayersNotifier.addListener(() {
      cubit.params = cubit.params.copyWith(method: selectedPrayersNotifier.value);
      if (mounted) {
        cubit.getPrayerTime();
      }
    });
  }

  Future _getNewHijri() async {
    DateConversionRepo repo = serviceLocator();
    final response = await repo.getDateConversion(selectedDate, DataProcessingOption.regular);
    response.fold((_) {}, (model) {
      if (mounted) {
        setState(() {
          newHijriDate = model.newHijriUpdated;
        });
      }
    });
  }

  Future _getPrayerTime() async {
    final positionInMemory = serviceLocator<GeoPosition>().getPositionInMemory();
    if (positionInMemory != null) {
      pr('calling cubit.getPrayerTime() in  AppPrayersTimeBuilder widget directly because positionInMemory is not null: ${positionNotifier.value}');
      cubit.params = cubit.params.copyWith(
        latitude: positionInMemory.latitude,
        longitude: positionInMemory.longitude,
        method: IslamicOrganization.muslimWorldLeague,
        latitudeAdjustmentMethod: LatitudeAdjustmentMethod.angleBased,
        date: selectedDate,
      );
      await cubit.getPrayerTime();
      return;
    }
    positionNotifier.addListener(() async {
      pr('listener in AppPrayersTimeBuilder widget is called because position is changed: ${positionNotifier.value}');
      if (positionNotifier.value == null) return;
      cubit.params = cubit.params.copyWith(
        latitude: positionNotifier.value!.latitude,
        longitude: positionNotifier.value!.longitude,
        method: IslamicOrganization.muslimWorldLeague,
        latitudeAdjustmentMethod: LatitudeAdjustmentMethod.angleBased,
        date: selectedDate,
      );
      await cubit.getPrayerTime();
    });
    // do {
    //   Position? position = serviceLocator<GeoPosition>().getPositionInMemory();
    //   if ([position, position?.latitude, position?.longitude].contains(null)) {
    //     await Future.delayed(const Duration(seconds: 1));
    //     continue;
    //   }

    //   // pr(position.longitude, t);
    //   cubit.params = cubit.params.copyWith(
    //     latitude: position!.latitude,
    //     longitude: position.longitude,
    //     method: IslamicOrganization.muslimWorldLeague,
    //     latitudeAdjustmentMethod: LatitudeAdjustmentMethod.angleBased,
    //     date: selectedDate,
    //   );
    //   await cubit.getPrayerTime();
    //   await Future.delayed(const Duration(seconds: 1));
    // } while (cubit.state.data == null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesApiCubit, ApiResponseModel<PrayersTimeModel>>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                        onTap: () async {
                          selectedDate = selectedDate.subtract(const Duration(days: 1));
                          _getNewHijri();
                          Position? position = await serviceLocator<GeoPosition>().position();
                          if ([position, position?.latitude, position?.longitude].contains(null)) {
                            return;
                          }
                          cubit.params = cubit.params.copyWith(
                              date: selectedDate, latitude: position!.latitude, longitude: position.longitude);
                          cubit.getPrayerTime();
                          moonImageCubit.dateTime = selectedDate;
                          moonImageCubit.moonImage();
                        },
                        child: Icon(Icons.arrow_back_ios_rounded, size: 30.w)),
                    Column(
                      children: [
                        txt(formateDateDetailed(selectedDate)),
                        if (newHijriDate != null) txt(newHijriDate ?? ''),
                      ],
                    ),
                    InkWell(
                        onTap: () async {
                          selectedDate = selectedDate.add(const Duration(days: 1));
                          _getNewHijri();
                          Position? position = await serviceLocator<GeoPosition>().position();
                          if ([position, position?.latitude, position?.longitude].contains(null)) {
                            return;
                          }
                          cubit.params = cubit.params.copyWith(
                              date: selectedDate, latitude: position!.latitude, longitude: position.longitude);
                          cubit.getPrayerTime();
                          moonImageCubit.dateTime = selectedDate;
                          moonImageCubit.moonImage();
                        },
                        child: Icon(Icons.arrow_forward_ios_rounded, size: 30.w)),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Material(
                borderRadius: BorderRadius.circular(15.w),
                elevation: 2,
                shadowColor: Colors.grey.withOpacity(0.3),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.w),
                    color: Colors.white,
                  ),
                  child: PrayersWidget(state.data).animate().fade(duration: 1000.ms, begin: 0, end: 1),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PrayersWidget extends StatelessWidget {
  const PrayersWidget(
    this.model, {
    super.key,
  });
  final PrayersTimeModel? model;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 5.w),
        PrayTimeWidget(
          pray: 'Fajr',
          imagePath: AssetsData.fajr,
          time: model?.fajr,
          // currentTimeZone: model.currentTimeZone,
        ),
        PrayTimeWidget(
          pray: 'Sunrise',
          imagePath: AssetsData.three,
          time: model?.sunrise,
          // currentTimeZone: model.currentTimeZone,
        ),
        PrayTimeWidget(
          pray: 'Dhuhr',
          imagePath: AssetsData.two,
          time: model?.dhuhr,
          // currentTimeZone: model.currentTimeZone,
        ),
        PrayTimeWidget(
          pray: 'Asr',
          imagePath: AssetsData.one,
          time: model?.asr,
          // currentTimeZone: model.currentTimeZone,
        ),
        PrayTimeWidget(
          pray: 'Maghrib',
          imagePath: AssetsData.four,
          time: model?.maghrib,
          // currentTimeZone: model.currentTimeZone,
        ),
        PrayTimeWidget(
          pray: 'Isha',
          imagePath: AssetsData.five,
          time: model?.isha,
          // currentTimeZone: model.currentTimeZone,
        ),
        SizedBox(width: 5.w),
      ],
    );
  }
}

class PrayTimeWidget extends StatelessWidget {
  const PrayTimeWidget({super.key, required this.pray, required this.imagePath, required this.time});
  final String pray;
  final String? time;
  final String imagePath;
  // final String? currentTimeZone;
  @override
  Widget build(BuildContext context) {
    // if (dateTime == null) return const SizedBox();
    // DateTime? localTime = dateTime == null || currentTimeZone == null ? null : utcToLocal(dateTime!, currentTimeZone!);
    String? amOrpm;
    String? hourStr = time?.split(':').first;
    String? minStr = time?.split(':').last;
    if ([hourStr, minStr, time].contains(null)) {
      return _loadingWidget();
    }
    int? hour = intParse(hourStr);
    amOrpm = hour != null && hour >= 12 ? 'PM' : 'AM';
    hour = hour == null
        ? null
        : hour > 12
            ? hour - 12
            : hour;

    return SizedBox(
      // height: 110.h,
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          txt(pray, e: St.bold12),
          const SizedBox(height: 5),
          _buildImage(),
          const SizedBox(height: 5),
          txt('${hour.toString().padLeft(2, '0')}:$minStr\n$amOrpm', e: St.reg12),
        ],
      ),
    );
  }

  Column _loadingWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        txt(pray, e: St.bold12),
        const SizedBox(height: 5),
        CustomFadingWidget(
          child: _buildImage(),
        ),
        const SizedBox(height: 5),
        CustomFadingWidget(child: txt('00:00', e: St.reg12)),
      ],
    );
  }

  Container _buildImage() {
    return Container(
      width: 25.w,
      height: 30.w,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: Image.asset(imagePath, fit: BoxFit.fill),
    );
  }
}
