import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Enum/message.dart';
import 'package:swallow/Services/chat.dart';
import 'package:swallow/Controllers/auth_controller.dart';
import 'package:swallow/Models/chat.dart';
import 'package:swallow/Models/message.dart';

//region riverpod provider
final chatControllerProvider = Provider((ref) {
  final chat = ref.watch(chatServiceProvider);
  return ChatController(chat,ref);
});
//endregion

class ChatController {
  final ChatService chatService;
  final ProviderRef ref;

  ChatController(this.chatService, this.ref);

  Stream<List<ChatContactModel>> chatContacts () {
    return chatService.getContacts();
  }

  Stream<List<MessageModel>> getChat (String recieverId) {
    return chatService.getChat(recieverId);
  }

  void sendMessage(BuildContext context, String text, String receiverUid ) {
    ref.watch(userAuthProvider).whenData((value) => chatService.sendMessage(context: context, message: text, receiverUid: receiverUid, senderData: value!));
  }

  void sendPicture(BuildContext context, File file, String receiverUid, MessageEnum messageEnum ) {
    ref.read(userAuthProvider).whenData((value) => chatService.sendPicture(context, file, receiverUid, value!, ref, messageEnum));
  }

  void setChatSeen (BuildContext context, String receiverId, String messageId) {
    chatService.setChatSeen(context, receiverId, messageId);
  }

  void deleteChat(BuildContext context, String receiverId) {
    chatService.deleteChatFromCollection(context, receiverId);
  }
}