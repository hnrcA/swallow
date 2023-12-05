import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Screens/Chat/chat_screen.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Models/user.dart';

//region riverpod provider
final contactServiceProvider = Provider((ref) => ContactService(FirebaseFirestore.instance));
//endregion

class ContactService {
  final FirebaseFirestore firestore;

  ContactService(this.firestore);

  Future<List<Contact>> getContact() async {
    List<Contact> contacts = [];
    try {
      if(await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(BuildContext context, Contact contact) async { //Ellenőrzés hogy van e ilyen felhasználó
    try {
      var user = await firestore.collection('Users').get();
      bool found = false;
      for (var docs in user.docs) {
        UserModel userData = UserModel.fromMap(docs.data());
        String phoneNumber = contact.phones[0].number.replaceAll(' ', '');
        if(phoneNumber == userData.phone) {
          found = true;
          Navigator.popAndPushNamed(context, ChatScreen.route, arguments:{
            'uid' : userData.uid,
            'name' : userData.name,
          });
        }
      }
      if (!found) {
        snackBar(context, "Nincs ilyen felhasználó");
      }
    } catch (e) {
      snackBar(context, e.toString());
    }
  }
}