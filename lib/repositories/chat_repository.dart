import 'package:training_request/utils/socket_utils.dart';

class ChatRepository {
  final SocketService _socketService = SocketService();
  
  Future<void> sendMessage(String message, String bookingId) async {
    _socketService.emit('chatMessage', {
      'bookingId': bookingId,
      'message': message,
    });
  }
  
  Future<void> joinRoom(String bookingId) async {
    _socketService.emit('joinRoom', {'bookingId': bookingId});
  }
  
  void onMessageReceived(Function(dynamic) callback) {
    _socketService.on('chatMessage', callback);
  }
}
