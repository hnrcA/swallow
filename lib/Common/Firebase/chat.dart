import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Enum/message.dart';
import 'package:swallow/Common/Firebase/storage.dart';
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

  Stream<List<ChatContact>> getContacts() {
    return firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').snapshots().asyncMap((event) async {
      List<ChatContact> chats = [];
      for(var doc in event.docs) {
        var chatContact = ChatContact.fromMap(doc.data());
        var userData = await firestore.collection('Users').doc(chatContact.id).get();
        var user = UserM.fromMap(userData.data()!);
        chats.add(ChatContact(name: user.name, picture: chatContact.picture, id: chatContact.id, sent: chatContact.sent, lastMessage: chatContact.lastMessage)); //TODO ÁTNÉZNI
      }
      return chats;
    });
  }

  Stream<List<Message>> getChat(String recieverId) {
    return firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').doc(recieverId).collection('Message').orderBy('sent').snapshots().map((event) {
      List<Message> messages = [];
      for(var doc in event.docs) {
        messages.add(Message.fromMap(doc.data()));
      }
      return messages;
    });
  }

  void _saveToCollection(UserM senderData, UserM recieverData, String text, DateTime sent, String receiverId) async {
    var receiverChat = ChatContact(name: senderData.name, picture: senderData.picture, id: senderData.uid, sent: sent, lastMessage:text );
    await firestore.collection('Users').doc(receiverId).collection('Chat').doc(auth.currentUser!.uid).set(receiverChat.toMap());

    var senderChat = ChatContact(name: recieverData.name, picture: recieverData.picture, id: recieverData.uid, sent: sent, lastMessage:text );
    await firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').doc(receiverId).set(senderChat.toMap());
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
  void sendPicture(BuildContext context, File file, String receiverId, UserM senderData, ProviderRef ref, MessageEnum messageEnum ) async {
    try {
      var sent = DateTime.now();
      var messageId = const Uuid().v4();

      String url = await ref.read(toStorageProvider).storeFile('Chat/${messageEnum.type}/${senderData.uid}/$receiverId/$messageId', file);

      UserM receiverData;
      var userData = await firestore.collection('Users').doc(receiverId).get();
      receiverData = UserM.fromMap(userData.data()!);

      _saveToCollection(senderData,receiverData, 'kép📷', sent, receiverId); //TODO ÁTNÉZNI
      _saveMessageToCollection(messageId, url, sent, senderData.name, receiverId, receiverData.name, messageEnum);
    } catch (e) {
      snackBar(context, e.toString());
    }
  }

  void setChatSeen (BuildContext context, String receiverId, String messageId) async {
    try {
      await firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').doc(receiverId).collection('Message').doc(messageId).update({'seen': true});
      await firestore.collection('Users').doc(receiverId).collection('Chat').doc(auth.currentUser!.uid).collection('Message').doc(messageId).update({'seen': true});
    } catch (e) {
      snackBar(context, e.toString());
    }
  }

  void deleteChatFromCollection(BuildContext context, String receiverId ) async {
    try {
      await firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').doc(receiverId).delete();
    } catch (e) {
      snackBar(context, e.toString());
    }
  }
}