import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:training_request/models/user_model.dart';

@immutable
class ChatuserState extends Equatable {
  const ChatuserState();
  List<Object> get props => [];
}

class ChatUserInitialStat extends ChatuserState {
  const ChatUserInitialStat();
}

class chatUserLoadingState extends ChatuserState {
  chatUserLoadingState();
}

class ChatUserLoadedState extends ChatuserState {
  final List<ChatUserModel> chatUserModel;
  ChatUserLoadedState({required this.chatUserModel});
}
