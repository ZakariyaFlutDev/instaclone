import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/model/user_model.dart';
import 'package:instaclone/pages/signin_page.dart';
import 'package:instaclone/services/data_service.dart';
import 'package:instaclone/services/utils_service.dart';

import '../services/auth_service.dart';
import '../services/prefs_service.dart';
import 'home_page.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const String id ="signup_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var pConfirmController = TextEditingController();

  bool _isLoading = false;

  _doSignUp(){
    String fullname = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cpassword = pConfirmController.text.toString().trim();

    if(fullname.isEmpty || email.isEmpty || password.isEmpty) return;

    //valid email
    if(!Utils.emailValid(email)){
      Utils.showToast("Email xato kiritildi");
      return;
    }

    //valid password
    if(!Utils.passwordValid(password)){
      Utils.showToast("Parol xato kiritildi");
      return;
    }

    //valid password and cpassword
    if(password != cpassword){
      print("Password va confirm password teng bo'lishi kerak");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    UserModel? userModel = UserModel(fullname: fullname, email: email, password: password);
    AuthService.signUp(email: email, password: password).then((value) => {
      _getUser(userModel, value),
    });
  }

  _getUser(UserModel? userModel, Map<String, User?> map) async{

    setState(() {
      _isLoading = false;
    });

    User? firebaseUser;
    if(!map.containsKey("SUCCESS")){
      if(map.containsKey("ERROR_EMAIL_ALREADY_IN_USE")){
        Utils.showToast("Email already in use");
      }
      if(map.containsKey("ERROR")) Utils.showToast("Try again Later");
      return;
    }

    firebaseUser = map["SUCCESS"];
    if(firebaseUser == null) return;

    await Prefs.saveUserId(firebaseUser.uid);
    DataService.storeUser(userModel!).then((value) => {
      Navigator.pushReplacementNamed(context, HomePage.id),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(252, 175, 69, 1),
                    Color.fromRGBO(245, 96, 64, 1),
                  ]
              )
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

                        //#phone
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            color: Colors.white54.withOpacity(0.2),
                          ),
                          child: TextField(
                            controller: fullnameController,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Fullname",
                                hintStyle: TextStyle(color: Colors.white54, fontSize: 17.0),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),

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
                            decoration: const InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white54, fontSize: 17.0),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),

                        //#confirm password
                        Container(
                          height: 50,
                          padding: EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.white54.withOpacity(0.2)
                          ),
                          child: TextField(
                            controller: pConfirmController,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: Colors.white54, fontSize: 17.0),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),

                        //#sign_up
                        GestureDetector(
                          onTap: _doSignUp,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: Colors.white54.withOpacity(0.2),width: 3),
                            ),
                            child: Center(
                              child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 20),),
                            ),

                          ),
                        )
                      ],
                    ),
                  ),

                  //#sign_in
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignInPage.id);
                        },
                        child: const Text(
                          "Sign In",
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
