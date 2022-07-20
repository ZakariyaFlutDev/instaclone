import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instaclone/model/post_model.dart';
import 'package:instaclone/model/user_model.dart';
import 'package:instaclone/services/prefs_service.dart';
import 'package:instaclone/services/utils_service.dart';

class DataService{
  
  static final _fireStore = FirebaseFirestore.instance;
  
  static String folder_users = "users";
  static String folder_feeds = "feeds";
  static String folder_posts = "posts";

  //User Releated
  
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

  //Post Releated

  static Future<Post> storePost(Post post) async{
    UserModel me = await loadUser();
    post.uid = me.uid;
    post.fullname = me.fullname;
    post.img_user = me.img_url;
    post.date = Utils.currentDate();

    String postId = _fireStore.collection(folder_users).doc(me.uid).collection(folder_posts).doc().id;
    post.id = postId;

    await _fireStore.collection(folder_users).doc(me.uid).collection(folder_posts).doc(postId).set(post.toJson());
    return post;
  }

  //Feed Releated

  static Future<Post> storeFeed(Post post) async{
    String? uid = await Prefs.loadUserId();

    await _fireStore.collection(folder_users).doc(uid).collection(folder_feeds).doc(post.id).set(post.toJson());
    return post;
  }

  //Load Feeds
  static Future<List<Post>> loadFeeds() async{
    List<Post> posts = [];
    String? uid = await Prefs.loadUserId();
    var querySnapshot = await _fireStore.collection(folder_users).doc(uid).collection(folder_feeds).get();

    querySnapshot.docs.forEach((result) {
      Post post = Post.fromJson(result.data());
      posts.add(post);
    });
    return posts;
  }

  //Load Posts
  static Future<List<Post>> loadPosts() async{
    List<Post> posts = [];
    String? uid = await Prefs.loadUserId();
    var querySnapshot = await _fireStore.collection(folder_users).doc(uid).collection(folder_posts).get();

    querySnapshot.docs.forEach((result) {
      Post post = Post.fromJson(result.data());
      posts.add(post);
    });
    return posts;
  }



}