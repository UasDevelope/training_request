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

class ConnectToChat extends OrderChatEvent {
  const ConnectToChat();
}

class LeaveChatRoom extends OrderChatEvent {
  final String bookingId;

  const LeaveChatRoom({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class StartTyping extends OrderChatEvent {
  final String bookingId;

  const StartTyping({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class StopTyping extends OrderChatEvent {
  final String bookingId;

  const StopTyping({required this.bookingId});

  @override
  List<Object> get props => [bookingId];
}

class MarkMessagesAsRead extends OrderChatEvent {
  final List<String> messageIds;
  final String bookingId;

  const MarkMessagesAsRead({
    required this.messageIds,
    required this.bookingId,
  });

  @override
  List<Object> get props => [messageIds, bookingId];
}

class UpdateLocation extends OrderChatEvent {
  final double latitude;
  final double longitude;
  final String locationName;
  final String bookingId;
  final String updateType;

  const UpdateLocation({
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.bookingId,
    this.updateType = 'manual',
  });

  @override
  List<Object> get props => [latitude, longitude, locationName, bookingId, updateType];
}
