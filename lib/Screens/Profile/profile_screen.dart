import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Controllers/profile_controller.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Screens/Landing/landing_screen.dart';
import 'package:swallow/Screens/home_screen.dart';


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

  void pickPicture() async {
    picture = await picturePicker(context);
    setState(() {
    });
  }

  void logout() {
    ref.read(profileControllerProvider).logOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const LandingScreen()), (route) => false);
  }

  void deleteUser() {
    ref.read(profileControllerProvider).deleteUser(context);
  }

  void updateData() async {
    String username = name.text.trim();
    if (username.isNotEmpty) {
      ref.read(profileControllerProvider).saveUser(context, username, picture);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  const HomeScreen()), (route) => false);
    }
  }
  (String?,String?,String?) getPhoneNumber() {
     return ref.read(profileControllerProvider).getPhoneNumber();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var(dispname,phone,photo) = getPhoneNumber();
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
                      picture == null ?  CircleAvatar(
                        backgroundImage: NetworkImage('$photo'),
                        backgroundColor: Colors.white,
                        radius: 70,
                      ):CircleAvatar(
                        backgroundImage: FileImage(picture!),
                        radius: 70,
                      ),
                      Positioned(
                          bottom: -14,
                          left: 105,
                          child: IconButton(
                              onPressed: pickPicture,
                              icon: const Icon(Icons.add_circle_outline)))
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.all(20),
                        child:  TextFormField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: "Telefonszámod: $phone",
                              //border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(width: size.width,
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          controller: name..text = dispname!,
                          textAlign: TextAlign.center,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-ZÁáÉéÓóÚúŰű0-9 ]'))],
                          maxLength: 15,
                          decoration:const InputDecoration(
                              hintText: "Add meg az új neved"
                          ),
                        ),
                      )
                    ],
                  ),
                  TextButton(onPressed: updateData, child: const Text("Mentés")),
                  TextButton(onPressed:  deleteUser, child: const Text("Profil törlése", style: TextStyle(color: Colors.red)),),
                  TextButton(onPressed: logout, child: const Text("Kijelentkezés")),
                ],
              ),
            )
        ),
      ),
    );
  }
}

