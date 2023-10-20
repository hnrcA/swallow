import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swallow/Landing/Scaffold/landing_screen.dart';
import 'firebase_options.dart';

import 'package:swallow/common/color.dart';
import 'package:swallow/Common/router.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swallow',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const LandingScreen()
    );
  }
}
