import 'dart:io';

import 'package:flutter/cupertino.dart';
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

  void signInWithPhone(BuildContext context, String number) {
    auth.signInWithPhone(context, number);
  }

  void verifyCode(BuildContext context, String verificationId, String code)  {
    auth.verifyCode(context, verificationId, code);
  }

  void saveUser(BuildContext context, String name, File? picture) {
    auth.savePicture(context, name, picture, ref);
  }
}