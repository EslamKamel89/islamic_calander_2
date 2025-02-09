import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_calander_2/core/enums/response_state.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/widgets/default_drawer.dart';
import 'package:islamic_calander_2/features/main_homepage/presentation/widgets/all_prays_time_widget.dart';
import 'package:islamic_calander_2/features/world_prayers/presentation/cubits/cubit/prayer_time_by_position_cubit.dart';
import 'package:islamic_calander_2/utils/assets/assets.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class WorldPrayersView extends StatefulWidget {
  const WorldPrayersView({super.key});

  @override
  State<WorldPrayersView> createState() => _WorldPrayersViewState();
}

class _WorldPrayersViewState extends State<WorldPrayersView> {
  Marker? _marker;

  void _handleTap(LatLng latlng) {
    setState(() {
      _marker = Marker(
        point: latlng,
        child: Icon(
          MdiIcons.mosque,
          color: Colors.red,
          size: 40,
        ),
      );
    });
    _showLatLngDialog(latlng);
  }

  void _showLatLngDialog(LatLng latlng) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog.fullscreen(
        backgroundColor: Colors.white.withOpacity(0.7),
        child: WorldPrayersModal(latLng: latlng),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'World Prayers',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        endDrawer: const DefaultDrawer(opacity: 0.7),
        body: FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(21.4225, 39.8262),
            initialZoom: 5,
            onTap: (tapPosition, latlng) => _handleTap(latlng),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.app',
            ),
            if (_marker != null) MarkerLayer(markers: [_marker!]),
            // const RichAttributionWidget(
            //   attributions: [
            //     // TextSourceAttribution(
            //     //   'OpenStreetMap contributors',
            //     //   // onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
            //     // ),
            //     // Also add images...
            //   ],
            // ),
          ],
        ));
  }
}

class WorldPrayersModal extends StatefulWidget {
  const WorldPrayersModal({
    super.key,
    required this.latLng,
  });
  final LatLng latLng;

  @override
  State<WorldPrayersModal> createState() => _WorldPrayersModalState();
}

class _WorldPrayersModalState extends State<WorldPrayersModal> {
  @override
  Widget build(BuildContext context) {
    final lat = widget.latLng.latitude.toStringAsFixed(3);
    final long = widget.latLng.longitude.toStringAsFixed(3);
    return BlocProvider(
      create: (context) => PrayerTimeByPositionCubit()..getPrayersTimes(widget.latLng),
      child: BlocBuilder<PrayerTimeByPositionCubit, PrayerTimeByPositionState>(
        builder: (context, state) {
          return Container(
            width: context.width,
            height: context.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AssetsData.worldPrayersBackground),
              ),
            ),
            // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 100),
                const Text(
                  'Coordinates',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Latitude: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      lat,
                      style: TextStyle(fontSize: 25, color: context.primaryColor),
                    ),
                    const Text(
                      ' | Longitude: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      long,
                      style: TextStyle(fontSize: 25, color: context.primaryColor),
                    ),
                  ],
                ),
                if (state.response == ResponseEnum.loading) const Center(child: CircularProgressIndicator()),
                if (state.response == ResponseEnum.success)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Time Zone: ',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            state.currentTimeZone ?? '',
                            style: TextStyle(fontSize: 25, color: context.primaryColor),
                          ),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: WorldPrayersWidget(state)),
                    ],
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class WorldPrayersWidget extends StatelessWidget {
  const WorldPrayersWidget(
    this.state, {
    super.key,
  });
  final PrayerTimeByPositionState state;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 5.w),
        PrayTimeWidget(
          pray: 'Fajr',
          imagePath: AssetsData.three,
          dateTime: state.prayerTimes?.fajr,
          currentTimeZone: state.currentTimeZone,
        ),
        PrayTimeWidget(
          pray: 'Dhuhr',
          imagePath: AssetsData.two,
          dateTime: state.prayerTimes?.dhuhr,
          currentTimeZone: state.currentTimeZone,
        ),
        PrayTimeWidget(
          pray: 'Asr',
          imagePath: AssetsData.one,
          dateTime: state.prayerTimes?.asr,
          currentTimeZone: state.currentTimeZone,
        ),
        PrayTimeWidget(
          pray: 'Maghrib',
          imagePath: AssetsData.four,
          dateTime: state.prayerTimes?.maghrib,
          currentTimeZone: state.currentTimeZone,
        ),
        PrayTimeWidget(
          pray: 'Isha',
          imagePath: AssetsData.five,
          dateTime: state.prayerTimes?.isha,
          currentTimeZone: state.currentTimeZone,
        ),
        SizedBox(width: 5.w),
      ],
    );
  }
}
