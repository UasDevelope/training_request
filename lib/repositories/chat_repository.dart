import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../api/api_constants.dart';
import '../services/local/storage.dart';
import '../api/api_exception.dart';
import '../models/order_chat.dart';
import '../services/socket_service.dart';

class ChatRepository {
  final SocketService _socketService = SocketService.instance;

  /// Check if chat is available for a booking
  Future<Map<String, dynamic>> checkChatAvailability(String bookingId) async {
    try {
      final token = await LocalStorage.getString(LocalStorage.AcessToken);
      if (token == null || token.isEmpty) {
        throw ApiException('Authentication required. Please login first.');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.chatAvailability}/$bookingId/availability'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log('✅ Chat availability checked: $data');
        return data;
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        throw NotFoundException();
      } else {
        throw ApiException('Failed to check chat availability: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Error checking chat availability: $e');
      rethrow;
    }
  }

  /// Get chat messages history from REST API
  Future<List<OrderChatMessage>> getChatHistory(String bookingId) async {
    try {
      final token = await LocalStorage.getString(LocalStorage.AcessToken);
      if (token == null || token.isEmpty) {
        throw ApiException('Authentication required. Please login first.');
      }

      final response = await http.get(
        Uri.parse('${ApiConstants.getChatHistory}/$bookingId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final messages = data['messages'] as List? ?? [];
        
        // Get current user ID for determining if message is from current user
        final currentUserId = await _getCurrentUserId();
        
        final chatMessages = messages.map((msg) => 
          OrderChatMessage.fromMap(msg, currentUserId)
        ).toList();
        
        log('✅ Chat history loaded: ${chatMessages.length} messages');
        return chatMessages;
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        throw NotFoundException();
      } else {
        throw ApiException('Failed to get chat history: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Error getting chat history: $e');
      rethrow;
    }
  }

  /// Send message via REST API (fallback when socket is not available)
  Future<OrderChatMessage> sendMessageViaAPI(String message, String bookingId) async {
    try {
      final token = await LocalStorage.getString(LocalStorage.AcessToken);
      if (token == null || token.isEmpty) {
        throw ApiException('Authentication required. Please login first.');
      }

      if (message.trim().isEmpty) {
        throw ApiException('Message cannot be empty');
      }

      final response = await http.post(
        Uri.parse('${ApiConstants.sendMessage}/$bookingId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'message': message.trim()}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final currentUserId = await _getCurrentUserId();
        final chatMessage = OrderChatMessage.fromMap(data['chatMessage'], currentUserId);
        
        log('✅ Message sent via API: ${chatMessage.message}');
        return chatMessage;
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        throw NotFoundException();
      } else {
        throw ApiException('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Error sending message via API: $e');
      rethrow;
    }
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId) async {
    try {
      final token = await LocalStorage.getString(LocalStorage.AcessToken);
      if (token == null || token.isEmpty) {
        throw ApiException('Authentication required. Please login first.');
      }

      final response = await http.delete(
        Uri.parse('${ApiConstants.deleteMessage}/$messageId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        log('✅ Message deleted: $messageId');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        throw NotFoundException();
      } else {
        throw ApiException('Failed to delete message: ${response.statusCode}');
      }
    } catch (e) {
      log('❌ Error deleting message: $e');
      rethrow;
    }
  }

  /// Initialize socket connection
  Future<bool> initializeSocket() async {
    try {
      final success = await _socketService.initializeSocket();
      if (success) {
        log('✅ Socket service initialized successfully');
      } else {
        log('❌ Socket service initialization failed');
      }
      return success;
    } catch (e) {
      log('❌ Error initializing socket: $e');
      rethrow;
    }
  }

  /// Join chat room via socket
  Future<bool> joinChatRoom(String bookingId) async {
    try {
      final success = await _socketService.joinChatRoom(bookingId);
      if (success) {
        log('✅ Joined chat room: $bookingId');
      } else {
        log('❌ Failed to join chat room: $bookingId');
      }
      return success;
    } catch (e) {
      log('❌ Error joining chat room: $e');
      rethrow;
    }
  }

  /// Send message via socket
  Future<bool> sendMessageViaSocket(String message, String bookingId) async {
    try {
      final success = await _socketService.sendMessage(message, bookingId);
      if (success) {
        log('✅ Message sent via socket: $message');
      } else {
        log('❌ Failed to send message via socket: $message');
      }
      return success;
    } catch (e) {
      log('❌ Error sending message via socket: $e');
      rethrow;
    }
  }

  /// Start typing indicator
  Future<bool> startTyping(String bookingId) async {
    try {
      return await _socketService.startTyping(bookingId);
    } catch (e) {
      log('❌ Error starting typing: $e');
      return false;
    }
  }

  /// Stop typing indicator
  Future<bool> stopTyping(String bookingId) async {
    try {
      return await _socketService.stopTyping(bookingId);
    } catch (e) {
      log('❌ Error stopping typing: $e');
      return false;
    }
  }

  /// Mark messages as read
  Future<bool> markMessagesAsRead(List<String> messageIds, String bookingId) async {
    try {
      return await _socketService.markMessagesAsRead(messageIds, bookingId);
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
    try {
      return await _socketService.updateLocation(
        latitude: latitude,
        longitude: longitude,
        locationName: locationName,
        bookingId: bookingId,
        updateType: updateType,
      );
    } catch (e) {
      log('❌ Error updating location: $e');
      return false;
    }
  }

  /// Leave chat room
  Future<bool> leaveChatRoom() async {
    try {
      final success = await _socketService.leaveChatRoom();
      if (success) {
        log('✅ Left chat room');
      } else {
        log('❌ Failed to leave chat room');
      }
      return success;
    } catch (e) {
      log('❌ Error leaving chat room: $e');
      return false;
    }
  }

  /// Disconnect socket
  Future<void> disconnectSocket() async {
    try {
      await _socketService.disconnect();
      log('✅ Socket disconnected');
    } catch (e) {
      log('❌ Error disconnecting socket: $e');
    }
  }

  /// Get socket streams
  Stream<Map<String, dynamic>> get messageStream => _socketService.messageStream;
  Stream<Map<String, dynamic>> get typingStream => _socketService.typingStream;
  Stream<Map<String, dynamic>> get statusStream => _socketService.statusStream;
  Stream<Map<String, dynamic>> get locationStream => _socketService.locationStream;
  Stream<String> get errorStream => _socketService.errorStream;
  Stream<bool> get connectionStream => _socketService.connectionStream;

  /// Check if socket is connected
  bool get isSocketConnected => _socketService.isConnected;

  /// Check if socket is connecting
  bool get isSocketConnecting => _socketService.isConnecting;

  /// Get current booking ID
  String? get currentBookingId => _socketService.currentBookingId;

  /// Get current user ID from JWT token
  Future<String> _getCurrentUserId() async {
    try {
      final token = await LocalStorage.getString(LocalStorage.AcessToken);
      if (token != null && token.isNotEmpty) {
        // Extract user ID from JWT token (you may need to implement JWT decoding)
        // For now, we'll use a placeholder
        return _extractUserIdFromToken(token);
      }
      
      // Fallback to a default user ID if token is not available
      return 'user_123';
    } catch (e) {
      log('❌ Error getting current user ID: $e');
      return 'unknown_user';
    }
  }

  /// Extract user ID from JWT token
  String _extractUserIdFromToken(String token) {
    try {
      // Simple JWT payload extraction (you may want to use a proper JWT library)
      final parts = token.split('.');
      if (parts.length == 3) {
        final payload = parts[1];
        final normalized = base64Url.normalize(payload);
        final resp = utf8.decode(base64Url.decode(normalized));
        final payloadMap = json.decode(resp);
        
        // Extract user ID from payload (adjust based on your JWT structure)
        return payloadMap['userId']?.toString() ?? 
               payloadMap['sub']?.toString() ?? 
               payloadMap['id']?.toString() ?? 
               'user_123';
      }
    } catch (e) {
      log('❌ Error extracting user ID from token: $e');
    }
    
    return 'user_123';
  }

  /// Dispose resources
  void dispose() {
    _socketService.dispose();
  }
}
