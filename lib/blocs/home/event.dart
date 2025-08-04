import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class HomeLoadedEvent extends HomeEvent {
  final String endPoint;
  const HomeLoadedEvent({required this.endPoint});
}

class UpdateLocation extends HomeEvent {
  final Position position;
  const UpdateLocation({required this.position});
}

class UpdateLiveLocationEvent extends HomeEvent {}

class MapControllerInitialized extends HomeEvent {
  final GoogleMapController controller;
  const MapControllerInitialized(this.controller);
  @override
  List<Object> get props => [controller];
}

class HomeAcceptJobEvent extends HomeEvent {
  final String proposalId;
  final String purpose;
  const HomeAcceptJobEvent({required this.proposalId, required this.purpose});
  @override
  List<Object> get props => [proposalId, purpose];
}
