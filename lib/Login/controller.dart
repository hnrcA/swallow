import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Login/auth.dart';

final controllerProvider= Provider((ref) {
  final auth = ref.watch(authProvider);
  return Controller(auth: auth);
  });

class Controller {
  final Auth auth;

  Controller({required this.auth});

  void signInWithPhone(BuildContext context, String number) {
    auth.signInWithPhone(context, number);
  }

  void verifyCode(BuildContext context, String verificationId, String code)  {
    auth.verifyCode(context, verificationId, code);
  }
}