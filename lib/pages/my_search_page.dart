import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/model/user_model.dart';
import 'package:instaclone/services/data_service.dart';

class MySearchPage extends StatefulWidget {
  const MySearchPage({Key? key}) : super(key: key);

  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  var searchController = TextEditingController();

  List<UserModel> items = [];
  bool _isLoading = false;

  _apiSearchUsers(String keyword) {
    setState(() {
      _isLoading = true;
    });
    DataService.searchUser(keyword).then((users) => {_respSearchUser(users)});
  }

  _respSearchUser(List<UserModel> users) {
    setState(() {
      items = users;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiSearchUsers("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Search",
            style: TextStyle(
                fontSize: 25, color: Colors.black, fontFamily: 'Billabong'),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  //#searchUser
                  Container(
                    height: 45,
                    padding: EdgeInsets.only(right: 10, left: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.grey.withOpacity(0.2)),
                    child: TextField(
                      onChanged: (input) {
                        print(input);
                        _apiSearchUsers(input);
                      },
                      style: TextStyle(color: Colors.black54),
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                          icon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (ctx, i) {
                        return _itemOfUser(items[i]);
                      },
                    ),
                  )
                ],
              ),
            ),
            _isLoading ?
                Center(
                  child: CircularProgressIndicator(),
                )
                : SizedBox.shrink()
          ],
        )
    );
  }

  Widget _itemOfUser(UserModel user) {
    return Container(
      height: 80,
      child: Row(
        children: [
          //#userImage
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  width: 1.5,
                  color: Color.fromRGBO(245, 96, 64, 1),
                )),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(22.5),
                child: user.img_url.isEmpty
                    ? Image(
                        image: AssetImage("assets/images/ic_person.jpg"),
                        width: 45,
                        height: 45,
                      )
                    : Image.network(
                        user.img_url,
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      )),
          ),
          SizedBox(
            width: 15,
          ),

          //#userInfos
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.fullname,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                user.email,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ],
          ),

          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(width: 1, color: Colors.grey)),
                child: Center(
                  child: Text("Follow"),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
