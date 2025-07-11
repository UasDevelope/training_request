import 'package:equatable/equatable.dart';

abstract class OrderChatEvent extends Equatable {
  const OrderChatEvent();

  @override
  List<Object> get props => [];
}

class JoinChatRoom extends OrderChatEvent {
  final String bookingId;

  const JoinChatRoom({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class FetchChatHistory extends OrderChatEvent {
  final String bookingId;

  const FetchChatHistory({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class SendChatMessage extends OrderChatEvent {
  final String message;
  final String bookingId;

  const SendChatMessage({
    required this.message,
    required this.bookingId,
  });

  @override
  List<Object> get props => [message, bookingId];
}

class ChatMessageReceived extends OrderChatEvent {
  final Map<String, dynamic> messageData;

  const ChatMessageReceived({required this.messageData});

  @override
  List<Object> get props => [messageData];
}

class LeaveChatRoom extends OrderChatEvent {
  final String bookingId;

  const LeaveChatRoom({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}
