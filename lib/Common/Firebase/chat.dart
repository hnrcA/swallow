import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Enum/message.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Model/message.dart';
import 'package:swallow/Model/user.dart';
import 'package:swallow/Model/chat.dart';
import 'package:uuid/uuid.dart';

final chatProvider = Provider((ref) => Chat(FirebaseFirestore.instance, FirebaseAuth.instance));

class Chat {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  Chat(this.firestore, this.auth);

  void _saveToCollection(UserM senderData, UserM recieverData, String text, DateTime sent, String receiverId) async {
    var receiverChat = ChatContact(name: senderData.name, picture: senderData.picture, id: senderData.uid, sent: sent, lastMessage:text );
    await firestore.collection('Users').doc(receiverId).collection('Chat').doc(auth.currentUser!.uid).set(receiverChat.toMap());

    var senderChat = ChatContact(name: recieverData.name, picture: recieverData.picture, id: recieverData.uid, sent: sent, lastMessage:text );
    await firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').doc(receiverId).set(receiverChat.toMap());
  }

  void _saveMessageToCollection(String messageId, String text, DateTime sent, String username, String recieverId, String recieverUsername, MessageEnum messageType ) async {
    final message = Message(senderId: auth.currentUser!.uid, recieverId: recieverId, messageId: messageId, message: text, sent: sent, seen: false, type: messageType);
    await firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').doc(recieverId).collection('Message').doc(messageId).set(message.toMap());
    await firestore.collection('Users').doc(recieverId).collection('Chat').doc(auth.currentUser!.uid).collection('Message').doc(messageId).set(message.toMap());
  }

  void sendMessage({
    required BuildContext context,
    required String message,
    required String receiverUid,
    required UserM senderData
  }) async {
    try {
      var sent = DateTime.now();
      UserM recieverData;

      var userDataMap = await firestore.collection('Users').doc(receiverUid).get();
      recieverData = UserM.fromMap(userDataMap.data()!);

      _saveToCollection(
        senderData,
        recieverData,
        message,
        sent,
        receiverUid
      );

      var messageId = const Uuid().v4();

      _saveMessageToCollection(
        messageId,
        message,
        sent,
        senderData.name,
        receiverUid,
        recieverData.name,
        MessageEnum.text

      );
    } catch (e) {
      snackBar(context, e.toString());
    }
  }
}