import 'dart:ui';

import 'package:chat_me_app/services/UserSevices.dart';
import 'package:chat_me_app/ui/Home.dart';
import 'package:chat_me_app/ui/register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../components/button.dart';
import '../components/textField.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  double _sigmaX = 5; // from 0-10
  double _sigmaY = 5; // from 0-10
  double _opacity = 0.2;
  double _width = 350;
  double _height = 300;
  final _formKey = GlobalKey<FormState>();

  // sign user in method
  void signUserIn() {
    if (_formKey.currentState!.validate()) {
      print('valid');
    } else {
      print('not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/login-background.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.cover,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                    const Text("Sign In",
                        style: TextStyle(
                            color: Color.fromARGB(255, 71, 180, 133), fontSize: 40, fontWeight: FontWeight.bold)),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 1).withOpacity(_opacity),
                              borderRadius: BorderRadius.all(Radius.circular(30))),
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Form(
                            key: _formKey,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                      child: Image.asset(
                                    "assets/logoInsideScreens.png",
                                    fit: BoxFit.contain,
                                    height: MediaQuery.of(context).size.height * 0.2,
                                    width: MediaQuery.of(context).size.width * 0.7,
                                  )),
                                  const SizedBox(height: 20),
                                  MyTextField(
                                    controller: usernameController,
                                    hintText: 'Username',
                                    obscureText: false,
                                    required: true,
                                  ),
                                  const SizedBox(height: 10),
                                  MyPasswordTextField(
                                    controller: passwordController,
                                    hintText: 'Password',
                                  ),
                                  const SizedBox(height: 10),
                                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                    InkWell(
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                            color: Color.fromARGB(255, 71, 233, 133),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      onTap: () {
                                        //TODO:: Handle Forget Password
                                        print("Forgot Clicked");
                                      },
                                    ),
                                  ]),
                                  const SizedBox(height: 10),
                                  MyButton(
                                    text: "Log In",
                                    onTap: (() async {
                                      if (_formKey.currentState!.validate()) {
                                        var res = await UserServices.login(
                                            username: usernameController.text, password: passwordController.text);
                                        if (res.statusCode == 200)
                                          Navigator.pushAndRemoveUntil(context,
                                              MaterialPageRoute(builder: (context) => HomePage()), (r) => false);
                                      }
                                    }),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Don\'t have an account?',
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                        textAlign: TextAlign.start,
                                      ),
                                      const SizedBox(width: 4),
                                      InkWell(
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                              color: Color.fromARGB(255, 71, 233, 133),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context, MaterialPageRoute(builder: (context) => RegisterPage()));
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
