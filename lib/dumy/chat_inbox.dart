class ChatInboxData {
  List<Map<String, dynamic>> chatInbox = [
    {
      "message": "Hey! Are you available for a quick call?",
      "senderId": "user_1",
      "recievrId": "user_2",
      "time": DateTime.now().subtract(Duration(minutes: 5)).toIso8601String(),
      "url": null,
      "isMe": false, // user_1 is not the current user
    },
    {
      "message": "Sure, give me 5 mins.",
      "senderId": "user_2",
      "recievrId": "user_1",
      "time": DateTime.now().subtract(Duration(minutes: 3)).toIso8601String(),
      "url": null,
      "isMe": true, // user_2 is the current user
    },
    {
      "message": "Sending you the document now.",
      "senderId": "user_1",
      "recievrId": "user_2",
      "time": DateTime.now().subtract(Duration(minutes: 1)).toIso8601String(),
      "url": "https://example.com/doc.pdf",
      "isMe": false,
    },
  ];
}
