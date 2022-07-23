import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/services/data_service.dart';

import '../model/post_model.dart';
class MyLikePage extends StatefulWidget {
  const MyLikePage({Key? key}) : super(key: key);

  @override
  _MyLikePageState createState() => _MyLikePageState();
}

class _MyLikePageState extends State<MyLikePage> {
  List<Post> items = [];
  bool isLoading = false;

  _apiLoadLikes(){
    setState(() {
      isLoading = true;
    });
    DataService.loadLikes().then((value) => {
      _respLoadLikes(value),
    });
  }

  _respLoadLikes(List<Post> likePosts){
    setState(() {
      items = likePosts;
      isLoading = false;
    });
  }

  void _apiPostUnlike(Post post) async{
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, false);
    _apiLoadLikes();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Likes", style: TextStyle(color: Colors.black, fontFamily: 'Billabong', fontSize: 30),),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.camera_alt, color: Colors.black,),
              onPressed: (){},
            )
          ],
        ),
        body: Stack(
          children: [
            items.length > 0 ? ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i){
                return _itemOfList(items[i]);
              },
            ) : Center(child: Text("Likes Posts No"),),
            isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
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
                        borderRadius: BorderRadius.circular(22.5),
                        child: post.img_user!.isEmpty ? const Image(
                          image: AssetImage(
                              "assets/images/ic_person.png"),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          post.img_user!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )

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
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            imageUrl: post.img_post,
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
                    onPressed: (){
                      if(post.liked){
                        _apiPostUnlike(post);
                      }
                    },
                    icon: Icon(Icons.favorite, color: Colors.red,),
                  ),
                  IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.share_outlined),
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
