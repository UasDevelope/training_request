import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/home/event.dart';
import 'package:training_request/blocs/home/state.dart';
import 'package:training_request/models/home.dart';

import '../../dumy/home.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitalStat()) {
    on<HomeLoadedEvent>((event, emit) {
      emit(HomeLoadingStat());
      try {
        DummyMaps dummyMaps = DummyMaps();
        final data =
            dummyMaps.homeOffers.map((e) => HomeModel.fromMap(e)).toList();
        emit(HomeLoadedStat(homeModel: data));
      } catch (e) {
        log("Error$e");
      }
    });
  }
}
