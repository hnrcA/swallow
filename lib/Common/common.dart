import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void snackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  //TODO MaterialBanner?
}

Future<File?> chooseImage(BuildContext context) async {
  File? picture;
  try {
    final choosedPicture = await ImagePicker().pickImage(source: ImageSource.gallery);
    picture = File(choosedPicture!.path);
  } catch (e) {
    snackBar(context, e.toString());
  }
  return picture;
}

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
