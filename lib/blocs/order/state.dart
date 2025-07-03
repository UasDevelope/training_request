import 'package:equatable/equatable.dart';
import 'package:training_request/models/booking.dart';
import 'package:training_request/models/home.dart';
import 'package:training_request/models/order.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  List<Object> get props => [];
}

class OrderInitalStat extends OrderState {
  const OrderInitalStat();
  List<Object> get props => [];
}

class OrderLoadingStat extends OrderState {
  const OrderLoadingStat();
}

class ProposalLoadingStat extends OrderState {
  const ProposalLoadingStat();
}
class ProposalLoadedStat extends OrderState {
  final String message;
  const ProposalLoadedStat(this.message);
  @override
  List<Object> get props => [message];
}
class ProposalErrorStat extends OrderState {
  String message;
  ProposalErrorStat({required this.message});
  @override
  List<Object> get props => [message];
}

class OrderLoadedStat extends OrderState {
  final List<OrderModel> orderModel;
  const OrderLoadedStat({required this.orderModel});
  @override
  List<Object> get props => [];
}

class OrderErrorStat extends OrderState {
  String message;
OrderErrorStat({required this.message});
@override
  List<Object> get props => [message];
}

class LocationLoadingState extends OrderState {
  const LocationLoadingState();
}

class LocationLoaded extends OrderState {
  final String city;
  final String country;
  final String address;

  const LocationLoaded({
    required this.city,
    required this.country,
    required this.address,
  });
  @override
  List<Object> get props => [city,country,address];
}
class LocationError extends OrderState {
  final String message;

  const LocationError(this.message);
  @override
  List<Object> get props => [message];
}
