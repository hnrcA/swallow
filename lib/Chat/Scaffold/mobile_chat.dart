import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:swallow/Chat/widget/chatBottom.dart';
import 'package:swallow/Chat/widget/list.dart';
import 'package:swallow/Common/Layouts/mobile_layout.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Login/auth.dart';
import 'package:swallow/Chat/controller.dart';

import '../../Model/user.dart';

class MobileChat extends ConsumerWidget {
  static const String route = '/chat';
  final String uid;
  final String name;

  const MobileChat(this.uid, this.name, {super.key});

  void backToScreen(BuildContext context) {
   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  const MobileLayout()), (route) => false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Center(
          child: StreamBuilder<UserM>(
            stream: ref.read(authProvider).userData(uid),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting ) {
                return const Loader();
              }
              return Column(
                children: [
                  Text(name, style: const TextStyle(fontSize: 20),),
                  Text(
                    snapshot.data!.isOnline ? 'Elérhető' : 'Nem elérhető',
                    style: const TextStyle(
                      fontSize: 14,
                    ))
                ],
              );
            }
          ),
        ),
        centerTitle: false,
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
                PopupMenuItem<int>(child: TextButton(onPressed: () => [ref.read(chatControllerProvider).deleteChat(context, uid), backToScreen(context)], child: const Text("Beszélgetés törlése"))),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(recieverId: uid),
          ),
          BottomChat(recieverId: uid),
        ],
      ),
    );
  }
}