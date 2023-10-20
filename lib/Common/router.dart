import 'package:flutter/material.dart';
import 'package:swallow/Login/Scaffold/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch(settings.name) {
    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => const LoginScreen(),
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