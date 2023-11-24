import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Firebase/storage.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Login/Scaffold/otp_screen.dart';
import 'package:swallow/Login/Scaffold/user_screen.dart';
import 'package:swallow/Model/user.dart';

import '../Common/Layouts/mobile_layout.dart';

final authProvider = Provider((ref) => Auth(FirebaseAuth.instance, FirebaseFirestore.instance));

class Auth {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  Auth(this.auth, this.firestore);

  void signInWithPhone(BuildContext context, String number) async {
      await auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          snackBar(context, e.toString());
        },
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.pushNamed(context, OtpScreen.route, arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
  }

  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  //TODO  CATCH
  void verifyCode(BuildContext context, String verificationId, String code) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
    await auth.signInWithCredential(credential);
    Navigator.pushNamedAndRemoveUntil(context, UserScreen.route, (route) => false);
  }

  Future<UserM?> getCurrentUser() async {
    var data = await firestore.collection('Users').doc(auth.currentUser?.uid).get();
    UserM? user;
    if (data.data() != null) {
      user = UserM.fromMap(data.data()!);
    }
    return user;
  }

  void savePicture (BuildContext context, String name, File? picture, ProviderRef ref) async {
    try {
      String uid = auth.currentUser!.uid;
      String url = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
      if(picture != null) {
        url = await ref.read(toStorageProvider).storeFile('/Profile_pictures/$uid', picture);
      }
      var user = UserM(uid: uid, name: name, phone: auth.currentUser!.phoneNumber.toString(), isOnline: true, picture: url);
      await firestore.collection('Users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  MobileLayout()), (route) => false);
    } catch (e) {
      snackBar(context, "Nem választottál ki képet! :)"); //TODO ne hagyd itt
    }
  }

  Stream<UserM> userData(String userId) {
    return firestore.collection('Users').doc(userId).snapshots().map((event) => UserM.fromMap(event.data()!));
  }

  void setUserState (bool isOnline) async {
    await firestore.collection('Users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline
    });
  }
}