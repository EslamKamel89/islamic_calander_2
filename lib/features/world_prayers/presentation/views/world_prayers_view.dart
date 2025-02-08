import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:islamic_calander_2/core/widgets/default_drawer.dart';

class WorldPrayersView extends StatefulWidget {
  const WorldPrayersView({super.key});

  @override
  State<WorldPrayersView> createState() => _WorldPrayersViewState();
}

class _WorldPrayersViewState extends State<WorldPrayersView> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: context.secondaryHeaderColor,
      appBar: AppBar(
        // backgroundColor: Colors.white.withOpacity(0.3),
        title: const Text(
          'World Prayers',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      endDrawer: const DefaultDrawer(opacity: 0.7),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
