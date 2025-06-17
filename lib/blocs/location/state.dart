import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class LocationState extends Equatable {
  const LocationState();
  List<Object> get props => [];
}

class LocationInitialState extends LocationState {
  const LocationInitialState();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoadedState extends LocationState {
  final double lat;
  final double long;
  final String location;
  LocationLoadedState({required this.lat, required this.long,required this.location});
  List<Object> get props => [lat,long,location];
}

class LocationPermissionDenied extends LocationState {}

class LocationSucessState extends LocationState {
  final String message;

  const LocationSucessState({required this.message});
  List<Object> get props => [message];
}

class LocationErrorState extends LocationState{
  final String message;

  const LocationErrorState({required this.message});
  List<Object> get props => [message];
}