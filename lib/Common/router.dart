import 'package:flutter/material.dart';
import 'package:swallow/Chat/Scaffold/mobile_chat.dart';
import 'package:swallow/Login/Scaffold/login_screen.dart';
import 'package:swallow/Profile/Scaffold/profile_screen.dart';
import '../Contact/Scaffold/select_contact_screen.dart';
import '../Login/Scaffold/otp_screen.dart';
import '../Login/Scaffold/user_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch(settings.name) {
    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => const LoginScreen(),
      );
    case OtpScreen.route:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(builder: (context) => OtpScreen(verificationId: verificationId),
      );
    case UserScreen.route:
      return MaterialPageRoute(builder: (context) => const UserScreen(),
      );
    case ProfileScreen.route:
      return MaterialPageRoute(builder: (context) =>  const ProfileScreen(),
      );
    case ContactScreen.route:
      return MaterialPageRoute(builder: (context) => const ContactScreen(),
      );
    case MobileChat.route:
      final arguments = settings.arguments as Map<String, dynamic>;
      final uid = arguments['uid'];
      final name = arguments['name'];
      return MaterialPageRoute(builder: (context) => MobileChat(uid, name));
    default:
      return MaterialPageRoute(builder: (context) => const Scaffold(
        body: Center(
          child: Text("Error"),
        )
      ),
      );
  }
}