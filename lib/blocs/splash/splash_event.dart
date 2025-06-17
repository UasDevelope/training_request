import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class SplashEvent extends Equatable {
  const SplashEvent();
  List<Object> get props => [];
}

class checkAuthenticationStatus extends SplashEvent {
  const checkAuthenticationStatus();
  @override
  List<Object> get props => [];
}
