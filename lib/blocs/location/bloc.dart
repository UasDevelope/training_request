import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:training_request/api/api_exception.dart';
import 'package:training_request/blocs/location/event.dart';
import 'package:training_request/blocs/location/state.dart';
import 'package:training_request/repositories/location_repository.dart';

import '../../repositories/CurrentLocationRepository.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationRepository locationRepository;
  CurrentLocationRepository currentLocationRepository;
  
  LocationBloc(this.locationRepository, this.currentLocationRepository)
    : super(LocationInitialState()) {
    
    on<CheckLocationPermission>((event, emit) async {
      try {
        final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
        final permission = await Geolocator.checkPermission();
        
        if (isServiceEnabled && 
            (permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always)) {
          // Location is already enabled, try to get current location
          try {
            final (lat, long, locationName) = await currentLocationRepository
                .getCurrentLocation()
                .timeout(const Duration(seconds: 10));
            
            // Update server if possible
            try {
              await locationRepository.updateLocation(
                latitude: lat,
                longitude: long,
                locationName: locationName,
              );
              emit(LocationSucessState(message: "Location updated successfully"));
            } catch (e) {
              log("Server update failed: $e");
              emit(LocationSucessState(message: "Location enabled successfully"));
            }
          } catch (e) {
            log("Error getting location: $e");
            emit(LocationInitialState());
          }
        } else {
          // Location needs to be enabled
          emit(LocationInitialState());
        }
      } catch (e) {
        log("Error checking location permission: $e");
        emit(LocationInitialState());
      }
    });
    
    on<RequestEnableLocation>((event, emit) async {
      log("RequestEnableLocation Triggered");
      emit(LocationLoading());

      try {
        // Add timeout to prevent hanging
        final (lat, long, locationName) = await currentLocationRepository
            .getCurrentLocation()
            .timeout(const Duration(seconds: 30));

        log("Location obtained: $lat, $long, $locationName");

        // Optionally update the location on server
        try {
          final response = await locationRepository.updateLocation(
            latitude: lat,
            longitude: long,
            locationName: locationName,
          );
          log("Server update successful: ${response["message"]}");
          emit(LocationSucessState(message: response["message"]));
        } catch (e) {
          log("Server update failed, but location was obtained: $e");
          // Even if server update fails, we still have location data
          emit(LocationSucessState(message: "Location enabled successfully"));
        }

        log("Location fetch successfully completed");
      } catch (e) {
        log("Location fetch failed: $e");
        
        // Provide more specific error messages
        String errorMessage;
        if (e.toString().contains("TimeoutException")) {
          errorMessage = "Location request timed out. Please check your GPS settings and try again.";
        } else if (e.toString().contains("Location services are disabled")) {
          errorMessage = "Location services are disabled on your device. Please enable location services in Settings > Privacy & Security > Location Services.";
        } else if (e.toString().contains("Location permission denied")) {
          errorMessage = "Location permission is required. Please grant location permission in Settings > Privacy & Security > Location Services > Training Request.";
        } else if (e.toString().contains("Failed to get location")) {
          errorMessage = "Unable to get your current location. This might be due to poor GPS signal or network issues. Please try again.";
        } else {
          errorMessage = "Unable to access location. Please check your device settings and try again.";
        }
        
        emit(LocationErrorState(message: errorMessage));
      }
    });
  }
}
