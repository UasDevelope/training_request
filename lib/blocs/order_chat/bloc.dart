import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:training_request/utils/socket_utils.dart';

import '../../models/order_chat.dart';
import 'event.dart';
import 'state.dart';

class OrderChatBloc extends Bloc<OrderChatEvent, OrderChatState> {
  final SocketService _socketService = SocketService();
  List<OrderChatMessage> _messages = [];
  String? _currentBookingId;
  final String _currentUserId = "686e1f18b38e8f476fcd0dc3"; // Dummy user id
  bool _isSocketInitialized = false;

  OrderChatBloc() : super(OrderChatInitial()) {
    on<JoinChatRoom>(_onJoinChatRoom);
    on<SendChatMessage>(_onSendChatMessage);
    on<ChatMessageReceived>(_onChatMessageReceived);
    on<LeaveChatRoom>(_onLeaveChatRoom);

    // Initialize socket
    _initializeSocket();
  }

  Future<void> _initializeSocket() async {
    try {
      await _socketService.initSocket();
      int attempts = 0;
      while (!_socketService.isReady && attempts < 10) {
        await Future.delayed(Duration(milliseconds: 500));
        attempts++;
        log('⏳ Waiting for socket to be ready... attempt $attempts');
      }

      if (_socketService.isReady) {
        _isSocketInitialized = true;

        // Listen for incoming messages
        _socketService.on('chatMessage', (data) {
          log('📥 Received chat message: $data');
          add(ChatMessageReceived(messageData: data));
        });

        log('✅ Socket initialized successfully');
      } else {
        log('❌ Socket failed to initialize after $attempts attempts');
        _isSocketInitialized = false;
      }
    } catch (e) {
      log('❌ Error initializing socket: $e');
      _isSocketInitialized = false;
    }
  }

  Future<void> _onJoinChatRoom(
    JoinChatRoom event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      emit(OrderChatLoading());

      // Wait for socket to be initialized
      if (!_isSocketInitialized) {
        log('⏳ Waiting for socket initialization...');
        await _initializeSocket();
      }

      _currentBookingId = event.bookingId;
      _messages = []; // Clear previous messages, no dummy data

      // Join the chat room
      _socketService
          .ensureConnectedAndEmit('joinRoom', {'bookingId': event.bookingId});

      log('🔌 Joined chat room for booking: ${event.bookingId}');

      emit(OrderChatConnected(
        bookingId: event.bookingId,
        messages: List.from(_messages),
      ));
    } catch (e) {
      log('❌ Error joining chat room: $e');
      emit(OrderChatError(message: 'Failed to join chat room: $e'));
    }
  }

  Future<void> _onSendChatMessage(
    SendChatMessage event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      // Ensure socket is initialized
      if (!_isSocketInitialized) {
        log('⏳ Waiting for socket initialization...');
        await _initializeSocket();
      }

      // Send message via socket
      _socketService.ensureConnectedAndEmit('chatMessage', {
        'bookingId': event.bookingId,
        'message': event.message,
      });

      log('📤 Sent message: ${event.message}');

      // Optimistic update: add message locally with a temp id
      // final tempId = DateTime.now().millisecondsSinceEpoch.toString();
      // final newMessage = OrderChatMessage(
      //   id: tempId,
      //   userId: _currentUserId,
      //   senderName: 'You',
      //   senderRole: 'user',
      //   message: event.message,
      //   timestamp: DateTime.now(),
      //   status: 'sending',
      //   bookingId: event.bookingId,
      //   isMe: true,
      // );
      //
      // _messages.add(newMessage);

      if (state is OrderChatConnected) {
        final currentState = state as OrderChatConnected;
        emit(currentState.copyWith(messages: List.from(_messages)));
      }
    } catch (e) {
      log('❌ Error sending message: $e');
      emit(OrderChatError(message: 'Failed to send message: $e'));
    }
  }

  Future<void> _onChatMessageReceived(
    ChatMessageReceived event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      final messageData = event.messageData;

      // Convert socket data to OrderChatMessage
      final newMessage = OrderChatMessage.fromMap(
        messageData,
        _currentUserId,
      );

      // Only add if it's for the current booking and not a duplicate
      final alreadyExists = _messages.any((msg) => msg.id == newMessage.id);
      if (newMessage.bookingId == _currentBookingId && !alreadyExists) {
        _messages.add(newMessage);

        if (state is OrderChatConnected) {
          final currentState = state as OrderChatConnected;
          emit(currentState.copyWith(messages: List.from(_messages)));
        }
      }
    } catch (e) {
      log('❌ Error processing received message: $e');
    }
  }

  Future<void> _onLeaveChatRoom(
    LeaveChatRoom event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      _currentBookingId = null;
      _messages.clear();

      emit(OrderChatDisconnected());

      log('👋 Left chat room for booking: ${event.bookingId}');
    } catch (e) {
      log('❌ Error leaving chat room: $e');
    }
  }

  @override
  Future<void> close() {
    _socketService.disconnect();
    return super.close();
  }
}
