import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/pages/home_page.dart';
import 'package:instaclone/pages/signup_page.dart';
import 'package:instaclone/services/utils_service.dart';

import '../model/user_model.dart';
import '../services/auth_service.dart';
import '../services/prefs_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  static const String id = "signin_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool _isLoading = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;

    if(!Utils.emailValid(email)){
      Utils.showToast("Email xato kiritildi");
      return;
    }

    if(!Utils.passwordValid(password)){
      Utils.showToast("Parol xato kiritildi");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    AuthService.signIn(email: email, password: password).then((value) => {
      _getFirebaseUser(value),
    });
  }

   _getFirebaseUser(Map<String, User?> map) async {
    setState(() {
      _isLoading = false;
    });

    User ? firebaseUser;

    if (!map.containsKey("SUCCESS")) {
      if (map.containsKey("ERROR"))
        Utils.showToast("Check your email or word");
      return;
    }
    firebaseUser = map["SUCCESS"];
    if (firebaseUser == null) return;

    await Prefs.saveUserId(firebaseUser.uid);
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _callSignUp(){
    Navigator.pushReplacementNamed(context, SignUpPage.id );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromRGBO(252, 175, 69, 1),
                    Color.fromRGBO(245, 96, 64, 1),
                  ])
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Instagram",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Billabong',
                              fontSize: 45),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        //#email
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white54.withOpacity(0.2)),
                          child:  TextField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle:
                                TextStyle(color: Colors.white54, fontSize: 17.0)),
                          ),
                        ),
                        SizedBox(height: 20,),

                        //#password
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white54.withOpacity(0.2)
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white54, fontSize: 17.0),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),

                        //#sign_in
                        GestureDetector(
                          onTap: _doSignIn,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: Colors.white54.withOpacity(0.2),width: 3),
                            ),
                            child: Center(
                              child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),

                          ),
                        )
                      ],
                    ),
                  ),

                  //#sign_up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: _callSignUp,
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      )
                    ],
                  )
                ],
              ),
              _isLoading ? Center(child: CircularProgressIndicator(),) : SizedBox.shrink()
            ],
          )
        ),
      )
    );
  }
}
