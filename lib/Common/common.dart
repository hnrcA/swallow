import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//For error messages
void snackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

//For picking image
Future<File?> picturePicker(BuildContext context) async {
  File? picture;
  try {
    final pickedPicture = await ImagePicker().pickImage(source: ImageSource.gallery);
    picture = File(pickedPicture!.path);
  } catch (e) {
    snackBar(context, "Nem választottál képet!");
  }
  return picture;
}

//For picking video same as image picker
Future<File?> videoPicker(BuildContext context) async {
  File? video;
  try {
    final pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);
    video = File(pickedVideo!.path);
  } catch (e) {
    snackBar(context, "Nem választottál videót!");
  }
  return video;
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
