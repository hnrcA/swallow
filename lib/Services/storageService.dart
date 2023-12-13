import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//region riverpod provider
final storageServiceProvider = Provider((ref) => StorageService(FirebaseStorage.instance));
//endregion

class StorageService {
  final FirebaseStorage storage;

  StorageService(this.storage);

  Future<String> storeFile(String ref, File file) async {
      UploadTask uploadTask = storage.ref().child(ref).putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String url = await snapshot.ref.getDownloadURL();
      return url;
  }
}