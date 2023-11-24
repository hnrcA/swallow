import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Login/auth.dart';


final controllerProvider= Provider((ref) {
  final auth = ref.watch(authProvider);

  return Controller(auth: auth, ref: ref);
});

class Controller {
  final Auth auth;
  final ProviderRef ref;

  Controller({required this.auth, required this.ref});

  Future<void> logOut() async {
    auth.setUserState(false);
    auth.logOut();
  }

  void saveUser(BuildContext context, String name, File? picture) {  //profile picture save
    auth.savePicture(context, name, picture, ref);
  }


  String? getPhoneNumber() {
    return auth.auth.currentUser!.phoneNumber;
  }
}