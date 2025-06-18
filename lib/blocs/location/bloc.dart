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
    on<RequestEnableLocation>((event, emit) async {
      log("RequestEnableLocation Triggered");
      emit(LocationLoading());

      try {
        // Fetch permission + location in one call
        final (lat, long, locationName) =
            await currentLocationRepository.getCurrentLocation();

        emit(LocationLoadedState(lat: lat, long: long, location: locationName));

        // Optionally update the location on server
        try {
          final response = await locationRepository.updateLocation(
            latitude: lat,
            longitude: long,
            locationName: locationName,
          );
          emit(LocationSucessState(message: response["message"]));
        } catch (e) {
          emit(LocationErrorState(message: e.toString()));
        }

        log("Location fetched successfully: $lat, $long");
      } catch (e) {
        log("Location fetch failed: $e");
        emit(LocationErrorState(message: e.toString()));
      }
    });
  }
}
