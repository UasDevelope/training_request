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

class OrderLoadedStat extends OrderState {
  final List<OrderModel> homeModel;
  const OrderLoadedStat({required this.homeModel});
  List<Object> get props => [];
}

class OrderErrorStat extends OrderState {
  OrderErrorStat();
  List<Object> get props => [];
}
