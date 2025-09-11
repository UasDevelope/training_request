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
    // According to the specification, server sends 'senderId'
    final senderId = (map['senderId'] ?? map['userId'] ?? '').toString();
    
    return OrderChatMessage(
      id: (map['_id'] ?? map['id'] ?? '').toString(),
      userId: senderId,
      senderName: (map['senderName'] ?? '').toString(),
      senderRole: (map['senderRole'] ?? '').toString(),
      message: (map['message'] ?? '').toString(),
      timestamp: DateTime.tryParse((map['timestamp'] ?? '').toString()) ?? DateTime.now(),
      status: (map['status'] ?? 'sent').toString(),
      bookingId: (map['bookingId'] ?? '').toString(),
      isMe: senderId == currentUserId,
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

  OrderChatMessage copyWith({
    String? id,
    String? userId,
    String? senderName,
    String? senderRole,
    String? message,
    DateTime? timestamp,
    String? status,
    String? bookingId,
    bool? isMe,
  }) {
    return OrderChatMessage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      senderName: senderName ?? this.senderName,
      senderRole: senderRole ?? this.senderRole,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      bookingId: bookingId ?? this.bookingId,
      isMe: isMe ?? this.isMe,
    );
  }
} 