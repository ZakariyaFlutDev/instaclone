import 'package:flutter/material.dart';
import 'package:instaclone/services/data_service.dart';

import '../model/post_model.dart';
class MyFeedPage extends StatefulWidget {
  MyFeedPage({Key? key, required this.pageController}) : super(key: key);

  PageController pageController;

  static const String id = "my_feed_page";

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {

  bool isLoading = false;
  List<Post> items = [];


  _addPost(){
    widget.pageController.animateToPage(2,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void _apiLoadFeeds(){
    setState(() {
      isLoading = true;
    });
    DataService.loadFeeds().then((result) => {
      _respLoadFeeds(result),
    });
  }

  void _respLoadFeeds(List<Post> posts){
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadFeeds();
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
            icon: Icon(Icons.camera_alt, color: Color.fromRGBO(245, 96, 64, 1),),
            onPressed: (){
              _addPost();
            },
          )
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i){
              return _itemOfList(items[i]);
            },
          ),

          isLoading ? Center(child: CircularProgressIndicator(),) : SizedBox.shrink(),
        ],
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
                        Text(post.fullname.toString(),style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                        Text(post.date.toString(), style: TextStyle(color: Colors.black),)
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
          Image.network(
            post.img_post,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
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
                    icon: Icon(Icons.share_outlined),
                  ),

                ],
              )
            ],
          ),

          //#caption
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                  children: [
                    TextSpan(text: "${post.caption}", style: TextStyle(color:Colors.black)),
                  ]
              ),
            ),
          )
        ],
      ),
    );
  }


}
