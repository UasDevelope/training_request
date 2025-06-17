class ChatUserModel {
  final String id;
  final String userName;
  final String imageUrl;
  final String lastMessage;
  final String time;
  final bool isRead;
  ChatUserModel({
    required this.id,
    required this.userName,
    required this.imageUrl,
    required this.lastMessage,
    required this.time,
    required this.isRead,
  });
  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      id: map["id"] ?? "12",
      userName: map["userName"] ?? "usama",
      imageUrl: map["imageUrl"] ?? "ok",
      lastMessage: map["lastMessage"] ?? "ok",
      time: map["time"],
      isRead: map["isRead"],
    );
  }
}
