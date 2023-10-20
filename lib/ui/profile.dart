import 'dart:io';

import 'package:chat_me_app/services/UserSevices.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu_custom/focused_menu.dart';
import 'package:focused_menu_custom/modals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '../Utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String appBarTitle = UserServices.currentUser != null
      ? UserServices.currentUser!.firstname! + " " + UserServices.currentUser!.lastname!
      : "Your Profile";
  ImageProvider<Object>? imageProvider = AssetImage("assets/login-background.jpg");

  /*null*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 20),
              FocusedMenuHolder(
                openWithTap: true,
                borderColor: Color.fromARGB(0, 0, 0, 0),
                menuWidth: MediaQuery.of(context).size.width * 0.60,
                animateMenuItems: true,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: imageProvider,
                ),
                menuItems: [
                  FocusedMenuItem(
                    backgroundColor: Colors.grey[500],
                    title: Text("View Image"),
                    trailingIcon: Icon(Icons.visibility),
                    onPressed: () {
                      if (imageProvider == null) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HeroPhotoViewRouteWrapper(
                            imageProvider: imageProvider,
                            minScale: PhotoViewComputedScale.contained,
                          ),
                        ),
                      );
                    },
                  ),
                  FocusedMenuItem(
                    backgroundColor: Colors.grey[600],
                    title: Text("Change From Camera"),
                    trailingIcon: Icon(Icons.camera_alt),
                    onPressed: () {
                      pickMedia(ImageSource.camera);
                    },
                  ),
                  FocusedMenuItem(
                    backgroundColor: Colors.grey[700],
                    title: Text("Change From Gallery"),
                    trailingIcon: Icon(Icons.image_rounded),
                    onPressed: () {
                      pickMedia(ImageSource.gallery);
                    },
                  ),
                  FocusedMenuItem(
                    backgroundColor: Colors.grey[800],
                    title: Text("Remove Image"),
                    trailingIcon: Icon(Icons.delete_forever),
                    onPressed: () {
                      if (imageProvider == null) return;
                      setState(() {
                        imageProvider = null;
                      });
                    },
                  ),
                ],
                onPressed: () {},
              ),
              SizedBox(height: 40),
              TextFormField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: "XXX",
                    hintStyle: TextStyle(color: Colors.grey[500])),
              )
            ],
          ),
        ));
  }

  void pickMedia(ImageSource source) async {
    XFile? file;
    file = await ImagePicker().pickImage(source: source);

    if (file != null) {
      setState(() {
        imageProvider = FileImage(File(file!.path));
      });
    }
  }
}
