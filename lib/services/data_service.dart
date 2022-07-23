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
  static String folder_following = "following";
  static String folder_followers = "followers";

  //User Releated
  
  static Future storeUser(UserModel user) async{
    user.uid = (await Prefs.loadUserId())!;
    return _fireStore.collection(folder_users).doc(user.uid).set(user.toJson());
  }

  static Future<UserModel> loadUser() async{
    String ? uid = await Prefs.loadUserId();
    var value = await _fireStore.collection(folder_users).doc(uid).get();
    UserModel user =  UserModel.fromJson(value.data()!);

    var querySnapshot1 = await _fireStore.collection(folder_users).doc(uid).collection(folder_following).get();
    user.following_count = querySnapshot1.docs.length;

    var querySnapshot2 = await _fireStore.collection(folder_users).doc(uid).collection(folder_followers).get();
    user.followers_count = querySnapshot2.docs.length;

    return user;
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

    List<UserModel> following = [];

    var querySnapshot2 = await _fireStore.collection(folder_users).doc(uid).collection(folder_following).get();
    querySnapshot2.docs.forEach((result) {
      following.add(UserModel.fromJson(result.data()));
    });

    for(UserModel user in users){
      if(following.contains(user)){
        user.followed = true;
      }else{
        user.followed = false;
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

  // like - unlike
  static Future<Post> likePost(Post post, bool liked) async {
    String? uid = await Prefs.loadUserId();
    post.liked = liked;

    await _fireStore.collection(folder_users).doc(uid).collection(folder_feeds).doc(post.id).set(post.toJson());

    if(uid == post.uid){
      await _fireStore.collection(folder_users).doc(uid).collection(folder_posts).doc(post.id).set(post.toJson());
    }
    return post;
  }
  static Future<List<Post>> loadLikes() async {
    String? uid = await Prefs.loadUserId();
    List<Post> posts = [];

    var querySnapshot = await _fireStore.collection(folder_users).doc(uid).collection(folder_feeds).where("liked", isEqualTo: true).get();

    querySnapshot.docs.forEach((result) {
      Post post = Post.fromJson(result.data());
      posts.add(post);
    });
    return posts;
  }

  // Follower and Following Related

  static Future<UserModel> followUser(UserModel someone) async {
    UserModel me = await loadUser();

    // I followed to someone
    await _fireStore.collection(folder_users).doc(me.uid).collection(folder_following).doc(someone.uid).set(someone.toJson());

    // I am in someone`s followers
    await _fireStore.collection(folder_users).doc(someone.uid).collection(folder_followers).doc(me.uid).set(me.toJson());

    return someone;
  }

  static Future<UserModel> unfollowUser(UserModel someone) async {
    UserModel me = await loadUser();

    // I unfollowed to someone
    await _fireStore.collection(folder_users).doc(me.uid).collection(folder_following).doc(someone.uid).delete();

    // I am not in someone`s followers
    await _fireStore.collection(folder_users).doc(someone.uid).collection(folder_followers).doc(me.uid).delete();

    return someone;
  }

  static Future storePostsToMyFeed(UserModel someone) async{
    // Store someone`s posts to my feed

    List<Post> posts = [];
    var querySnapshot = await _fireStore.collection(folder_users).doc(someone.uid).collection(folder_posts).get();
    querySnapshot.docs.forEach((result) {
      var post = Post.fromJson(result.data());
      post.liked = false;
      posts.add(post);
    });

    for(Post post in posts){
      storeFeed(post);
    }
  }

  static Future removePostsFromMyFeed(UserModel someone) async{
    // Remove someone`s posts from my feed

    List<Post> posts = [];
    var querySnapshot = await _fireStore.collection(folder_users).doc(someone.uid).collection(folder_posts).get();
    querySnapshot.docs.forEach((result) {
      posts.add(Post.fromJson(result.data()));
    });

    for(Post post in posts){
      removeFeed(post);
    }
  }
  static Future removeFeed(Post post) async{
    String? uid = await Prefs.loadUserId();

    return await _fireStore.collection(folder_users).doc(uid).collection(folder_feeds).doc(post.id).delete();
  }

  static Future removePost(Post post) async{
    String? uid = await Prefs.loadUserId();
    await removeFeed(post);
    return await _fireStore.collection(folder_users).doc(uid)
        .collection(folder_posts).doc(post.id).delete();
  }

}