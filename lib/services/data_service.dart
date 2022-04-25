import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/model/user_model.dart';
import 'package:instaclone/services/prefs_service.dart';

class DataService{
  
  static final _fireStore = FirebaseFirestore.instance;
  
  static String folder_users = "users";
  
  static Future storeUser(UserModel user) async{
    user.uid = (await Prefs.loadUserId())!;
    return _fireStore.collection(folder_users).doc(user.uid).set(user.toJson());
  }

  static Future<UserModel> loadUser() async{
    String ? uid = await Prefs.loadUserId();
    var value = await _fireStore.collection(folder_users).doc(uid).get();
    return UserModel.fromJson(value.data()!);
  }

  static Future updateUser(UserModel user) async{
    String? uid = await Prefs.loadUserId();
    return _fireStore.collection(folder_users).doc(uid).update(user.toJson());
  }

  static Future<List<UserModel>> searchUser(String keyword) async{
    String? uid = await Prefs.loadUserId();
    List<UserModel> users = [];
    final instance = FirebaseFirestore.instance;
    var querySnapshot = await instance.collection(folder_users).orderBy("fullname").startAt([keyword]).get();

    for (var result in querySnapshot.docs) {
      UserModel newUser = UserModel.fromJson(result.data());
      if(newUser.uid != uid){
        users.add(newUser);
      }
    }
    return users;
  }



}