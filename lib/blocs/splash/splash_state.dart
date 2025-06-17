import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SplashState extends Equatable {
  const SplashState();
  @override
  List<Object> get props => [];
}

class SplashInitialState extends SplashState {
  const SplashInitialState();
}

class SplashLoadingState extends SplashState {
  const SplashLoadingState();
}

class SplashLoadedState extends SplashState {
  const SplashLoadedState();
}

class SplashNavigateToLogin extends SplashState {
  const SplashNavigateToLogin();
}

class SplashNavigateToHome extends SplashState {
  const SplashNavigateToHome();
}
