//TODO SZÍNEK Kiválasztása

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Layouts/mobile_layout.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Landing/Scaffold/landing_screen.dart';
import 'package:swallow/Login/controller.dart';
import 'firebase_options.dart';

import 'package:swallow/Common/router.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Swallow',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userAuthProvider).when(data: (user) {
        if (user == null) {
          return const LandingScreen();
        }
        return const MobileLayout();
      }, error: (err, trace) {snackBar(context, err.toString());}, loading: () => const Loader()),
    );
  }
}
