import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/blocs/inbox/event.dart';
import 'package:training_request/blocs/inbox/state.dart';
import 'package:training_request/dumy/chat_inbox.dart';
import '../../models/chat_inbox.dart';
class ChatInboxBloc extends Bloc<ChatInboxEvent, ChatInboxState> {
  List<ChatInboxModel> _chatList = []; // store messages here

  ChatInboxBloc() : super(ChatInboxInitialState()) {
    on<ChatLoadedEvent>(_onLoadChat);
    on<SendChatMessageEvent>(_onSendMessage);
  }

  void _onLoadChat(ChatLoadedEvent event, Emitter<ChatInboxState> emit) {
    emit(ChatInboxLoadingState());
    try {
      final chatInboxData = ChatInboxData();
      _chatList =
          chatInboxData.chatInbox
              .map((e) => ChatInboxModel.fromMap(e))
              .toList();
      emit(ChatInboxLoadedState(chatInbox: List.from(_chatList)));
    } catch (e) {
      log("Error loading chat: $e");
    }
  }

  void _onSendMessage(
    SendChatMessageEvent event,
    Emitter<ChatInboxState> emit,
  ) {
    final newMessage = ChatInboxModel(
      message: event.message,
      senderId: event.senderId,
      recievrId: "receiver_123", // can adjust logic later
      time: DateTime.now(),
      url: "",
      isMe: true,
    );
    _chatList.add(newMessage);
    emit(ChatInboxLoadedState(chatInbox: List.from(_chatList)));
  }
}
