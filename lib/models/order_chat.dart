class OrderChatMessage {
  final String id;
  final String userId;
  final String senderName;
  final String senderRole;
  final String message;
  final DateTime timestamp;
  final String status;
  final String bookingId;
  final bool isMe;

  OrderChatMessage({
    required this.id,
    required this.userId,
    required this.senderName,
    required this.senderRole,
    required this.message,
    required this.timestamp,
    required this.status,
    required this.bookingId,
    required this.isMe,
  });

  factory OrderChatMessage.fromMap(Map<String, dynamic> map, String currentUserId) {
    return OrderChatMessage(
      id: map['_id'] ?? '',
      userId: map['userId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderRole: map['senderRole'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      status: map['status'] ?? '',
      bookingId: map['bookingId'] ?? '',
      isMe: map['userId'] == currentUserId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId,
      'senderName': senderName,
      'senderRole': senderRole,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'bookingId': bookingId,
    };
  }
} 