import 'package:flutter/material.dart';
import 'package:swallow/Login/Scaffold/login_screen.dart';
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
    default:
      return MaterialPageRoute(builder: (context) => const Scaffold(
        body: Center(
          child: Text("Error"),
        )
      ),
      );
  }
}