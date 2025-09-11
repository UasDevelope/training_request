import 'dart:async';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:training_request/services/local/storage.dart';
import '../api/api_constants.dart';

class SocketService {
  static SocketService? _instance;

  static SocketService get instance {
    _instance ??= SocketService._internal();
    return _instance!;
  }

  SocketService._internal();

  IO.Socket? _socket;
  bool _isConnected = false;
  bool _listenersSetup = false;

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _errorController =
      StreamController<String>.broadcast();

  // Streams for real-time updates
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<String> get errorStream => _errorController.stream;

  /// Initialize socket connection
  Future<void> connect() async {
    try {
      final token = await LocalStorage.getString(LocalStorage.AcessToken);

      if (token == null || token.isEmpty) {
        throw Exception('No authentication token found');
      }

      log('🔌 Attempting to connect to chat socket...');

      // Check if we already have a socket instance
      if (_socket != null) {
        if (_isConnected) {
          log('✅ Socket already connected');
          return;
        } else if (_socket!.connected) {
          log('✅ Socket is connected but flag was wrong, updating...');
          _isConnected = true;
          return;
        } else {
          log('🔄 Reusing existing socket instance');
        }
      }

      // Try primary server (same as REST API)
      try {
        _socket = IO.io(
          ApiConstants.SocketUrl,
          IO.OptionBuilder()
              .setTransports([
                'websocket',
                'polling'
              ]) // Try WebSocket first, fallback to polling
              .setAuth({'token': token})
              .disableAutoConnect()
              .enableReconnection()
              .setReconnectionAttempts(3)
              .setReconnectionDelay(2000)
              .setTimeout(10000) // 10 second timeout
              .build(),
        );

        _setupSocketListeners();
        _socket!.connect();

        // Wait for connection with timeout
        await _waitForConnection(timeoutSeconds: 10);

        if (_isConnected) {
          log('✅ Successfully connected to socket server');
          return;
        } else {
          log('⚠️ Socket connection timeout, continuing with REST API only');
          // Clean up failed connection
          if (_socket != null) {
            _socket!.disconnect();
            _socket = null;
            _listenersSetup = false;
          }
        }
      } catch (error) {
        log('⚠️ Socket connection failed: $error');
        log('📡 Continuing with REST API only for chat functionality');
      }
    } catch (e) {
      log('❌ Error in socket setup: $e');
      log('📡 Chat will work with REST API only');
      // Don't rethrow, allow the app to continue with REST API
    }
  }

  /// Setup socket event listeners
  void _setupSocketListeners() {
    if (_socket == null) {
      log('❌ Cannot setup listeners - socket is null');
      return;
    }

    if (_listenersSetup) {
      log('⚠️ Socket listeners already set up, skipping...');
      return;
    }

    _socket!.onConnect((_) {
      _isConnected = true;
      log('✅ Chat socket connected successfully');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      log('❌ Chat socket disconnected');
    });

    _socket!.onConnectError((error) {
      _isConnected = false;
      log('⚠️ Chat socket connection error: $error');
      _errorController.add('Connection error: $error');
    });

    _socket!.onError((error) {
      log('🔥 Chat socket error: $error');
      _errorController.add('Socket error: $error');
    });

    // Listen for chat messages
    _socket!.on('chatMessage', (data) {
      log('📥 Chat message received: $data');
      _messageController.add(data);
    });

    // Simple text chat - no delivery/read confirmations needed

    // Listen for room joined confirmation
    _socket!.on('roomJoined', (data) {
      log('🚪 Room joined: $data');
      _messageController.add({'type': 'roomJoined', 'data': data});
    });

    // Listen for message sent confirmation
    _socket!.on('messageSent', (data) {
      log('📤 Message sent: $data');
      _messageController.add({'type': 'sent', 'data': data});
    });

    // Listen for general errors
    _socket!.on('error', (data) {
      log('❌ Socket error: $data');
      final errorMessage = data['message'] ?? 'Unknown error';
      _errorController.add(errorMessage);

      // If it's an authorization error, we can still use REST API
      if (errorMessage.contains('Unauthorized') ||
          errorMessage.contains('unauthorized')) {
        log('⚠️ Socket authorization failed, but REST API may still work');
      }
    });

    _listenersSetup = true;
    log('✅ Socket listeners set up successfully');
  }

  /// Wait for socket connection with timeout
  Future<void> _waitForConnection({int timeoutSeconds = 10}) async {
    int attempts = 0;
    final startTime = DateTime.now();

    while (!_isConnected && attempts < timeoutSeconds) {
      await Future.delayed(const Duration(seconds: 1));
      attempts++;
      final elapsed = DateTime.now().difference(startTime).inSeconds;
      log('🔁 Connection attempt $attempts/$timeoutSeconds (${elapsed}s elapsed)');

      // Check if socket is in error state
      if (_socket?.connected == false && _socket?.disconnected == true) {
        log('❌ Socket disconnected during connection attempt');
        break;
      }
    }

    if (!_isConnected) {
      log('⚠️ Socket connection timeout after ${timeoutSeconds}s, continuing with REST API only');
      // Clean up failed socket
      if (_socket != null) {
        _socket!.disconnect();
        _socket = null;
      }
    } else {
      log('✅ Socket connection established successfully');
    }
  }

  /// Join a chat room for a specific booking
  Future<void> joinChatRoom(String bookingId) async {
    if (!_isConnected) {
      await connect();
    }

    try {
      log('🚪 Joining chat room for booking: $bookingId');
      _socket!.emit('joinRoom', {'bookingId': bookingId});
    } catch (e) {
      log('❌ Error joining chat room: $e');
      _errorController.add('Failed to join chat room: $e');
      rethrow;
    }
  }

  /// Leave the current chat room
  void leaveChatRoom() {
    if (_isConnected) {
      log('🚪 Leaving current chat room');
    }
  }

  /// Send a chat message
  Future<void> sendMessage(String bookingId, String message) async {
    if (!_isConnected) {
      await connect();
    }

    try {
      log('📤 Sending message: $message');
      _socket!.emit('chatMessage', {
        'bookingId': bookingId,
        'message': message,
      });
    } catch (e) {
      log('❌ Error sending message: $e');
      _errorController.add('Failed to send message: $e');
      rethrow;
    }
  }

  // Simple text chat - no read status needed

  /// Disconnect the socket
  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
      _isConnected = false;
      _listenersSetup = false;
      log('👋 Chat socket disconnected');
    }
  }

  /// Check if socket is connected
  bool get isConnected => _isConnected;

  /// Check if socket is properly initialized
  bool get isInitialized => _socket != null && _listenersSetup;

  /// Dispose resources
  void dispose() {
    disconnect();
    _messageController.close();
    _errorController.close();
  }

  /// Reset the singleton instance (mainly for testing)
  static void resetInstance() {
    _instance?.dispose();
    _instance = null;
  }

  // Legacy method for compatibility - delegates to connect()
  Future<void> initSocket() async {
    await connect();
  }

  // Legacy method for compatibility
  Future<void> waitUntilReady({int timeoutMs = 5000}) async {
    int waited = 0;
    while (!_isConnected && waited < timeoutMs) {
      await Future.delayed(const Duration(milliseconds: 200));
      waited += 200;
    }

    if (!_isConnected) {
      throw Exception('Socket not ready after waiting $timeoutMs ms');
    }
  }

  // Legacy methods for compatibility with existing code
  void emit(String event, dynamic data) {
    if (_isConnected && _socket != null) {
      log('📤 Emitting event [$event] with data: $data');
      _socket!.emit(event, data);
    } else {
      log('⚠️ Cannot emit [$event] — socket not connected');
    }
  }

  void on(String event, Function(dynamic) callback) {
    if (_socket != null) {
      _socket!.off(event);
      _socket!.on(event, (data) {
        log('📥 Received event [$event]: $data');
        callback(data);
      });
    }
  }
}
