import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../model/post_model.dart';
class MyFeedPage extends StatefulWidget {
  MyFeedPage({Key? key, required this.pageController}) : super(key: key);

  PageController pageController;

  static const String id = "my_feed_page";

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  List<Post> items = [];

  String postImg1 = "https://images7.alphacoders.com/461/461013.jpg";
  String postImg2 = "https://avatars.mds.yandex.net/i?id=64fbc395290610a625edf69848fd2a99-4451037-images-thumbs&ref=rim&n=33&w=212&h=150";
  String postImg3 = "https://jooinn.com/images/beauty-of-nature-1.jpg";

  _addPost(){
    widget.pageController.animateToPage(2,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items.add(Post(image: postImg3, caption: "Captions for test my INstagramm clone"));
    items.add(Post(image: postImg1, caption: "Captions for test my INstagramm clone"));
    items.add(Post(image: postImg2, caption: "Captions for test my INstagramm clone"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Instagram", style: TextStyle(color: Colors.black, fontFamily: 'Billabong', fontSize: 30),),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.black,),
            onPressed: (){
              _addPost();
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, i){
          return _itemOfList(items[i]);
        },
      )
    );
  }

  Widget _itemOfList(Post post){
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Divider(),

          //#userinfo
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      child: Image(
                        image: AssetImage("assets/images/ic_person.jpg"),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("UserName",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                        Text("March 19, 2022", style: TextStyle(color: Colors.black),)
                      ],
                    )
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.black, size: 35,),
                  onPressed: (){},
                )
              ],
            ),
          ),

          //#image
          CachedNetworkImage(
            width: double.infinity,
            imageUrl: post.image!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),

          // #likeshare
          Row(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.favorite_border),
                  ),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.send_rounded),
                  ),

                ],
              )
            ],
          )
        ],
      ),
    );
  }


}
