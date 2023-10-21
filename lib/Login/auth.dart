import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Login/Scaffold/otp_screen.dart';
import 'package:swallow/Login/Scaffold/user_screen.dart';

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
          throw Exception(e.message);
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
}