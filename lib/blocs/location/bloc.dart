import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:training_request/blocs/location/event.dart';
import 'package:training_request/blocs/location/state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitialState()) {
    on<RequestEnableLocation>((event, emit) async {
      log("Request Location Event Triggers");
      emit(LocationLoading());
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          emit(LocationPermissionDenied());
        } else {
          log("Location is Allowed");
          add(FetchLocation()); // Trigger FetchLocation if permission is granted
        }
      } catch (e) {
        log("Error: $e");
        emit(LocationErrorState(message: e.toString()));
      }
    });

    on<FetchLocation>((event, emit) async {
      emit(LocationLoading());
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        final place = placemarks.first;
        final locationName = "${place.locality}, ${place.administrativeArea}, ${place.country}";

        emit(LocationLoadedState(
          lat: position.latitude,
          long: position.longitude, location:locationName,
        ));
        log(position.longitude.toString());
        // emit(LocationSucessState(message: "Location is fetched"));
      } catch (e) {
        log("Error: $e");
        emit(LocationErrorState(message: e.toString()));
      }
    });
  }
}
