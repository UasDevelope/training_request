import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/order/state.dart';

import 'package:training_request/models/home.dart';
import 'package:training_request/models/order.dart';

import '../../dumy/home.dart';
import '../../dumy/orderr.dart';
import 'event.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitalStat()) {
    on<OrderLoadedEvent>((event, emit) {
      emit(OrderLoadingStat());
      try {
        DummyMaps dummyMaps = DummyMaps();
        final data =
            dummyMaps.homeOffers.map((e) => orderModel.fromMap(e)).toList();
        emit(OrderLoadedStat(homeModel: data));
      } catch (e) {
        log("Error$e");
      }
    });
  }
}
