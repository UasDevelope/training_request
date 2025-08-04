import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:training_request/models/order.dart';
import 'package:training_request/repositories/CurrentLocationRepository.dart';
import 'package:training_request/utils/const/app_img.dart';

import '../../repositories/order_repo.dart';
import '../../utils/socket_utils.dart';
import 'event.dart';
import 'state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final CurrentLocationRepository currentLocationRepository;
  final OrderRepository orderRepository;
  final SocketService socketService;
  Position? _lastPosition;
  LatLng? _driverLatLng;
  List<OrderModel> _orders = [];
  Set<Polyline> _polyLines = {};
  Set<Marker> _markers = {};
  CameraPosition? _cameraPosition;
  GoogleMapController? _mapController;

  HomeBloc({
    required this.currentLocationRepository,
    required this.orderRepository,
    required this.socketService,
  }) : super(const HomeInitialState()) {
    on<HomeLoadedEvent>(_onLoadHomeData);
    on<UpdateLiveLocationEvent>(_onUpdateLiveLocation);
    on<UpdateLocation>(_onUpdateLocation);
    on<MapControllerInitialized>(_onMapControllerInitialized);
    on<HomeAcceptJobEvent>(_onAcceptJob);

    _initSocketListener();
  }

  void _initSocketListener() async {
    try {
      await socketService.initSocket();
      socketService
          .emit('trackBooking', {'bookingId': "6880ba6e37501160f81886bc"});

      socketService.on('error', (data) {
        log("Socket error: $data");
      });
      socketService.on('receiveLocation', (data) {
        log("Received location: $data");
      });
      // socketService.on('locationUpdated', (data) {
      //   if (data != null && data['location'] != null) {
      //     add(UpdateLocation(
      //       position: Position(
      //         latitude: data['location']['latitude']?.toDouble() ?? 0.0,
      //         longitude: data['location']['longitude']?.toDouble() ?? 0.0,
      //         timestamp: DateTime.now(),
      //         accuracy: 0,
      //         altitude: 0,
      //         heading: 0,
      //         speed: 0,
      //         speedAccuracy: 0,
      //         altitudeAccuracy: 0,
      //         headingAccuracy: 0,
      //       ),
      //     ));
      //   }
      // });
    } catch (e) {
      log("Socket initialization failed: $e");
      emit(const HomeErrorState("Failed to connect to server"));
    }
  }

  void startLiveTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (position) {
        if (_lastPosition != null &&
            _lastPosition!.latitude == position.latitude &&
            _lastPosition!.longitude == position.longitude) {
          return; // Skip if same location
        }
        _lastPosition = position;
        log("📍 New position: ${position.latitude}, ${position.longitude}");
        add(UpdateLiveLocationEvent());
      },
    );
  }

  Future<void> _onLoadHomeData(
      HomeLoadedEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoadingState());
    try {
      // Get current location
      final (driverLat, driverLong, driverLocation) =
          await currentLocationRepository.getCurrentLocation();
      _driverLatLng = LatLng(driverLat, driverLong);

      // Fetch orders
      final orders = await orderRepository.fetchBookings(event.endPoint);
      _orders = orders;

      // Cache location details and join socket rooms
      await socketService.waitUntilReady();
      for (var order in orders) {
        if (order.bookingId.isNotEmpty) {
          // socketService.emit('trackBooking', {'bookingId': order.bookingId});
        }
        if (order.location.coordinates.length >= 2) {
          try {
            final placemarks = await placemarkFromCoordinates(
              order.location.coordinates[1], // Latitude
              order.location.coordinates[0], // Longitude
            );
            if (placemarks.isNotEmpty) {
              final place = placemarks.first;
              order.cachedCity = place.locality;
              order.cachedCountry = place.country;
              order.cachedAddress = [
                place.name,
                place.subLocality,
                place.locality,
                place.administrativeArea,
                place.country,
              ].where((e) => e != null && e.isNotEmpty).join(', ');
            }
          } catch (e) {
            log("Geocoding error for order ${order.bookingId}: $e");
          }
        }
      }

      // Create markers and polylines
      final Set<Polyline> polyLines = {};
      final Set<Marker> markers = {};
      CameraPosition cameraPosition =
          CameraPosition(target: _driverLatLng!, zoom: 14);
      _cameraPosition = cameraPosition;

      final driverIcon = await _getCustomIcon(AppImages.start);
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: _driverLatLng!,
          icon: driverIcon,
          infoWindow: const InfoWindow(title: 'Driver (You)'),
        ),
      );

      for (var i = 0; i < orders.length; i++) {
        final order = orders[i];
        if (order.location.coordinates.length < 2) continue;
        final studentLatLng = LatLng(
          order.location.coordinates[1], // Latitude
          order.location.coordinates[0], // Longitude
        );
        final studentIcon = await _getCustomIcon(AppImages.end);
        markers.add(
          Marker(
            markerId: MarkerId('student_$i'),
            position: studentLatLng,
            icon: studentIcon,
            infoWindow: InfoWindow(
                title: 'Student ${order.assignedDriver ?? 'Unknown'}'),
          ),
        );
        final route = await _getPolyline(_driverLatLng!, studentLatLng);
        if (route.isNotEmpty) {
          polyLines.add(
            Polyline(
              polylineId: PolylineId('route_$i'),
              points: route,
              color: const Color(0xFF4285F4),
              width: 5,
            ),
          );
        }
      }

      _polyLines = polyLines;
      _markers = markers;
      emit(HomeLoadedState(
        orders: orders,
        cameraPosition: cameraPosition,
        polyLines: polyLines,
        markers: markers,
      ));
    } catch (e) {
      log("Error in _onLoadHomeData: $e");
      emit(HomeErrorState("Failed to load orders: $e"));
    }
  }

  Future<void> _onUpdateLiveLocation(
      UpdateLiveLocationEvent event, Emitter<HomeState> emit) async {
    if (_lastPosition == null || _orders.isEmpty) return;
    try {
      final (lat, long, locationName) =
          await currentLocationRepository.getCurrentLocation();
      _driverLatLng = LatLng(lat, long);

      // Emit location update for each order
      for (final order in _orders) {
        if (order.bookingId.isNotEmpty) {
          socketService.emit('updateLocation', {
            'latitude': lat,
            'longitude': long,
            'locationName': locationName,
            'bookingId': order.bookingId,
            'updateType': 'continuous',
          });
        }
      }

      // Update markers and polylines
      await _updateMap(emit);
    } catch (e) {
      log("Failed to update location: $e");
    }
  }

  Future<void> _onUpdateLocation(
      UpdateLocation event, Emitter<HomeState> emit) async {
    if (_orders.isEmpty) return;
    _driverLatLng = LatLng(event.position.latitude, event.position.longitude);
    await _updateMap(emit);
  }

  Future<void> _updateMap(Emitter<HomeState> emit) async {
    final Set<Marker> markers =
        _markers.where((m) => !m.markerId.value.startsWith('driver')).toSet();
    final driverIcon = await _getCustomIcon(AppImages.start);
    markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: _driverLatLng!,
        icon: driverIcon,
        infoWindow: const InfoWindow(title: 'Driver (You)'),
      ),
    );

    final Set<Polyline> polyLines = {};
    for (var i = 0; i < _orders.length; i++) {
      final order = _orders[i];
      if (order.location.coordinates.length < 2) continue;
      final studentLatLng = LatLng(
        order.location.coordinates[1], // Latitude
        order.location.coordinates[0], // Longitude
      );
      final route = await _getPolyline(_driverLatLng!, studentLatLng);
      if (route.isNotEmpty) {
        polyLines.add(
          Polyline(
            polylineId: PolylineId('route_$i'),
            points: route,
            color: const Color(0xFF4285F4),
            width: 5,
          ),
        );
      }
    }

    _markers = markers;
    _polyLines = polyLines;
    _cameraPosition = CameraPosition(target: _driverLatLng!, zoom: 14);

    if (_mapController != null) {
      await _mapController!
          .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
    }

    emit(HomeLoadedState(
      orders: _orders,
      cameraPosition: _cameraPosition!,
      polyLines: polyLines,
      markers: markers,
    ));
  }

  Future<void> _onMapControllerInitialized(
      MapControllerInitialized event, Emitter<HomeState> emit) async {
    _mapController = event.controller;
    if (_cameraPosition != null) {
      await _mapController!
          .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
    }
  }

  Future<void> _onAcceptJob(
      HomeAcceptJobEvent event, Emitter<HomeState> emit) async {
    try {
      final success = await orderRepository.proposalAcceptReject(
          event.purpose == 'accept'
              ? '/accept/${event.proposalId}'
              : '/reject/${event.proposalId}');
      if (success) {
        add(const HomeLoadedEvent(
            endPoint: 'inProgressBookings')); // Refresh orders
      } else {
        emit(const HomeErrorState("Failed to process proposal"));
      }
    } catch (e) {
      log("Error accepting/rejecting job: $e");
      emit(HomeErrorState("Failed to process proposal: $e"));
    }
  }

  Future<List<LatLng>> _getPolyline(LatLng start, LatLng end) async {
    try {
      final polylinePoints = PolylinePoints();
      final request = PolylineRequest(
        origin: PointLatLng(start.latitude, start.longitude),
        destination: PointLatLng(end.latitude, end.longitude),
        mode: TravelMode.driving,
      );
      final result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: 'AIzaSyCyyqHImZfYyt09rya-6YcD9wsTWbP0fsE',
        request: request,
      );
      if (result.points.isEmpty) return [];
      return result.points.map((e) => LatLng(e.latitude, e.longitude)).toList();
    } catch (e) {
      log("Polyline error: $e");
      return [];
    }
  }

  Future<BitmapDescriptor> _getCustomIcon(String assetPath) async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      assetPath,
    );
  }
}
