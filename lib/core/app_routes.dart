import 'package:flutter/material.dart';
import 'package:training_request/screens/auth/signUp.dart';
import 'package:training_request/screens/feedback_screen/feedback.dart';
import 'package:training_request/screens/home/home.dart';
import 'package:training_request/screens/location/location.dart';

import '../screens/Transaction/transaction.dart';
import '../screens/auth/loginSucess.dart';
import '../screens/auth/login_screen.dart';
import '../screens/bottom/bottom.dart';
import '../screens/chat/inbox.dart';
import '../screens/order/order_chat_screen.dart';
import '../screens/splash/splash.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String loginSucess = "/loginSuccess";
  static const String signup = "/signup";
  static const String location="/location";
  static const String home = '/home';
  static const String nav="/nav";
  static const String chatInbox="/inbox";
  static const String transaction=  "/transaction";
  static const String map="/map";
  static const String feedback="/feedback";
  static const String orderChat="/order-chat";
  static Route<dynamic> onGenerateRoute(RouteSettings setting) {
    switch (setting.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case loginSucess:
        return MaterialPageRoute(builder: (_) => Loginsucess());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case location:
        return MaterialPageRoute(builder: (_)=>LocationScreen());
      case nav:
        return MaterialPageRoute(builder: (_)=>BottomNav());
      case chatInbox:
        return MaterialPageRoute(builder: (_)=>ChatInbox());
      case transaction:
        return MaterialPageRoute(builder: (_)=>TransactionHistoryPage());
      case map:
        return MaterialPageRoute(builder: (_)=>HomeScreen());
      case feedback:
        return MaterialPageRoute(builder: (_)=>FeedbackScreen());
      case orderChat:
        final args = setting.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrderChatScreen(
            bookingId: args['bookingId'],
            bookingTitle: args['bookingTitle'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text("No route defined for ${setting.name}"),
                ),
              ),
        );
    }
  }
}
