import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:islamic_calander_2/core/globals.dart';
import 'package:islamic_calander_2/core/heleprs/print_helper.dart';
import 'package:islamic_calander_2/core/heleprs/snackbar.dart';
import 'package:latlong2/latlong.dart';

Position? _position;

class GeoPosition {
  Future<Position?> position() async {
    if (_position != null) {
      return _position;
    }
    _position = await determinePosition();
    return _position;
  }

  Position? getPositionInMemory() {
    return _position;
  }
}

Future<Position?> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  BuildContext? context = navigatorKey.currentContext;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // if (context != null) showSnackbar('Error', 'Location services are disabled.', true);
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // if (context != null) showSnackbar('Error', 'Location services are denied.', true);
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    if (context != null) {
      // showSnackbar('Error', 'Location permissions are permanently denied, we cannot request permissions.', true);
    }
    return null;
  }

  return await Geolocator.getCurrentPosition();
}

Future checkPermissionsLoop() async {
  bool serviceEnabled;
  LocationPermission permission;
  BuildContext? context = navigatorKey.currentContext;
  bool keepChecking = true;
  do {
    pr('still in chekc permissions loop');
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context != null) showSnackbar('Error', 'Location services are disabled.', true);
      await Future.delayed(const Duration(seconds: 10));
      // checkPermissionsLoop();
      continue;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context != null) showSnackbar('Error', 'Location services are denied.', true);
        await Future.delayed(const Duration(seconds: 10));
        // checkPermissionsLoop();
        continue;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context != null) {
        showSnackbar('Error', 'Location permissions are permanently denied, we cannot request permissions.', true);
        await Future.delayed(const Duration(seconds: 10));
        // checkPermissionsLoop();
      }
      continue;
    }
    keepChecking = false;
    pr('exiting check permissions loop');
    break;
  } while (keepChecking);
}

Future<String?> getCityName() async {
  final position = await determinePosition();
  if (position == null) return null;
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

  if (placemarks.isNotEmpty) {
    // return "${placemarks.first.administrativeArea}";
    return placemarks.first.administrativeArea;
  } else {
    return null;
  }
}

Future<String?> getCityNameByPosition(LatLng? position) async {
  if (position == null) return null;
  List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

  if (placemarks.isNotEmpty) {
    return "${placemarks.first.administrativeArea}\n${placemarks.first.country}";
  } else {
    return null;
  }
}
