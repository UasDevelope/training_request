import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:training_request/api/api_constants.dart';
import 'package:training_request/services/local/storage.dart';

class SocketService {
  late IO.Socket _socket;
  bool _isConnected = false;

  /// Initialize the socket with optional auth
  Future<void> initSocket() async {
    try {
      final token = await LocalStorage.getString(LocalStorage.AcessToken);
      log('🔌 Connecting to socket with token: $token');

      _socket = IO.io(
        ApiConstants.SocketUrl,
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
          'auth': {
            'token': token,
          },
        },
      );

      _socket.connect();

      _socket.onConnect((_) {
        _isConnected = true;
        log('✅ Socket connected');
      });

      _socket.onDisconnect((_) {
        _isConnected = false;
        log('❌ Socket disconnected');
        // Try to reconnect after a delay
        Future.delayed(Duration(seconds: 2), () {
          if (!_isConnected) {
            log('🔄 Attempting to reconnect...');
            _socket.connect();
          }
        });
      });

      _socket.onConnectError((err) {
        log('⚠️ Connect error: $err');
        _isConnected = false;
      });

      _socket.onError((err) {
        log('🔥 Socket error: $err');
        _isConnected = false;
      });

      // Wait a bit for connection to establish
      await Future.delayed(Duration(milliseconds: 500));
    } catch (e) {
      log('❌ Error in initSocket: $e');
      _isConnected = false;
      rethrow;
    }
  }

  /// Emit an event with optional data
  void emit(String event, dynamic data) {
    try {
      if (_isConnected) {
        log('📤 Emitting event [$event] with data: $data');
        _socket.emit(event, data);
      } else {
        log('⚠️ Cannot emit [$event] — socket not connected or not initialized');
        // Try to connect and emit
        _socket.connect();
        _socket.emit(event, data);
      }
    } catch (e) {
      log('❌ Error in emit: $e');
    }
  }

  /// Listen to an event
  Future<void> on(String event, Function(dynamic) callback) async {
    try {
      _socket.off(event);
      await Future.delayed(Duration(milliseconds: 100));
      _socket.on(event, (data) {
        log('📥 Received event [$event]: $data');
        callback(data);
      });
      log('✅ Listening for event: $event');
    } catch (e) {
      log('❌ Error setting up listener for event [$event]: $e');
    }
  }

  /// Disconnect the socket
  void disconnect() {
    if (_isConnected) {
      _socket.disconnect();
      log('👋 Socket manually disconnected');
    }
  }

  /// Check connection status
  bool get isConnected => _isConnected;

  /// Check if socket is ready for operations
  bool get isReady => _socket != null && _isConnected;

  /// Ensure connection and emit
  void ensureConnectedAndEmit(String event, dynamic data) {
    try {
      if (_socket == null) {
        log('❌ Socket not initialized, cannot emit [$event]');
        return;
      }

      if (!_isConnected) {
        log('🔄 Reconnecting socket...');
        _socket.connect();
        // Give it a moment to connect
        Future.delayed(Duration(milliseconds: 100), () {
          if (_socket != null) {
            log('📤 Emitting event [$event] with data: $data');
            _socket.emit(event, data);
          }
        });
      } else {
        log('📤 Emitting event [$event] with data: $data');
        _socket.emit(event, data);
      }
    } catch (e) {
      log('❌ Error in ensureConnectedAndEmit: $e');
    }
  }

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
}
