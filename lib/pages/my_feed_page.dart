import 'package:flutter/material.dart';
class MyFeedPage extends StatefulWidget {
  const MyFeedPage({Key? key}) : super(key: key);

  static const String id = "my_feed_page";

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Feed Page"),
      ),
    );
  }
}
