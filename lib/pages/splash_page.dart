import 'dart:async';

import 'package:flutter/material.dart';

import 'home_page.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const String id = "splash_page";

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  _callHomePage(){
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _initTimer(){
    Timer(const Duration(seconds: 2), (){
      _callHomePage();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(252,175,69, 1),
              Color.fromRGBO(245,96,64, 1),
            ]
          )
        ),
        child: Column(
          children: [
            Expanded(
              child: const Center(
                child: Text("Instagram", style: TextStyle(color: Colors.white, fontSize: 52, fontFamily: 'Billabong'),),
              ),
            ),
            Text("All right reserved !", style: TextStyle(color: Colors.white, fontSize: 17),),
          ],
        )
      ),
    );
  }
}
