import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:swallow/Widgets/Chat/chat_bottom_field.dart';
import 'package:swallow/Widgets/Chat/chat_list.dart';
import 'package:swallow/Screens/home_screen.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Services/authService.dart';
import 'package:swallow/Controllers/chat_controller.dart';
import 'package:swallow/Models/user.dart';

class ChatScreen extends ConsumerWidget {
  static const String route = '/chat';
  final String uid;
  final String name;

  const ChatScreen(this.uid, this.name, {super.key});

  void backToScreen(BuildContext context) {
   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  const HomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Center(
          child: StreamBuilder<UserModel>(
            stream: ref.read(authServiceProvider).userData(uid),
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
                PopupMenuItem<int>(child: TextButton(onPressed: () => [ref.read(chatControllerProvider).deleteChat(context, uid), backToScreen(context)], child: const Text("Beszélgetés elrejtése/törlése"))),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(receiverId: uid),
          ),
          ChatBottomField(recieverId: uid),
        ],
      ),
    );
  }
}