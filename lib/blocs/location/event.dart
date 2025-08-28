import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class LocationEvent extends Equatable {
  const LocationEvent();
  List<Object> get props => [];
}

class RequestEnableLocation extends LocationEvent {
  const RequestEnableLocation();
}

class CheckLocationPermission extends LocationEvent {
  const CheckLocationPermission();
}

class FetchLocation extends LocationEvent {}
