import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/order/state.dart';

import 'package:training_request/models/home.dart';
import 'package:training_request/models/order.dart';
import 'package:training_request/repositories/booking_repository.dart';
import 'package:training_request/repositories/order_repo.dart';

import '../../dumy/home.dart';
import '../../dumy/orderr.dart';
import 'event.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
final OrderRepository orderRepository;
  OrderBloc({required this.orderRepository}) : super(OrderInitalStat()) {
    on<OrderLoadedEvent>((event, emit) async {
      emit(OrderLoadingStat());
      try {
        // DummyMaps dummyMaps = DummyMaps();
        var response = await orderRepository.fetchBooking();
        emit(OrderLoadedStat(homeModel: response.booking));
      } catch (e) {
        log("Error$e");
      }
    });
  }
}
