import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/order_chat.dart';
import '../../repositories/chat_repository.dart';
import '../../services/local/storage.dart';

import 'event.dart';
import 'state.dart';

class OrderChatBloc extends Bloc<OrderChatEvent, OrderChatState> {
  final ChatRepository _chatRepository = ChatRepository();
  
  List<OrderChatMessage> _messages = [];
  String? _currentBookingId;
  String? _currentUserId;
  StreamSubscription<Map<String, dynamic>>? _messageSubscription;
  StreamSubscription<Map<String, dynamic>>? _typingSubscription;
  StreamSubscription<Map<String, dynamic>>? _statusSubscription;
  StreamSubscription<Map<String, dynamic>>? _locationSubscription;
  StreamSubscription<String>? _errorSubscription;
  StreamSubscription<bool>? _connectionSubscription;

  OrderChatBloc() : super(OrderChatInitial()) {
    on<FetchChatHistory>(_onFetchChatHistory);
    on<JoinChatRoom>(_onJoinChatRoom);
    on<SendChatMessage>(_onSendChatMessage);
    on<ChatMessageReceived>(_onChatMessageReceived);
    on<ConnectToChat>(_onConnectToChat);
    on<LeaveChatRoom>(_onLeaveChatRoom);
    on<StartTyping>(_onStartTyping);
    on<StopTyping>(_onStopTyping);
    on<MarkMessagesAsRead>(_onMarkMessagesAsRead);
    on<UpdateLocation>(_onUpdateLocation);
  }

  void _setupSocketListeners() {
    // Listen for incoming messages
    _messageSubscription = _chatRepository.messageStream.listen((data) {
      add(ChatMessageReceived(messageData: data));
    });

    // Listen for typing indicators
    _typingSubscription = _chatRepository.typingStream.listen((data) {
      // Handle typing indicators
      log('⌨️ Typing event: $data');
    });

    // Listen for message status updates
    _statusSubscription = _chatRepository.statusStream.listen((data) {
      // Handle message status updates (sent, delivered, read)
      log('📨 Status update: $data');
    });

    // Listen for location updates
    _locationSubscription = _chatRepository.locationStream.listen((data) {
      // Handle location updates
      log('📍 Location update: $data');
    });

    // Listen for errors
    _errorSubscription = _chatRepository.errorStream.listen((error) {
      log('❌ Socket error: $error');
      add(ChatMessageReceived(messageData: {'error': error}));
    });

    // Listen for connection status
    _connectionSubscription = _chatRepository.connectionStream.listen((connected) {
      log('🔌 Connection status: $connected');
      if (!connected) {
        add(ChatMessageReceived(messageData: {'error': 'Socket connection lost'}));
      }
    });
  }

  void _disposeSocketListeners() {
    _messageSubscription?.cancel();
    _typingSubscription?.cancel();
    _statusSubscription?.cancel();
    _locationSubscription?.cancel();
    _errorSubscription?.cancel();
    _connectionSubscription?.cancel();
  }

  Future<void> _onJoinChatRoom(
    JoinChatRoom event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      emit(OrderChatLoading());

      _currentBookingId = event.bookingId;

      // ✅ Step 1: Check chat availability
      try {
        final availability = await _chatRepository.checkChatAvailability(event.bookingId);
        if (availability['allowed'] != true) {
          emit(OrderChatError(message: availability['reason'] ?? 'Chat not available for this booking'));
          return;
        }
      } catch (e) {
        log('❌ Error checking chat availability: $e');
        emit(OrderChatError(message: 'Failed to check chat availability. Please try again.'));
        return;
      }

      // ✅ Step 2: Initialize socket if not already connected
      if (!_chatRepository.isSocketConnected && !_chatRepository.isSocketConnecting) {
        final socketInitialized = await _chatRepository.initializeSocket();
        if (!socketInitialized) {
          emit(OrderChatError(message: 'Failed to connect to chat server. Please check your internet connection.'));
          return;
        }
        _setupSocketListeners();
      }

      // ✅ Step 3: Join chat room via socket
      final joinedRoom = await _chatRepository.joinChatRoom(event.bookingId);
      if (!joinedRoom) {
        emit(OrderChatError(message: 'Failed to join chat room. Please try again.'));
        return;
      }

      // ✅ Step 4: Load chat history
      add(FetchChatHistory(bookingId: event.bookingId));

      log('🔌 Joined chat room for booking: ${event.bookingId}');
    } catch (e) {
      log('❌ Error joining chat room: $e');
      emit(OrderChatError(message: 'Failed to join chat room. Please try again.'));
    }
  }

  Future<void> _onFetchChatHistory(
    FetchChatHistory event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      emit(OrderChatLoading());

      // Get current user ID
      _currentUserId = await _getCurrentUserId();

      // Fetch chat history from API
      _messages = await _chatRepository.getChatHistory(event.bookingId);

      emit(OrderChatConnected(
        bookingId: event.bookingId,
        messages: List.from(_messages),
        shouldScrollToBottom: true,
      ));
    } catch (e) {
      log("❌ Error fetching chat history: $e");
      emit(OrderChatError(message: 'Failed to load chat history: $e'));
    }
  }

  Future<void> _onSendChatMessage(
    SendChatMessage event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      if (event.message.trim().isEmpty) {
        log('❌ Cannot send empty message');
        return;
      }

      log('📤 Sending message: ${event.message}');
      
      // Create temporary message for immediate UI update
      final tempMessage = OrderChatMessage(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        message: event.message.trim(),
        userId: _currentUserId ?? 'unknown',
        senderName: 'You',
        senderRole: 'customer',
        timestamp: DateTime.now(),
        status: 'sending',
        bookingId: event.bookingId,
        isMe: true,
      );
      
      _messages.add(tempMessage);
      
      // Update UI immediately
      emit(OrderChatConnected(
        bookingId: event.bookingId,
        messages: List.from(_messages),
        shouldScrollToBottom: true,
      ));
      
      // Send message via socket (preferred) or API (fallback)
      bool messageSent = false;
      
      try {
        messageSent = await _chatRepository.sendMessageViaSocket(event.message, event.bookingId);
        if (messageSent) {
          log('📤 Message sent via socket');
          // Update temp message status to sent
          final index = _messages.indexWhere((msg) => msg.id == tempMessage.id);
          if (index != -1) {
            _messages[index] = _messages[index].copyWith(status: 'sent');
          }
        }
      } catch (socketError) {
        log('⚠️ Socket failed, trying API: $socketError');
      }

      // Fallback to API if socket failed
      if (!messageSent) {
        try {
          final sentMessage = await _chatRepository.sendMessageViaAPI(event.message, event.bookingId);
          // Replace temp message with real message
          final index = _messages.indexWhere((msg) => msg.id == tempMessage.id);
          if (index != -1) {
            _messages[index] = sentMessage;
          }
          log('📤 Message sent via API');
        } catch (apiError) {
          log('❌ Both socket and API failed: $apiError');
          // Remove temp message on failure
          _messages.removeWhere((msg) => msg.id == tempMessage.id);
          emit(OrderChatError(message: 'Failed to send message. Please check your connection and try again.'));
          return;
        }
      }
      
      // Update UI with final state
      emit(OrderChatConnected(
        bookingId: event.bookingId,
        messages: List.from(_messages),
        shouldScrollToBottom: true,
      ));

    } catch (e) {
      log('❌ Error sending message: $e');
      emit(OrderChatError(message: 'Failed to send message. Please try again.'));
    }
  }

  Future<void> _onChatMessageReceived(
    ChatMessageReceived event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      final messageData = event.messageData;
      log('📥 Received chat message: $messageData');

      // Handle error messages
      if (messageData.containsKey('error')) {
        log('❌ Received error message: ${messageData['error']}');
        emit(OrderChatError(message: messageData['error']));
        return;
      }

      // Validate message data
      if (messageData.isEmpty) {
        log('⚠️ Received empty message data');
        return;
      }

      // Handle different message formats from socket
      Map<String, dynamic> processedData = messageData;
      
      // If the message is nested in a 'data' field
      if (messageData.containsKey('data')) {
        processedData = messageData['data'];
      }
      
      // If the message is nested in a 'message' field
      if (messageData.containsKey('message')) {
        processedData = messageData['message'];
      }

      // Ensure we have the required fields
      if (!processedData.containsKey('message') || !processedData.containsKey('bookingId')) {
        log('⚠️ Invalid message format: $processedData');
        return;
      }

      // Convert socket data to OrderChatMessage
      final newMessage = OrderChatMessage.fromMap(
        processedData,
        _currentUserId ?? 'unknown',
      );

      // Check for duplicates by ID or content + timestamp
      final existingMessageById = _messages.any((msg) => msg.id == newMessage.id);
      final existingMessageByContent = _messages.any((msg) => 
        msg.message == newMessage.message && 
        msg.timestamp.difference(newMessage.timestamp).abs().inSeconds < 5
      );
      
      // Only add if it's for the current booking and not a duplicate
      if (newMessage.bookingId == _currentBookingId && !existingMessageById && !existingMessageByContent) {
        _messages.add(newMessage);
        log('✅ Added new real-time message. Total messages: ${_messages.length}');

        // Update UI immediately
        emit(OrderChatConnected(
          bookingId: _currentBookingId!,
          messages: List.from(_messages),
          shouldScrollToBottom: true,
        ));
      } else {
        log('⚠️ Message not added - duplicate: $existingMessageById, content duplicate: $existingMessageByContent, booking mismatch: ${newMessage.bookingId != _currentBookingId}');
      }
    } catch (e) {
      log('❌ Error processing received message: $e');
    }
  }



  Future<void> _onConnectToChat(
    ConnectToChat event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      log('🔌 Initializing socket connection...');
      await _chatRepository.initializeSocket();
      _setupSocketListeners();
      log('✅ Socket connection initialized');
    } catch (e) {
      log('❌ Error connecting to chat: $e');
      emit(OrderChatError(message: 'Failed to connect to chat: $e'));
    }
  }



  Future<void> _onLeaveChatRoom(
    LeaveChatRoom event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      await _chatRepository.leaveChatRoom();
      _currentBookingId = null;
      _messages.clear();

      emit(OrderChatDisconnected());

      log('👋 Left chat room for booking: ${event.bookingId}');
    } catch (e) {
      log('❌ Error leaving chat room: $e');
    }
  }

  Future<void> _onStartTyping(
    StartTyping event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      await _chatRepository.startTyping(event.bookingId);
    } catch (e) {
      log('❌ Error starting typing: $e');
    }
  }

  Future<void> _onStopTyping(
    StopTyping event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      await _chatRepository.stopTyping(event.bookingId);
    } catch (e) {
      log('❌ Error stopping typing: $e');
    }
  }

  Future<void> _onMarkMessagesAsRead(
    MarkMessagesAsRead event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      await _chatRepository.markMessagesAsRead(event.messageIds, event.bookingId);
    } catch (e) {
      log('❌ Error marking messages as read: $e');
    }
  }

  Future<void> _onUpdateLocation(
    UpdateLocation event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      await _chatRepository.updateLocation(
        latitude: event.latitude,
        longitude: event.longitude,
        locationName: event.locationName,
        bookingId: event.bookingId,
        updateType: event.updateType,
      );
    } catch (e) {
      log('❌ Error updating location: $e');
    }
  }

  /// Simulate incoming message for testing real-time functionality
  void simulateIncomingMessage(String message, {String? senderName, String? senderRole}) {
    if (_currentBookingId == null) return;
    
    final simulatedMessage = {
      'id': 'sim_${DateTime.now().millisecondsSinceEpoch}',
      'message': message,
      'userId': 'simulated_user_${DateTime.now().millisecondsSinceEpoch}',
      'senderName': senderName ?? 'Test User',
      'senderRole': senderRole ?? 'customer',
      'timestamp': DateTime.now().toIso8601String(),
      'status': 'sent',
      'bookingId': _currentBookingId,
    };
    
    log('🧪 Simulating incoming message: $message');
    add(ChatMessageReceived(messageData: simulatedMessage));
  }

  Future<String> _getCurrentUserId() async {
    try {
      // For now, we'll use a default user ID
      // In a real implementation, you might extract this from the JWT token
      // or store it separately during login
      return 'user_123';
    } catch (e) {
      log('❌ Error getting current user ID: $e');
      return 'unknown_user';
    }
  }

  @override
  Future<void> close() {
    _disposeSocketListeners();
    _chatRepository.dispose();
    return super.close();
  }
}
