import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  List<Object> get props => [];
}

class HomeLoadedEvent extends HomeEvent {
  const HomeLoadedEvent();
  List<Object> get props => [];
}

class UpdateLiveLocationEvent extends HomeEvent {}

class MapControllerInitialized extends HomeEvent {
  final GoogleMapController controller;
  MapControllerInitialized(this.controller);
}
class HomeAcceptJobEvent extends HomeEvent {
  final String bookingId;
  const HomeAcceptJobEvent(this.bookingId);
  List<Object> get props => [bookingId];
}
