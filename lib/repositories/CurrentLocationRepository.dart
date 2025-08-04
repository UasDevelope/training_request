import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocationRepository {
  Future<Position> _getSafePosition() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      throw Exception("Error getting current position: $e");
    }
  }

  Future<(double lat, double long, String location)>
      getCurrentLocation() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) throw Exception("Location services are disabled");

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location permission denied");
    }

    int retries = 0;
    while (retries < 3) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        final place = placemarks.first;
        final locationName =
            "${place.locality}, ${place.administrativeArea}, ${place.country}";

        return (position.latitude, position.longitude, locationName);
      } on PlatformException catch (e) {
        if (e.code == "IO_ERROR" &&
            e.message?.contains("kCLErrorDomain Code=2") == true) {
          retries++;
          log("⚠️ GPS not ready, retrying... attempt: $retries");
          await Future.delayed(Duration(seconds: 2));
          continue;
        } else {
          rethrow;
        }
      } catch (e) {
        rethrow;
      }
    }

    throw Exception("Failed to get location after multiple attempts.");
  }
}
