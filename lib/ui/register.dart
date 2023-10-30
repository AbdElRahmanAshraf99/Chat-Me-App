import 'dart:ui';

import 'package:chat_me_app/services/UserServices.dart';
import 'package:chat_me_app/ui/login.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/textField.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPressed = false;
  double _sigmaX = 5; // from 0-10
  double _sigmaY = 5; // from 0-10
  double _opacity = 0.2;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 20),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Color.fromRGBO(218, 165, 32, 1),
            iconSize: 35,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Sign Up",
                      style: TextStyle(
                          color: Color.fromARGB(255, 71, 180, 133), fontSize: 40, fontWeight: FontWeight.bold)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: ClipRect(
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
                                        height: MediaQuery.of(context).size.height*0.2,
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
                                      MyTextField(
                                        controller: emailController,
                                        hintText: 'Email (Optional)',
                                        obscureText: false,
                                        required: false,
                                      ),
                                      const SizedBox(height: 10),
                                      MyTextField(
                                        controller: firstnameController,
                                        hintText: 'First Name',
                                        obscureText: false,
                                        required: true,
                                      ),
                                      const SizedBox(height: 10),
                                      MyTextField(
                                        controller: lastnameController,
                                        hintText: 'Last Name',
                                        obscureText: false,
                                        required: true,
                                      ),
                                      const SizedBox(height: 10),
                                      MyPasswordTextField(
                                        controller: passwordController,
                                        hintText: 'Password',
                                      ),
                                      const SizedBox(height: 20),
                                      MyButton(
                                        child: _isPressed
                                            ? CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : Text(
                                                "Sign Up",
                                                style: TextStyle(
                                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
                                              ),
                                        onTap: _isPressed
                                            ? null
                                            : () async {
                                                if (!_formKey.currentState!.validate()) return;
                                                setState(() {
                                                  _isPressed = true;
                                                });
                                                var res = await UserServices.registerUser(
                                                    username: usernameController.text,
                                                    firstname: firstnameController.text,
                                                    lastname: lastnameController.text,
                                                    password: passwordController.text,
                                                    email: emailController.text);
                                                if (res.statusCode == 200) {
                                                  Navigator.push(
                                                      context, MaterialPageRoute(builder: (context) => LoginPage()));
                                              } else {
                                                  setState(() {
                                                    _isPressed = false;
                                                  });
                                                }
                                              },
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                ],
              ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
