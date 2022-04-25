import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:instaclone/services/prefs_service.dart';

class FileService{
  static final _storage = FirebaseStorage.instance.ref();
  static const folder_post = "post_images";
  static const folder_user = "user_images";

  static Future<String> uploadUserImage(File image) async{
    String? uid = await Prefs.loadUserId();
    String? img_name = uid;
    Reference reference = _storage.child(folder_user).child(img_name!);
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {
      print("Task snaopshot ishladi"),
    });
    if(taskSnapshot != null){
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    }

    return "null";
  }

  static Future<String> uploadPostImage(File image) async{
    String? uid = await Prefs.loadUserId();
    String? img_name = uid! + "_" + DateTime.now().toString();
    Reference reference = _storage.child(folder_user).child(img_name);
    UploadTask uploadTask = reference.putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    if(taskSnapshot != null){
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    }

    return "null";
  }
}