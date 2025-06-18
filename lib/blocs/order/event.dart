import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  List<Object> get props => [];
}

class OrderLoadedEvent extends OrderEvent {
  List<Object> get props => [];
}
