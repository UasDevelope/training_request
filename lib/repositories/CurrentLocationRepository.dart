import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CurrentLocationRepository {
  Future<(double lat, double long, String location)>
  getCurrentLocation() async {
    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location permission denied.");
    }

    // Get coordinates
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Get location name
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemarks.first;
    final locationName =
        "${place.locality}, ${place.administrativeArea}, ${place.country}";

    return (position.latitude, position.longitude, locationName);
  }
}
