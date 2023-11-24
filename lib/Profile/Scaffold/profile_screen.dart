import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Landing/Scaffold/landing_screen.dart';
import 'package:swallow/Profile/controller.dart';

import '../../Common/common.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const String route='/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  File? picture;
  final TextEditingController name = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  void choosePicture() async {
    picture = await chooseImage(context);
    setState(() {
    });
  }

  void logout() {
    ref.read(controllerProvider).logOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  const LandingScreen()), (route) => false);
  }

  void updateData() async {
    String username = name.text.trim();
    if (username.isNotEmpty) {
      ref.read(controllerProvider).saveUser(context, username, picture);
    }
  }
  String? getPhoneNumber() {
     return ref.read(controllerProvider).getPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String? phone = getPhoneNumber();
    return  Scaffold(
      appBar: AppBar(
        title:const Text("Profil adatok"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      picture == null ? const CircleAvatar(
                        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                        backgroundColor: Colors.yellow,
                        radius: 70,
                      ):CircleAvatar(
                        backgroundImage: FileImage(picture!),
                        radius: 70,
                      ),
                      Positioned(
                          bottom: -14,
                          left: 105,
                          child: IconButton(
                              onPressed: choosePicture,
                              icon: const Icon(Icons.add_circle_outline)))
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.all(20),
                        child:  TextField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: phone,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(width: size.width,
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: name,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                              hintText: "Add meg az új neved" //TODO felhasználónév kijelzés
                          ),
                        ),
                      )
                    ],
                  ),
                  TextButton(onPressed: updateData, child: const Text("Mentés")),
                  TextButton(onPressed: logout, child: const Text("Kijelentkezés"))
                ],
              ),
            )
        ),
      ),
    );
  }
}

