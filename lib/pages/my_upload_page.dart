import 'package:flutter/material.dart';
class MyUploadPage extends StatefulWidget {
  const MyUploadPage({Key? key}) : super(key: key);

  @override
  _MyUploadPageState createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {

  var captionController = TextEditingController();

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
            onPressed: (){},
            icon: Icon(Icons.post_add, color: Color.fromRGBO(245,96,64, 1),)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              GestureDetector(
                // onTap: _imgFromGallery,
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.3),
                  child: Center(
                    child: Icon(Icons.add_a_photo_rounded, size: 70, color: Colors.grey.withOpacity(0.7),),
                  ),
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
    );
  }
}
