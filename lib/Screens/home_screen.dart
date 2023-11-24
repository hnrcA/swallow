import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Screens/Contact/select_contact_screen.dart';
import 'package:swallow/Services/auth.dart';
import 'package:swallow/Screens/Profile/profile_screen.dart';
import 'package:swallow/Widgets/Chat/contact_list.dart';

class HomeScreen extends ConsumerStatefulWidget {

  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<HomeScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch(state) {
      case AppLifecycleState.resumed:
        ref.read(authServiceProvider).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(authServiceProvider).setUserState(false);
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.lightBlue,
          centerTitle: false,
          title: const Text(
            'Swallow',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.route);
              },
            ),
          ],
        ),
        body: const ContactList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SelectContactScreen.route);
          },
          backgroundColor: Colors.lightBlue,
          child: const Icon(
            Icons.plus_one,
            color: Colors.white,
          ),
        ),
      );
  }
}