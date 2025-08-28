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
    try {
      // Check if location services are enabled
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        throw Exception("Location services are disabled");
      }

      // Check and request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        // Wait a bit for the permission dialog to be processed
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied");
      }

      int retries = 0;
      const maxRetries = 3;
      
      while (retries < maxRetries) {
        try {
          // Use a more lenient accuracy for better compatibility
          final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 15),
          );

          // Try to get location name, but don't fail if geocoding doesn't work
          String locationName = "Current Location";
          try {
            final placemarks = await placemarkFromCoordinates(
              position.latitude,
              position.longitude,
            );

            if (placemarks.isNotEmpty) {
              final place = placemarks.first;
              locationName =
                  "${place.locality ?? 'Unknown'}, ${place.administrativeArea ?? 'Unknown'}, ${place.country ?? 'Unknown'}";
            }
          } catch (geocodingError) {
            log("Geocoding failed, using fallback: $geocodingError");
            // Continue with fallback location name
          }

          return (position.latitude, position.longitude, locationName);
        } on PlatformException catch (e) {
          log("Platform exception: ${e.code} - ${e.message}");
          
          // Handle specific iPad/iOS location errors
          if (e.code == "IO_ERROR" || 
              e.code == "LOCATION_SERVICE_DISABLED" ||
              e.message?.contains("kCLErrorDomain") == true) {
            retries++;
            log("⚠️ Location service issue, retrying... attempt: $retries");
            if (retries < maxRetries) {
              await Future.delayed(Duration(seconds: 2 * retries)); // Exponential backoff
              continue;
            }
          }
          
          // For other platform exceptions, throw immediately
          throw Exception("Location access error: ${e.message}");
        } catch (e) {
          log("Location error: $e");
          if (retries < maxRetries - 1) {
            retries++;
            await Future.delayed(Duration(seconds: 1));
            continue;
          }
          throw Exception("Failed to get location: $e");
        }
      }

      throw Exception("Failed to get location after multiple attempts");
    } catch (e) {
      log("Location repository error: $e");
      rethrow;
    }
  }
}
