import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final toStorageProvider = Provider((ref) => ToStorage(FirebaseStorage.instance));

class ToStorage {
  final FirebaseStorage storage;

  ToStorage(this.storage);

  Future<String> storeFile(String ref, File file) async {
    UploadTask uploadTask = storage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }
}