import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  List<Object> get props => [];
}

class HomeLoadedEvent extends HomeEvent {
  const HomeLoadedEvent();
  List<Object> get props => [];
}
class HomeAcceptJobEvent extends HomeEvent{
  final String bookingId;
  const HomeAcceptJobEvent(this.bookingId);
  List<Object> get props=>[bookingId];
}