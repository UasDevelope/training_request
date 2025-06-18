import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();
  List<Object> get props => [];
}

class RememberChecked extends AuthState {
  final bool isRememberMeChecked;

  const RememberChecked({required this.isRememberMeChecked});

  List<Object> get props => [isRememberMeChecked];
}

class TermsChecked extends AuthState {
  final bool isTermsChecked;
  const TermsChecked({required this.isTermsChecked});
  List<Object> get props => [isTermsChecked];
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthLoadedState extends AuthState {
  const AuthLoadedState();
}

class AuthSuccessState extends AuthState {
  final String message;
  const AuthSuccessState({required this.message});
}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState({required this.message});
}

class SignupSubmitState extends AuthState {}

class LoginState extends AuthState {}
