import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  List<Object> get props => [];
}

class HomeLoadedEvent extends HomeEvent {
  List<Object> get props => [];
}
