import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/splash/splash_event.dart';
import 'package:training_request/blocs/splash/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(const SplashInitialState()) {
    on<checkAuthenticationStatus>(_onSplashLoaded);
  }
  Future<void> _onSplashLoaded(
    checkAuthenticationStatus event,
    Emitter<SplashState> emit,
  ) async {
    emit(SplashLoadingState());
    try {} catch (e) {
      await Future.delayed((Duration(seconds: 3)));
      final bool hasToken = await _hasToken();
      if (hasToken) {
        SplashNavigateToLogin();
      } else {
        SplashNavigateToHome();
      }
    }
  }

  Future<bool> _hasToken() async {
    return false;
  }
}
