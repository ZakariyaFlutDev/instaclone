import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instaclone/model/post_model.dart';
import 'package:instaclone/services/data_service.dart';
import 'package:instaclone/services/file_service.dart';
class MyUploadPage extends StatefulWidget {
  MyUploadPage({required this.pageController, Key? key}) : super(key: key);

  PageController pageController;

  @override
  _MyUploadPageState createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {

  File? imageFile;
  bool isLoading = false;

  var captionController = TextEditingController();

  imageFromGallery() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  imageFromCamera() async {
    XFile? pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 200, maxWidth: 200);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child:  Wrap(
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
        }
    );
  }


  _upLoadNewPost(){
    String caption = captionController.text.toString().trim();
    if(caption.isEmpty) return;
    if(imageFile == null) return;

    _apiPostImage();
  }

  void _apiPostImage(){
    setState(() {
      isLoading = true;
    });
    FileService.uploadPostImage(imageFile!).then((downloadUrl) => {
      _respPostImage(downloadUrl),
    });
  }

  void _respPostImage(String downloadUrl){
    String caption = captionController.text.toString().trim();
    Post post = Post(img_post: downloadUrl, caption: caption);
    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async{
    //post to Posts
    Post posted = await DataService.storePost(post);
    //post to Feed
    DataService.storeFeed(posted).then((value) => {
      _moveToFeed(),
    });
  }

  _moveToFeed(){
    setState(() {
      isLoading = false;
    });
    captionController.text = "";
    imageFile = null;
    widget.pageController.animateToPage(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Upload", style: TextStyle(fontFamily: 'Billabong', fontSize: 32, color: Colors.black),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _upLoadNewPost,
            icon: Icon(Icons.drive_folder_upload, color: Color.fromRGBO(245,96,64, 1),)
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      _showPicker(context);
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.width,
                        color: Colors.grey.withOpacity(0.3),
                        child: imageFile == null ?
                        Center(
                          child: Icon(Icons.add_a_photo_rounded, size: 70, color: Colors.grey.withOpacity(0.7),),
                        )
                            : Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Image.file(imageFile!, fit: BoxFit.cover,),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black12,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: (){
                                      setState(() {
                                        imageFile = null;
                                      });
                                    },
                                    icon: Icon(Icons.highlight_remove, color: Colors.white,),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10, top: 10, left: 10),
                    child: TextField(
                      controller: captionController,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          hintText: "Caption",
                          hintStyle: TextStyle(color: Colors.black38, fontSize: 17.0)
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          isLoading ? Center(child: CircularProgressIndicator(),) : SizedBox.shrink(),
        ],
      )
    );
  }
}
