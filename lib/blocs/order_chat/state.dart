import 'package:equatable/equatable.dart';
import '../../models/order_chat.dart';

abstract class OrderChatState extends Equatable {
  const OrderChatState();
  
  @override
  List<Object> get props => [];
}

class OrderChatInitial extends OrderChatState {}

class OrderChatLoading extends OrderChatState {}

class OrderChatConnected extends OrderChatState {
  final String bookingId;
  final List<OrderChatMessage> messages;
  final bool shouldScrollToBottom;
  
  const OrderChatConnected({
    required this.bookingId,
    required this.messages,
    this.shouldScrollToBottom = false,
  });
  
  @override
  List<Object> get props => [bookingId, messages, shouldScrollToBottom];
  
  OrderChatConnected copyWith({
    String? bookingId,
    List<OrderChatMessage>? messages,
    bool? shouldScrollToBottom,
  }) {
    return OrderChatConnected(
      bookingId: bookingId ?? this.bookingId,
      messages: messages ?? this.messages,
      shouldScrollToBottom: shouldScrollToBottom ?? this.shouldScrollToBottom,
    );
  }
}

class OrderChatError extends OrderChatState {
  final String message;
  
  const OrderChatError({required this.message});
  
  @override
  List<Object> get props => [message];
}

class OrderChatDisconnected extends OrderChatState {} 