import 'package:flutter/material.dart';
import 'package:insightmate/auth/screens/signUp.dart';
import 'package:insightmate/auth/screens/signIn.dart';
import 'package:insightmate/chat/chat_Screen.dart';
import 'package:insightmate/dashBoard.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SignUpPage.routeName:
      return MaterialPageRoute(builder: (context) => const SignUpPage());
    case SignInPage.routeName:
      return MaterialPageRoute(builder: (context) => const SignInPage());
    case DashboardPage.routeName:
      return MaterialPageRoute(builder: (context) => const DashboardPage());  
    case ChatScreen.routeName:
      final args = routeSettings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(builder: (context) => ChatScreen(sessionTitle: args['sessionTitle']));  
    default :
      return MaterialPageRoute(builder: (context) => const Scaffold(
        body: Center(
          child: Text('Screen does not exist!!'),
        ),
      ));  
  }
}
