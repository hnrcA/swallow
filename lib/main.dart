import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Screens/home_screen.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Screens/Landing/landing_screen.dart';
import 'package:swallow/Controllers/auth_controller.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Swallow',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userAuthProvider).when(data: (user) {
          if (user == null) {
            return const LandingScreen();
          }
          return const HomeScreen();
      }, error: (err, trace) {}, loading: () => const Loader()),
    );
  }
}
