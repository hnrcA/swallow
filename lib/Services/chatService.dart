import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Enum/message.dart';
import 'package:swallow/Services/storageService.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Models/message.dart';
import 'package:swallow/Models/user.dart';
import 'package:swallow/Models/chat.dart';
import 'package:uuid/uuid.dart';

//region riverpod provider
final chatServiceProvider = Provider((ref) => ChatService(FirebaseFirestore.instance, FirebaseAuth.instance));
//endregion

class ChatService {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatService(this.firestore, this.auth);

  Stream<List<ChatContactModel>> getContacts() {
    return firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').snapshots().asyncMap((event) async {
      List<ChatContactModel> chats = [];
      for(var doc in event.docs) {
        var chatContact = ChatContactModel.fromMap(doc.data());
        var userData = await firestore.collection('Users').doc(chatContact.id).get();
        var user = UserModel.fromMap(userData.data()!);
        chats.add(ChatContactModel(name: user.name, picture: chatContact.picture, id: chatContact.id, sent: chatContact.sent, lastMessage: chatContact.lastMessage));
      }
      return chats;
    });
  }

  Stream<List<MessageModel>> getChat(String recieverId) {
    return firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').doc(recieverId).collection('Message').orderBy('sent').snapshots().map((event) {
      List<MessageModel> messages = [];
      for(var doc in event.docs) {
        messages.add(MessageModel.fromMap(doc.data()));
      }
      return messages;
    });
  }

  void _saveToCollection(UserModel senderData, UserModel recieverData, String text, DateTime sent, String receiverId) async {
    var receiverChat = ChatContactModel(name: senderData.name, picture: senderData.picture, id: senderData.uid, sent: sent, lastMessage:text );
    await firestore.collection('Users').doc(receiverId).collection('Chat').doc(auth.currentUser!.uid).set(receiverChat.toMap());

    var senderChat = ChatContactModel(name: recieverData.name, picture: recieverData.picture, id: recieverData.uid, sent: sent, lastMessage:text );
    await firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').doc(receiverId).set(senderChat.toMap());
  }

  void _saveMessageToCollection(String messageId, String text, DateTime sent, String username, String recieverId, String recieverUsername, MessageEnum messageType ) async {
    final message = MessageModel(senderId: auth.currentUser!.uid, receiverId: recieverId, messageId: messageId, message: text, sent: sent, seen: false, type: messageType);
    await firestore.collection('Users').doc(auth.currentUser!.uid).collection('Chat').doc(recieverId).collection('Message').doc(messageId).set(message.toMap());
    await firestore.collection('Users').doc(recieverId).collection('Chat').doc(auth.currentUser!.uid).collection('Message').doc(messageId).set(message.toMap());
  }

  void sendMessage({
    required BuildContext context,
    required String message,
    required String receiverUid,
    required UserModel senderData
  }) async {
    try {
      var sent = DateTime.now();
      UserModel recieverData;

      var userDataMap = await firestore.collection('Users').doc(receiverUid).get();
      recieverData = UserModel.fromMap(userDataMap.data()!);

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

  void sendPicture(BuildContext context, File file, String receiverId, UserModel senderData, ProviderRef ref, MessageEnum messageEnum ) async {
    try {
      var sent = DateTime.now();
      var messageId = const Uuid().v4();

      String url = await ref.read(storageServiceProvider).storeFile('Chat/${messageEnum.type}/${senderData.uid}/$receiverId/$messageId', file);

      UserModel receiverData;
      var userData = await firestore.collection('Users').doc(receiverId).get();
      receiverData = UserModel.fromMap(userData.data()!);

      if(messageEnum.type == MessageEnum.picture.type) {
        _saveToCollection(senderData,receiverData, 'Fényképes üzenet', sent, receiverId);
      } else {
        _saveToCollection(senderData,receiverData, 'Videó üzenet', sent, receiverId);
      }
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