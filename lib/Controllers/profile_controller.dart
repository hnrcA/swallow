import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Services/authService.dart';

//region riverpod provider
final profileControllerProvider= Provider((ref) {
  final auth = ref.watch(authServiceProvider);

  return ProfileController(authService: auth, ref: ref);
});
//endregion

class ProfileController {
  final AuthService authService;
  final ProviderRef ref;

  ProfileController({required this.authService, required this.ref});

  Future<void> logOut()  async {
    authService.setUserState(false); //set user to offline
    authService.logOut();
  }
  Future<void> deleteUser(BuildContext context) async {
      authService.deleteUser(context);
  }

  void saveUser(BuildContext context, String name, File? picture) {
    authService.saveUser(context, name, picture, ref);
  }

  (String?,String?,String?) getPhoneNumber() { //TODO ÁTNEVEZÉS
    return (authService.auth.currentUser!.displayName,
    authService.auth.currentUser!.phoneNumber,
    authService.auth.currentUser!.photoURL);
  }
}