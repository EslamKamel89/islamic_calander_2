import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_calander_2/core/globals.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
import 'package:latlong2/latlong.dart';

Future<Position?> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  BuildContext? context = navigatorKey.currentContext;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    if (context != null)
      showSnackbar('Error', 'Location services are disabled.', true);
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (context != null)
        showSnackbar('Error', 'Location services are denied.', true);
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    if (context != null) {
      showSnackbar(
          'Error',
          'Location permissions are permanently denied, we cannot request permissions.',
          true);
    }
    return null;
  }

  return await Geolocator.getCurrentPosition();
}

Future<String?> getCityName() async {
  final position = await determinePosition();
  if (position == null) return null;
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  if (placemarks.isNotEmpty) {
    // return "${placemarks.first.administrativeArea}";
    return placemarks.first.administrativeArea;
  } else {
    return null;
  }
}

Future<String?> getCityNameByPosition(LatLng? position) async {
  if (position == null) return null;
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  if (placemarks.isNotEmpty) {
    return "${placemarks.first.administrativeArea}\n${placemarks.first.country}";
  } else {
    return null;
  }
}
