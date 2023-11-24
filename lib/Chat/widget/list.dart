import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:swallow/Chat/controller.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Model/message.dart';
import 'package:swallow/Chat/widget/message_card.dart';
import 'package:swallow/Chat/widget/sender_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverId;
  const ChatList({
    Key? key,
    required this.recieverId
  }) : super(key: key);

  @override
  ConsumerState createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController scrollController = ScrollController();


  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref.watch(chatControllerProvider).getChat(widget.recieverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
          return ListView.builder(
            controller: scrollController ,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var sent = DateFormat.Hm().format(messageData.sent);
              if(!messageData.seen && messageData.recieverId == FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatSeen(context, widget.recieverId, messageData.messageId);
              }
              if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: messageData.message,
                  date: sent,
                  messageEnum: messageData.type,
                  seen: messageData.seen,
                );

              }
              return SenderMessageCard(
                message: messageData.message,
                date: sent, messageEnum: messageData.type,
              );
            },
          );
        }
    );
  }
}
