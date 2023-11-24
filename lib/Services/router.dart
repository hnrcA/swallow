import 'package:flutter/material.dart';
import 'package:swallow/Screens/Chat/chat_screen.dart';
import 'package:swallow/Screens/Login/login_screen.dart';
import 'package:swallow/Screens/Profile/profile_screen.dart';
import 'package:swallow/Screens/Contact/select_contact_screen.dart';
import 'package:swallow/Screens/Login/otp_screen.dart';
import 'package:swallow/Screens/Login/user_screen.dart';

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
    case SelectContactScreen.route:
      return MaterialPageRoute(builder: (context) => const SelectContactScreen(),
      );
    case ChatScreen.route:
      final arguments = settings.arguments as Map<String, dynamic>;
      final uid = arguments['uid'];
      final name = arguments['name'];
      return MaterialPageRoute(builder: (context) => ChatScreen(uid, name));
    default:
      return MaterialPageRoute(builder: (context) => const Scaffold(
        body: Center(
          child: Text("Error"),
        )
      ),
      );
  }
}