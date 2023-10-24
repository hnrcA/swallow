import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swallow/Common/common.dart';
import 'package:swallow/Login/auth.dart';
import 'package:swallow/Login/controller.dart';

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

  void choosePicture() async {
    picture = await chooseImage(context);
    setState(() {
    });
  }

  void saveUserData() async {
    String Name = name.text.trim();
    if (Name.isNotEmpty) {
      ref.read(controllerProvider).saveUser(context, Name, picture);
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
                      backgroundImage: NetworkImage('https://img.freepik.com/premium-vector/man-character_665280-46970.jpg'),
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
                      width: size.width * 0.85,
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        controller: name,
                        decoration: const InputDecoration(
                          hintText: "Add meg a neved" //TODO születési dátum ?
                        ),
                      ),
                    ),
                    IconButton(onPressed: saveUserData, icon: Icon(Icons.done_outline))
                  ],
                )
              ],
            ),
          )
      ),
    );
  }
}
