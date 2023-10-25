import 'dart:io';

import 'package:chat_me_app/services/UserSevices.dart';
import 'package:chat_me_app/ui/login.dart';
import 'package:chat_me_app/ui/newChatPage.dart';
import 'package:chat_me_app/ui/profile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ImageProvider? fileImage = AssetImage("assets/logo.png");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mostafa El Baiiiiiiih"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(UserServices.currentUser!.firstname! + " " + UserServices.currentUser!.lastname!),
              accountEmail: Text(UserServices.currentUser!.username!),
              currentAccountPicture: CircleAvatar(
                backgroundImage: UserServices.currentUser!.image == null ? fileImage : FileImage(
                    UserServices.currentUser!.image!),
              ),
              decoration: BoxDecoration(
                // color: Color.fromRGBO(36, 65, 91, 1.0),
                image: DecorationImage(
                  image: AssetImage("assets/drawer-background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(builder: (context) => LoginPage()), (r) => false);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewChatPage()));
        },
        backgroundColor: Color.fromARGB(255, 71, 233, 133),
        foregroundColor: Colors.blueAccent,
        child: Icon(
          Icons.add_comment_outlined,
          size: 40,
        ),
      ),
      body: Center(
        child: Text(UserServices.token),
      ),
    );
  }
}
