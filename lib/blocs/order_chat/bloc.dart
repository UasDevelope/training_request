import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:training_request/utils/socket_utils.dart';

import '../../api/api_constants.dart';
import '../../api/base_api_client.dart';
import '../../models/order_chat.dart';
import '../../services/local/storage.dart';
import '../../utils/custom_jwt_decoder.dart';
import 'event.dart';
import 'state.dart';

class OrderChatBloc extends Bloc<OrderChatEvent, OrderChatState> {
  final SocketService _socketService = SocketService();
  List<OrderChatMessage> _messages = [];
  String? _currentBookingId;
  String _currentUserId = "";
  bool _isSocketInitialized = false;

  OrderChatBloc() : super(OrderChatInitial()) {
    on<FetchChatHistory>(_onFetchChayHistory);
    on<JoinChatRoom>(_onJoinChatRoom);
    on<SendChatMessage>(_onSendChatMessage);
    on<ChatMessageReceived>(_onChatMessageReceived);
    on<LeaveChatRoom>(_onLeaveChatRoom);
    // Initialize socket
    _initializeSocket();
  }

  Future<void> _initializeSocket() async {
    try {
      _decodeToken();
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

  Future<String> _decodeToken() async {
    final userToken = await LocalStorage.getString(LocalStorage.AcessToken);

    if (userToken != null) {
      Map<String, dynamic> decodedToken = CustomJwtDecoder.decode(userToken);
      _currentUserId = decodedToken["id"];
      log("Current user id is $_currentUserId");
      return decodedToken["id"];
    }
    return "";
  }

  Future<void> _onJoinChatRoom(
    JoinChatRoom event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      emit(OrderChatLoading());

      if (!_isSocketInitialized) {
        await _initializeSocket();
      }

      _currentBookingId = event.bookingId;

      // ✅ Step 1: Load chat history before clearing or joining
      add(FetchChatHistory(bookingId: event.bookingId));

      // ✅ Step 2: THEN join room
      _socketService.ensureConnectedAndEmit('joinRoom', {
        'bookingId': event.bookingId,
      });

      log('🔌 Joined chat room for booking: ${event.bookingId}');
    } catch (e) {
      log('❌ Error joining chat room: $e');
      emit(OrderChatError(message: 'Failed to join chat room: $e'));
    }
  }

  Future<void> _onFetchChayHistory(
    FetchChatHistory event,
    Emitter<OrderChatState> emit,
  ) async {
    try {
      emit(OrderChatLoading());

      final BaseApiClient apiClient = GetIt.instance<BaseApiClient>();
      var response = await apiClient
          .get("${ApiConstants.getChatHistory}/${event.bookingId}");

      if (response != null && response['messages'] != null) {
        final List<dynamic> messagesJson = response['messages'];

        // ✅ Now clear here (not earlier)
        _messages = messagesJson
            .map((msg) => OrderChatMessage.fromMap(
                  {
                    ...msg,
                    'userId': msg['senderId'],
                  },
                  _currentUserId,
                ))
            .toList();

        emit(OrderChatConnected(
          bookingId: event.bookingId,
          messages: List.from(_messages),
          shouldScrollToBottom: true,
        ));
      } else {
        _messages = [];
        emit(OrderChatConnected(
          bookingId: event.bookingId,
          messages: [],
          shouldScrollToBottom: true,
        ));
      }
    } catch (e) {
      log("❌ Error fetching chat history: $e");
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
          emit(currentState.copyWith(
              messages: List.from(_messages), shouldScrollToBottom: true));
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
