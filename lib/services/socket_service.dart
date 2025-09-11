import 'dart:async';
import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../api/api_constants.dart';
import '../services/local/storage.dart';

class SocketService {
  static SocketService? _instance;
  static SocketService get instance => _instance ??= SocketService._internal();
  
  SocketService._internal();

  IO.Socket? _socket;
  String? _currentToken;
  String? _currentBookingId;
  bool _isConnected = false;
  bool _isConnecting = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);

  // Stream controllers for different events
  final StreamController<Map<String, dynamic>> _messageController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _typingController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _statusController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<Map<String, dynamic>> _locationController = 
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<String> _errorController = 
      StreamController<String>.broadcast();
  final StreamController<bool> _connectionController = 
      StreamController<bool>.broadcast();

  // Getters for streams
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<Map<String, dynamic>> get typingStream => _typingController.stream;
  Stream<Map<String, dynamic>> get statusStream => _statusController.stream;
  Stream<Map<String, dynamic>> get locationStream => _locationController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;

  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  String? get currentBookingId => _currentBookingId;

  /// Initialize socket connection with authentication
  Future<bool> initializeSocket() async {
    if (_isConnecting) {
      log('⚠️ Socket connection already in progress');
      return false;
    }

    try {
      _isConnecting = true;
      
      // Get token from storage
      _currentToken = await LocalStorage.getString(LocalStorage.AcessToken);
      
      if (_currentToken == null || _currentToken!.isEmpty) {
        log('❌ No valid token available for socket connection');
        _errorController.add('Authentication required. Please login first.');
        _isConnecting = false;
        return false;
      }

      log('🔌 Initializing socket connection...');
      
      // Create socket connection with proper configuration
      _socket = IO.io(ApiConstants.SocketUrl, <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'autoConnect': false,
        'reconnection': true,
        'reconnectionAttempts': _maxReconnectAttempts,
        'reconnectionDelay': 1000,
        'reconnectionDelayMax': 5000,
        'timeout': 20000,
        'auth': {
          'token': _currentToken,
        },
        'extraHeaders': {
          'Authorization': 'Bearer $_currentToken',
        },
      });

      _setupSocketListeners();
      
      // Connect to socket
      _socket!.connect();
      
      // Wait for connection with timeout
      bool connected = await _waitForConnection();
      _isConnecting = false;
      
      if (connected) {
        log('✅ Socket connected successfully');
        _reconnectAttempts = 0;
        return true;
      } else {
        log('❌ Socket connection failed');
        return false;
      }
      
    } catch (e) {
      log('❌ Error initializing socket: $e');
      _errorController.add('Failed to initialize socket: $e');
      _isConnecting = false;
      return false;
    }
  }

  /// Wait for socket connection with timeout
  Future<bool> _waitForConnection() async {
    Completer<bool> completer = Completer<bool>();
    Timer? timeoutTimer;
    
    void onConnect(_) {
      if (!completer.isCompleted) {
        completer.complete(true);
      }
    }
    
    void onConnectError(error) {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    }
    
    void onTimeout() {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    }
    
    _socket!.onConnect(onConnect);
    _socket!.onConnectError(onConnectError);
    
    timeoutTimer = Timer(const Duration(seconds: 10), onTimeout);
    
    bool result = await completer.future;
    
    timeoutTimer.cancel();
    // Note: Socket.IO client doesn't have offConnect/offConnectError methods
    // The listeners will be automatically cleaned up when socket is disposed
    
    return result;
  }

  /// Setup all socket event listeners
  void _setupSocketListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      log('✅ Socket connected successfully');
      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0;
      _connectionController.add(true);
      
      // Emit a test message to verify connection
      _socket!.emit('ping', {'message': 'Client connected', 'timestamp': DateTime.now().toIso8601String()});
    });

    _socket!.onDisconnect((_) {
      log('❌ Socket disconnected');
      _isConnected = false;
      _connectionController.add(false);
      _scheduleReconnect();
    });

    _socket!.onConnectError((error) {
      log('❌ Socket connection error: $error');
      _isConnected = false;
      _isConnecting = false;
      _errorController.add('Connection failed: $error');
      _scheduleReconnect();
    });

    // Chat message events
    _socket!.on('chatMessage', (data) {
      log('📥 Received chat message: $data');
      _messageController.add(data);
    });

    // Also listen for 'message' event (common Socket.IO event name)
    _socket!.on('message', (data) {
      log('📥 Received message: $data');
      _messageController.add(data);
    });

    // Listen for 'newMessage' event (another common pattern)
    _socket!.on('newMessage', (data) {
      log('📥 Received new message: $data');
      _messageController.add(data);
    });

    _socket!.on('messageSent', (data) {
      log('✅ Message sent successfully: $data');
      _statusController.add({'type': 'sent', 'data': data});
    });

    _socket!.on('messageDelivered', (data) {
      log('📨 Message delivered: $data');
      _statusController.add({'type': 'delivered', 'data': data});
    });

    _socket!.on('messagesRead', (data) {
      log('👁️ Messages read: $data');
      _statusController.add({'type': 'read', 'data': data});
    });

    // Typing indicators
    _socket!.on('userTyping', (data) {
      log('⌨️ User typing: $data');
      _typingController.add({'type': 'start', 'data': data});
    });

    _socket!.on('userStoppedTyping', (data) {
      log('⏹️ User stopped typing: $data');
      _typingController.add({'type': 'stop', 'data': data});
    });

    // Location updates
    _socket!.on('locationUpdate', (data) {
      log('📍 Location update: $data');
      _locationController.add(data);
    });

    // Room events
    _socket!.on('roomJoined', (data) {
      log('🚪 Joined chat room: $data');
    });

    // Error handling
    _socket!.on('error', (data) {
      log('❌ Socket error: $data');
      _errorController.add(data['message'] ?? 'Unknown error occurred');
    });

    // Reconnection events
    _socket!.onReconnect((_) {
      log('🔄 Socket reconnected');
      _isConnected = true;
      _reconnectAttempts = 0;
      _connectionController.add(true);
    });

    _socket!.onReconnectAttempt((attemptNumber) {
      log('🔄 Reconnection attempt: $attemptNumber');
      _reconnectAttempts = attemptNumber;
    });

    _socket!.onReconnectError((error) {
      log('❌ Reconnection error: $error');
      _errorController.add('Reconnection failed: $error');
    });

    _socket!.onReconnectFailed((_) {
      log('❌ Reconnection failed after $_maxReconnectAttempts attempts');
      _errorController.add('Failed to reconnect after $_maxReconnectAttempts attempts');
    });
  }

  /// Schedule reconnection attempt
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      log('❌ Max reconnection attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      if (!_isConnected && !_isConnecting) {
        log('🔄 Attempting to reconnect...');
        initializeSocket();
      }
    });
  }

  /// Join a specific chat room
  Future<bool> joinChatRoom(String bookingId) async {
    if (_socket == null || !_isConnected) {
      log('❌ Socket not connected, cannot join room');
      return false;
    }

    try {
      _currentBookingId = bookingId;
      _socket!.emit('joinRoom', {'bookingId': bookingId});
      log('🚪 Joining chat room: $bookingId');
      return true;
    } catch (e) {
      log('❌ Error joining chat room: $e');
      _errorController.add('Failed to join chat room: $e');
      return false;
    }
  }

  /// Send a chat message
  Future<bool> sendMessage(String message, String bookingId) async {
    if (_socket == null || !_isConnected) {
      log('❌ Socket not connected, cannot send message');
      return false;
    }

    if (message.trim().isEmpty) {
      log('❌ Cannot send empty message');
      return false;
    }

    try {
      _socket!.emit('chatMessage', {
        'bookingId': bookingId,
        'message': message.trim(),
        'timestamp': DateTime.now().toIso8601String(),
      });
      log('📤 Sending message: $message');
      return true;
    } catch (e) {
      log('❌ Error sending message: $e');
      _errorController.add('Failed to send message: $e');
      return false;
    }
  }

  /// Start typing indicator
  Future<bool> startTyping(String bookingId) async {
    if (_socket == null || !_isConnected) return false;

    try {
      _socket!.emit('typingStart', {'bookingId': bookingId});
      log('⌨️ Started typing indicator');
      return true;
    } catch (e) {
      log('❌ Error starting typing: $e');
      return false;
    }
  }

  /// Stop typing indicator
  Future<bool> stopTyping(String bookingId) async {
    if (_socket == null || !_isConnected) return false;

    try {
      _socket!.emit('typingStop', {'bookingId': bookingId});
      log('⏹️ Stopped typing indicator');
      return true;
    } catch (e) {
      log('❌ Error stopping typing: $e');
      return false;
    }
  }

  /// Mark messages as read
  Future<bool> markMessagesAsRead(List<String> messageIds, String bookingId) async {
    if (_socket == null || !_isConnected) return false;

    try {
      _socket!.emit('markAsRead', {
        'bookingId': bookingId,
        'messageIds': messageIds,
        'timestamp': DateTime.now().toIso8601String(),
      });
      log('👁️ Marking messages as read: $messageIds');
      return true;
    } catch (e) {
      log('❌ Error marking messages as read: $e');
      return false;
    }
  }

  /// Update location (for service providers)
  Future<bool> updateLocation({
    required double latitude,
    required double longitude,
    required String locationName,
    required String bookingId,
    String updateType = 'manual',
  }) async {
    if (_socket == null || !_isConnected) return false;

    try {
      _socket!.emit('updateLocation', {
        'latitude': latitude,
        'longitude': longitude,
        'locationName': locationName,
        'bookingId': bookingId,
        'updateType': updateType,
        'timestamp': DateTime.now().toIso8601String(),
      });
      log('📍 Updating location: $latitude, $longitude');
      return true;
    } catch (e) {
      log('❌ Error updating location: $e');
      return false;
    }
  }

  /// Leave current chat room
  Future<bool> leaveChatRoom() async {
    if (_socket == null || !_isConnected) return false;

    try {
      _currentBookingId = null;
      log('👋 Left chat room');
      return true;
    } catch (e) {
      log('❌ Error leaving chat room: $e');
      return false;
    }
  }

  /// Disconnect socket
  Future<void> disconnect() async {
    try {
      _reconnectTimer?.cancel();
      _currentBookingId = null;
      _isConnected = false;
      _isConnecting = false;
      _reconnectAttempts = 0;
      
      if (_socket != null) {
        _socket!.disconnect();
        _socket!.dispose();
        _socket = null;
      }
      
      log('🔌 Socket disconnected');
    } catch (e) {
      log('❌ Error disconnecting socket: $e');
    }
  }

  /// Force reconnect socket
  Future<bool> forceReconnect() async {
    log('🔄 Force reconnecting socket...');
    await disconnect();
    return await initializeSocket();
  }

  /// Get connection status
  String getConnectionStatus() {
    if (_isConnecting) return 'Connecting...';
    if (_isConnected) return 'Connected';
    return 'Disconnected';
  }

  /// Dispose all resources
  void dispose() {
    disconnect();
    _messageController.close();
    _typingController.close();
    _statusController.close();
    _locationController.close();
    _errorController.close();
    _connectionController.close();
  }
}
