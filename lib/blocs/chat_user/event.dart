import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ChatUserEvent extends Equatable {
  const ChatUserEvent();
  List<Object> get props => [];
}

class ChatUserLoadedEvent extends ChatUserEvent {
  const ChatUserLoadedEvent();
}
