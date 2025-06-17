import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/chat_inbox.dart';

@immutable
abstract class ChatInboxState extends Equatable {
  const ChatInboxState();
  List<Object> get props => [];
}

class ChatInboxInitialState extends ChatInboxState {
  const ChatInboxInitialState();
}
class ChatInboxLoadingState extends ChatInboxState {
  const ChatInboxLoadingState();
}
class ChatInboxLoadedState extends ChatInboxState {
  final List<ChatInboxModel> chatInbox;
  const ChatInboxLoadedState({required this.chatInbox});
  List<Object> get props => [chatInbox];
}
