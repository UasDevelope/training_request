import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class ChatInboxEvent extends Equatable {
  const ChatInboxEvent();
  List<Object> get props => [];
}

class ChatLoadedEvent extends ChatInboxEvent {
  const ChatLoadedEvent();
}

class SendChatMessageEvent extends ChatInboxEvent {
  final String message;
  final String senderId;
  const SendChatMessageEvent({required this.senderId, required this.message});
  List<Object> get props => [message, senderId];
}
