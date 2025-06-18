import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/splash/splash_event.dart';
import 'package:training_request/blocs/splash/splash_state.dart';
import 'package:training_request/services/local/storage.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitialState()) {
    on<checkAuthenticationStatus>(_onSplashLoaded);
  }
  Future<void> _onSplashLoaded(
    checkAuthenticationStatus event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoadingState());
    try {
      await Future.delayed((Duration(seconds: 3)));
      final hasToken = await LocalStorage.getString(LocalStorage.AcessToken);
      log("Token=>-----$hasToken");
      if (hasToken == null) {
        emit(SplashNavigateToLogin());
      } else {
        emit(SplashNavigateToHome());
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
