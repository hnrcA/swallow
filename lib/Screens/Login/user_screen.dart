import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Controllers/auth_controller.dart';

import '../home_screen.dart';

class UserScreen extends ConsumerStatefulWidget {
  static const String route='/user';
  const UserScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
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

  void saveUserData() async {
    String Name = name.text.trim();
    if (Name.isNotEmpty) {
      ref.read(authControllerProvider).saveUser(context, Name, picture);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Scaffold(
      body: SafeArea(
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
                            onPressed: pickPicture,
                            icon: const Icon(Icons.add_circle_outline)))
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.85,
                      padding: const EdgeInsets.all(20),
                      child: TextFormField(
                        controller: name,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-ZÁáÉéÓóÚúŰű0-9 ]'))],
                        maxLength: 15,
                        decoration: const InputDecoration(
                          hintText: "Add meg a neved"
                        ),
                      ),
                    ),
                    IconButton(onPressed: saveUserData, icon: const Icon(Icons.done_outline))
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
