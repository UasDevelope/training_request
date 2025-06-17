class ChatInboxModel {
  final String message;
  final String senderId;
  final String recievrId;
  final DateTime time;
  final String? url;
  final bool isMe;
  ChatInboxModel({
    required this.message,
    required this.senderId,
    required this.recievrId,
    required this.time,
    this.url,
    required this.isMe,
  });

  factory ChatInboxModel.fromMap(Map<String, dynamic> map) {
    return ChatInboxModel(
      message: map["message"],
      senderId: map["senderId"],
      recievrId: map["recievrId"],
      time: DateTime.parse(map["time"]),
      url: map['url'],
      isMe: map["isMe"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "message": message,
      "senderId": senderId,
      "recievrId": recievrId,
      "time": time.toIso8601String(),
      "url": url,
      "isMe": isMe,
    };
  }
}
