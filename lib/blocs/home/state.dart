import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:training_request/models/order.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {
  const HomeInitialState();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeLoadedState extends HomeState {
  final List<OrderModel> orders;
  final Set<Polyline> polyLines;
  final Set<Marker> markers;
  final CameraPosition cameraPosition;

  const HomeLoadedState({
    required this.orders,
    required this.cameraPosition,
    required this.polyLines,
    required this.markers,
  });

  @override
  List<Object> get props => [orders, cameraPosition, polyLines, markers];
}

class HomeErrorState extends HomeState {
  final String message;
  const HomeErrorState(this.message);
  @override
  List<Object> get props => [message];
}

class HomePaymentProcessingState extends HomeState {
  final String message;
  const HomePaymentProcessingState(this.message);
  @override
  List<Object> get props => [message];
}

class HomePaymentSuccessState extends HomeState {
  final String message;
  const HomePaymentSuccessState(this.message);
  @override
  List<Object> get props => [message];
}