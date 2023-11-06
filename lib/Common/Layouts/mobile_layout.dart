import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swallow/Contact/Scaffold/select_contact_screen.dart';
import 'package:swallow/Login/Scaffold/login_screen.dart';
import '../Widgets/contact.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({Key? key}) : super(key: key);

//Todo kijelenkezés session dispose
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.lightBlue,
          centerTitle: false,
          title: const Text(
            'Swallow',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.grey),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, LoginScreen.route, (route) => false);
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.lightBlue,
            indicatorWeight: 4,
            labelColor: Colors.lightBlue,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'Üzenetek',
              ),
            ],
          ),
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
      ),
    );
  }
}