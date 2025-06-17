import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthEvents extends Equatable {
  AuthEvents();
  List<Object> get props => [];
}

class CheckboxToggled extends AuthEvents {
  final bool isChecked;
  CheckboxToggled({required this.isChecked});
  List<Object> get props => [isChecked];
}

class CheckTerms extends AuthEvents {
  final bool isTermChecked;
  CheckTerms({required this.isTermChecked});
  List<Object> get props=>[isTermChecked];
}
