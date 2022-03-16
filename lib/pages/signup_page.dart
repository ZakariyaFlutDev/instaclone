import 'package:flutter/material.dart';
import 'package:instaclone/pages/signin_page.dart';

import 'home_page.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static const String id ="signup_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var pConfirmController = TextEditingController();

  _callHomePage(){
    Navigator.pushNamed(context, HomePage.id );
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
          child: Column(
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

                    //#phone
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(right: 10, left: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: Colors.white54.withOpacity(0.2),
                      ),
                      child: TextField(
                        controller: phoneController,
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: "Phone",
                            hintStyle: TextStyle(color: Colors.white54, fontSize: 17.0),
                            border: InputBorder.none
                        ),
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
                      onTap: _callHomePage,
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
        ),
      )
    );
  }
}
