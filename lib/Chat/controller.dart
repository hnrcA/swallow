import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Enum/message.dart';
import 'package:swallow/Common/Firebase/chat.dart';
import 'package:swallow/Login/controller.dart';

import '../Model/chat.dart';
import '../Model/message.dart';

final chatControllerProvider = Provider((ref) {
  final chat = ref.watch(chatProvider);
  return ChatController(chat,ref);
});

class ChatController {
  final Chat chatrepo; //TODO REPo
  final ProviderRef ref;

  ChatController(this.chatrepo, this.ref);

  Stream<List<ChatContact>> chatContacts () {
    return chatrepo.getContacts();
  }

  Stream<List<Message>> getChat (String recieverId) {
    return chatrepo.getChat(recieverId);
  }

  void sendMessage(BuildContext context, String text, String receiverUid ) {
    ref.watch(userAuthProvider).whenData((value) => chatrepo.sendMessage(context: context, message: text, receiverUid: receiverUid, senderData: value!));
  }

  void sendPicture(BuildContext context, File file, String receiverUid, MessageEnum messageEnum ) {
    ref.read(userAuthProvider).whenData((value) => chatrepo.sendPicture(context, file, receiverUid, value!, ref, messageEnum));
  }

  void setChatSeen (BuildContext context, String receiverId, String messageId) {
    chatrepo.setChatSeen(context, receiverId, messageId);
  }

  void deleteChat(BuildContext context, String receiverId) {
    chatrepo.deleteChatFromCollection(context, receiverId);
  }
}