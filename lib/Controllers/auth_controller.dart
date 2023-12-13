import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Services/authService.dart';
import 'package:swallow/Models/user.dart';

//region riverpod providers
final authControllerProvider= Provider((ref) {
  final auth = ref.watch(authServiceProvider);

  return AuthController(authService: auth, ref: ref);
  });

final userAuthProvider = FutureProvider((ref) {
  final controller = ref.watch(authControllerProvider);
  return controller.getUser();
});
//endregion

class AuthController {
  final AuthService authService;
  final ProviderRef ref;

  AuthController({required this.authService, required this.ref});

  void signInWithPhone(BuildContext context, String number) {
    authService.signInWithPhone(context, number);
  }

  void verifyCode(BuildContext context, String verificationId, String code)  {
    authService.verifyCode(context, verificationId, code);
  }

  void saveUser(BuildContext context, String name, File? picture) {
    authService.saveUser(context, name, picture, ref);
  }

  Future<UserModel?> getUser () async {
    UserModel? user = await authService.getCurrentUser();
    return user;
  }

  Stream<UserModel> userdataById (String userId) {
    return authService.userData(userId);
  }
  void setUserState (bool isOnline) async {
    authService.setUserState(isOnline);
  }
}