import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class NavEvent extends Equatable {
  const NavEvent();
  List<Object> get props => [];
}

class ChangeIndex extends NavEvent {
  final int Index;
  const ChangeIndex({required this.Index});
  List<Object> get props => [Index];
}
