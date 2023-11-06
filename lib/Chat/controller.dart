import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Firebase/chat.dart';
import 'package:swallow/Login/controller.dart';

final chatControllerProvider = Provider((ref) {
  final chat = ref.watch(chatProvider);
  return ChatController(chat,ref);
});

class ChatController {
  final Chat chatrepo;
  final ProviderRef ref;

  ChatController(this.chatrepo, this.ref);

  void sendMessage(BuildContext context, String text, String receiverUid ) {
    ref.read(userAuthProvider).whenData((value) => chatrepo.sendMessage(context: context, message: text, receiverUid: receiverUid, senderData: value!));
  }
}