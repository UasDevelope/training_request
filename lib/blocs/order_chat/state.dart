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
  
  const OrderChatConnected({
    required this.bookingId,
    required this.messages,
  });
  
  @override
  List<Object> get props => [bookingId, messages];
  
  OrderChatConnected copyWith({
    String? bookingId,
    List<OrderChatMessage>? messages,
  }) {
    return OrderChatConnected(
      bookingId: bookingId ?? this.bookingId,
      messages: messages ?? this.messages,
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