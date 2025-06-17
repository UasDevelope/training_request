import 'package:training_request/utils/const/app_img.dart';

class ChatUser {
  final List<Map<String, dynamic>> chatUser = [
    {
      "id": "1",
      "userName": "Alice",
      "imageUrl":AppImages.profile,
      "lastMessage": "Hey, how are you?",
      "time": "10:45 AM",
      "isRead": true,
    },
    {
      "id": "2",
      "userName": "Bob",
      "imageUrl":AppImages.person,
      "lastMessage": "Let’s meet tomorrow.",
      "time": "09:20 AM",
      "isRead": false,
    },
    {
      "id": "3",
      "userName": "Charlie",
      "imageUrl": AppImages.person1,
      "lastMessage": "Got the documents.",
      "time": "Yesterday",
      "isRead": true,
    },
  ];
}
