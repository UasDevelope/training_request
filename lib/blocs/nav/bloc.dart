import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/nav/event.dart';
import 'package:training_request/blocs/nav/state.dart';

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(NavInitialState()) {
    on<ChangeIndex>((event, emit) {
      try {
        emit(ChangeIndexStat(index: event.Index));
      } catch (e) {
        log("$e");
      }
    });
  }
}
