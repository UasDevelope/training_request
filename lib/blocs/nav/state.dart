import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class NavState extends Equatable {
  const NavState();
  List<Object> get props => [];
}

class NavInitialState extends NavState {
  const NavInitialState();
}

class ChangeIndexStat extends NavState {
  final int index;

  const ChangeIndexStat({this.index = 0});
  List<Object> get props => [index];
}
