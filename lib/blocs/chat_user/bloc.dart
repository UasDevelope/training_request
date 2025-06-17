import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/chat_user/event.dart';

import 'package:training_request/blocs/chat_user/state.dart';
import 'package:training_request/dumy/home.dart';
import 'package:training_request/models/user_model.dart';

import '../../dumy/chat_user.dart';

class ChatUserBloc extends Bloc<ChatUserEvent, ChatuserState> {
  ChatUserBloc() : super(ChatUserInitialStat()) {
    on<ChatUserLoadedEvent>((event, emit) {
      emit(chatUserLoadingState());
      try {
        final ChatUser dummyMaps = ChatUser();
        final chatData =
            dummyMaps.chatUser.map((e) => ChatUserModel.fromMap(e)).toList();
        log(chatData.toString());
        emit(ChatUserLoadedState(chatUserModel: chatData));
      } catch (e) {
        log("$e");
      }
    });
  }
}
