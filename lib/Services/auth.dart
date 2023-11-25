import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Services/storage.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Screens/Login/otp_screen.dart';
import 'package:swallow/Models/user.dart';

//region riverpod provider
final authServiceProvider = Provider((ref) => AuthService(FirebaseAuth.instance, FirebaseFirestore.instance));
//endregion

class AuthService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthService(this.auth, this.firestore);

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

  Future<void> deleteUser() async {
    try {
      await firestore.collection('Users').doc(auth.currentUser?.uid).delete();
      await auth.currentUser!.delete();
      await auth.currentUser!.reauthenticateWithProvider(PhoneAuthProvider());
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        _reAuthenticateThenDelete();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _reAuthenticateThenDelete() async {  //TODO
    try {
      await auth.currentUser!.reauthenticateWithProvider(PhoneAuthProvider());
      //await auth.currentUser!.delete();
    } catch (e) {
      print(e);
    }
  }

  void verifyCode(BuildContext context, String verificationId, String code) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
      await auth.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      var data = await firestore.collection('Users').doc(auth.currentUser!.uid).get();
      UserModel? user;
      if (data.data() != null) {
            user = UserModel.fromMap(data.data()!);
          }
      return user;
    } on TypeError catch (e) {
      return null; //This needed cause, when no one is logged in it will throw a Null check exception at the app start.
    }
  }

  void saveUser(BuildContext context, String name, File? picture, ProviderRef ref) async {
    try {
      String uid = auth.currentUser!.uid;
      String url;
      if (auth.currentUser!.photoURL != null){
        url = auth.currentUser!.photoURL!;
      } else {
        url ='https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
      }
      if(picture != null) {
        url = await ref.read(storageServiceProvider).storeFile('/Profile_pictures/$uid', picture);
      }
      var user = UserModel(uid: uid, name: name, phone: auth.currentUser!.phoneNumber.toString(), isOnline: true, picture: url);
      await auth.currentUser!.updateDisplayName(name);
      await auth.currentUser!.updatePhotoURL(url);
      await firestore.collection('Users').doc(uid).set(user.toMap());
    } catch (e) {
      snackBar(context, "Nem választottál ki képet! :)");
    }
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('Users').doc(userId).snapshots().map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserState (bool isOnline) async {
    await firestore.collection('Users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline
    });
  }
}