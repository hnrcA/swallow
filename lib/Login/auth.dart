import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/Firebase/storage.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Login/Scaffold/login_screen.dart';
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
      //TODO Avatar change
      String uid = auth.currentUser!.uid;
      String url = 'https://img.freepik.com/premium-vector/man-character_665280-46970.jpg';
      url = await ref.read(toStorageProvider).storeFile('/Profile_pictures/$uid', picture!);
      var user = UserM(uid: uid, name: name, phone: auth.currentUser!.phoneNumber.toString(), picture: url);
      await firestore.collection('Users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MobileLayout(),), (route) => false);
    } catch (e) {
      snackBar(context, e.toString());
      print(e);
    }
  }

}