import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../models/home.dart';

@immutable
abstract class HomeState extends Equatable {
  const HomeState();
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeLoadedState extends HomeState {
  final List<HomeModel> homeModel;
  final Set<Polyline> polyLines; // <- update this line
  final Set<Marker> marker;
  final CameraPosition cameraPosition;
  HomeLoadedState({
    required this.homeModel,
    required this.cameraPosition,
    required this.polyLines,
    required this.marker,
  });
  List<Object> get props => [homeModel, cameraPosition, polyLines, marker];
}
