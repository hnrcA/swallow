import 'package:flutter/material.dart';
import 'package:swallow/Chat/widget/chatBottom.dart';
import 'package:swallow/common/Widgets/list.dart';

class MobileChat extends StatelessWidget {
  static const String route = '/chat';
  final String uid;
  final String name;

  const MobileChat(this.uid, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(name),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(
            child: ChatList(),
          ),
          BottomChat(recieverId: uid),
        ],
      ),
    );
  }
}