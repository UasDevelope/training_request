import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:training_request/blocs/home/state.dart';
import 'package:training_request/repositories/home.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../dumy/home.dart';
import '../../models/home.dart';
import '../../repositories/CurrentLocationRepository.dart';
import '../../repositories/location_repository.dart';
import '../../utils/const/app_img.dart';
import 'event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  CurrentLocationRepository currentLocationRepository;
  HomeRepository homeRepository;
  HomeBloc({
    required this.currentLocationRepository,
    required this.homeRepository,
  }) : super(HomeInitialState()) {
    on<HomeLoadedEvent>(_onLoadHomeData);
    on<UpdateLiveLocationEvent>(_onUpdateLiveLocation);
  }
  void startLiveTracking() {
    final locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (position) {
        add(UpdateLiveLocationEvent()); // ✅ Triggers sending location via socket
      },
    );
  }

  Future<void> _onUpdateLiveLocation(
    UpdateLiveLocationEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final (lat, long, locationName) =
          await currentLocationRepository.getCurrentLocation();

      log("📡 Sending location via WebSocket: $lat, $long");

      await homeRepository.updateLocationEvent(
        lat,
        long,
        locationName,
        "user_123", // custom user ID
        "continuous",
      );
    } catch (e) {
      log("❌ Failed to update location via socket: $e");
    }
  }

  Future<void> _onLoadHomeData(
    HomeLoadedEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    try {
      final homeDummy = HomeDummy();
      final homedata =
          homeDummy.homeData.map((e) => HomeModel.fromMap(e)).toList();
      log("HomeData$homedata");
      final Set<Polyline> polyLines = {};
      final Set<Marker> marker = {};
      final cameraPosition = CameraPosition(
        target: LatLng(homedata[0].studentLat, homedata[0].studentLong),
        zoom: 10,
      );
      for (var i = 0; i < homedata.length; i++) {
        final item = homedata[i];
        final studentLatLng = LatLng(item.studentLat, item.studentLong);
        final driverLatLng = LatLng(item.driverLat, item.driverLong);
        final studentIcon = await _getCustomIcon(AppImages.start);
        final driverIcon = await _getCustomIcon(AppImages.end);
        print("Student icon path: ${AppImages.start}");
        print("Driver icon path: ${AppImages.end}");
        marker.add(
          Marker(
            markerId: MarkerId('student_${i}'),
            position: studentLatLng,
            icon: studentIcon,
            infoWindow: InfoWindow(title: 'Student ${item.studentName}'),
          ),
        );
        marker.add(
          Marker(
            markerId: MarkerId('driver_${i}'),
            position: driverLatLng,
            icon: driverIcon,
            infoWindow: InfoWindow(title: 'Driver ${item.driverStateCountry}'),
          ),
        );
        final route = await _getPolyline(studentLatLng, driverLatLng);
        print('Polyline route for item $i: ${route.length} points');

        if (route.isNotEmpty) {
          polyLines.add(
            Polyline(
              polylineId: PolylineId('route_$i'),
              points: route,
              color: Color(0xFF4285F4),
              width: 5,
            ),
          );
        }
      }
      emit(
        HomeLoadedState(
          homeModel: homedata,
          cameraPosition: cameraPosition,
          polyLines: polyLines,
          marker: marker,
        ),
      );
    } catch (e) {
      log("Error in _onLoadHomeData: $e");
      // emit error state if needed
    }
  }

  Future<List<LatLng>> _getPolyline(LatLng start, LatLng end) async {
    final polylinePoints = PolylinePoints();

    final request = PolylineRequest(
      origin: PointLatLng(start.latitude, start.longitude),
      destination: PointLatLng(end.latitude, end.longitude),
      mode: TravelMode.driving,
    );

    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey:
          'AIzaSyCyyqHImZfYyt09rya-6YcD9wsTWbP0fsE', // Replace with env var in prod
      request: request,
    );

    if (result.points.isEmpty) return [];

    return result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
  }
}

Future<BitmapDescriptor> _getCustomIcon(String assetPath) async {
  return await BitmapDescriptor.fromAssetImage(
    ImageConfiguration(size: Size(48, 48)), // You can adjust size
    assetPath,
  );
}
