import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Contact/Scaffold/select_contact_screen.dart';
import 'package:swallow/Login/auth.dart';
import 'package:swallow/Profile/Scaffold/profile_screen.dart';
import '../../Chat/widget/contact.dart';

class MobileLayout extends ConsumerStatefulWidget {

  const MobileLayout({super.key});
  @override
  ConsumerState<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<MobileLayout> with WidgetsBindingObserver {

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
        ref.read(authProvider).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(authProvider).setUserState(false);
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
        body: const ContactsList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, ContactScreen.route);
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