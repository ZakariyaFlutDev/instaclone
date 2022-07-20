import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/model/user_model.dart';
import 'package:instaclone/pages/signin_page.dart';
import 'package:instaclone/services/auth_service.dart';
import 'package:instaclone/services/data_service.dart';
import 'package:instaclone/services/file_service.dart';

import '../model/post_model.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  bool _isLoading = false;
  List<Post> posts = [];
  int countPost = 0;
  File? imageFile;
  bool _isList = true;
  String fullname = "", email = "", img_url = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadUser();
    _apiLoadPosts();
  }

  void _apiLoadPosts(){
    setState(() {
      _isLoading = true;
    });
    DataService.loadPosts().then((value) => {
      _respLoadPosts(value),
    });
  }

  void _respLoadPosts(List<Post> post){
    setState(() {
      posts = post;
      _isLoading = false;
      countPost = posts.length;
    });
  }

  imageFromGallery() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    _apiChangePhoto();
  }

  imageFromCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 200, maxWidth: 200);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    _apiChangePhoto();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        imageFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _apiChangePhoto() {
    if (imageFile == null) return;

    setState(() {
      _isLoading = true;
    });

    FileService.uploadUserImage(imageFile!)
        .then((downloadUrl) => {_apiUpdateUser(downloadUrl)});
  }

  _apiUpdateUser(String downloadUrl) async {
    UserModel userModel = await DataService.loadUser();
    userModel.img_url = downloadUrl;
    await DataService.updateUser(userModel);
    _apiLoadUser();
  }

  _apiLoadUser() {
    _isLoading = true;
    DataService.loadUser().then((value) => {
          _showUserInfo(value),
        });
  }

  _showUserInfo(UserModel userModel) {
    setState(() {
      _isLoading = false;
      fullname = userModel.fullname;
      email = userModel.email;
      img_url = userModel.img_url;
    });
  }

  _signOut() {
    AuthService.signOut(context);
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Profile",
            style: TextStyle(
                fontSize: 25, color: Colors.black, fontFamily: 'Billabong'),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Color.fromRGBO(245, 96, 64, 1),
              ),
              onPressed: _signOut,
            )
          ],
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  //#myphoto
                  GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                width: 2,
                                color: Color.fromRGBO(245, 96, 64, 1),
                              )),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: img_url.isEmpty
                                  ? Image(
                                image:
                                AssetImage("assets/images/ic_person.jpg"),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                width: 70,
                                height: 70,
                                child: CachedNetworkImage(
                                  width: double.infinity,
                                  imageUrl: img_url,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              )
                          ),
                        ),
                        Container(
                          width: 83,
                          height: 83,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.add_circle,
                                color: Color.fromRGBO(245, 96, 64, 1),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //#myinfos
                  Text(
                    fullname.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    email,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                        fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //#myCount
                  Container(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${countPost}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "POSTS",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.grey,
                        ),
                        Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "2,897",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "FOLLOWERS",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.grey,
                        ),
                        Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "543",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "FOLLOWING",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                  //#isList
                  Container(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.list),
                            onPressed: () {
                              setState(() {
                                _isList = true;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: IconButton(
                            icon: Icon(Icons.grid_on_outlined),
                            onPressed: () {
                              setState(() {
                                _isList = false;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  Expanded(
                    child: GridView.builder(
                      itemCount: posts.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _isList ? 1 : 2),
                      itemBuilder: (ctx, i) {
                        return _itemOfPost(posts[i]);
                      },
                    ),
                  )
                ],
              ),
            ),

            _isLoading ? Center(child: CircularProgressIndicator(),) : SizedBox.shrink(),
          ],
        )
    );
  }

  Widget _itemOfPost(Post post) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: post.img_post,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            post.caption,
            style: TextStyle(
              color: Colors.black87.withOpacity(0.7),
            ),
            maxLines: 2,
          )
        ],
      ),
    );
  }
}
