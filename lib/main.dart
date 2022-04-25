import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/home_page.dart';
import 'package:instaclone/pages/signin_page.dart';
import 'package:instaclone/pages/signup_page.dart';
import 'package:instaclone/pages/splash_page.dart';
import 'package:instaclone/services/prefs_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Widget _callstartPage(){
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot){
          if(snapshot.hasData){
            Prefs.saveUserId(snapshot.data!.uid);
            return SplashPage();
          }else{
            Prefs.removeUserId();
            return SignInPage();
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _callstartPage(),
      routes: {
        SplashPage.id:(context) => SplashPage(),
        SignInPage.id:(context) => SignInPage(),
        SignUpPage.id:(context) => SignUpPage(),
        HomePage.id:(context) => HomePage(),
      },
    );
  }
}
