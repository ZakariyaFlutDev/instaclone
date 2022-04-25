import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/my_feed_page.dart';
import 'package:instaclone/pages/my_likes_page.dart';
import 'package:instaclone/pages/my_profile_page.dart';
import 'package:instaclone/pages/my_search_page.dart';
import 'package:instaclone/pages/my_upload_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController _pageController = PageController();
  late int selectedPage = 0;

  @override
  void initState() {
     // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index){
          setState(() {
            selectedPage = index;
          });
        },
        children: [
          MyFeedPage(pageController: _pageController,),
          MySearchPage(),
          MyUploadPage(pageController: _pageController,),
          MyLikePage(),
          MyProfilePage(),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: selectedPage,
        activeColor: Color.fromRGBO(245, 96, 64, 1),
        onTap: (int index){
          setState(() {
            selectedPage = index;
            _pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
          ),

        ],

      ),
    );
  }
}
