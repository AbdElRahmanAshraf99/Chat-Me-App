import 'dart:io' show File;

import 'package:chat_me_app/components/textField.dart';
import 'package:chat_me_app/services/UserSevices.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu_custom/focused_menu.dart';
import 'package:focused_menu_custom/modals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '../Utils.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Debouncer firstNameDebouncer = Debouncer(milliseconds: 1000);
  Debouncer lastNameDebouncer = Debouncer(milliseconds: 1000);
  Debouncer emailDebouncer = Debouncer(milliseconds: 2000);

  var oldPasswordController = new TextEditingController();
  var newPasswordController = new TextEditingController();
  var reTypeNewPasswordController = new TextEditingController();
  Widget deleteBtnChild = Text("Delete");
  ImageProvider? imageProvider = null;

  @override
  void initState() {
    super.initState();
    imageProvider = AssetImage("assets/logo.png");
    if (UserServices.currentUser!.image != null) imageProvider = FileImage(UserServices.currentUser!.image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text("Change Password"),
                  onTap: () {
                    onChangePasswordClicked();
                  },
                ),
                PopupMenuItem(
                  child: Text("Delete Account"),
                  onTap: () {
                    onDeleteAccountClicked();
                  },
                )
              ];
            },
            position: PopupMenuPosition.under,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 20),
              buildImageContainer(context),
              SizedBox(height: 40),
              buildUserNameWidget(),
              SizedBox(height: 30),
              buildFirstnameWidget(),
              SizedBox(height: 30),
              buildLastnameWidget(),
              SizedBox(height: 30),
              buildEmailWidget(),
            ],
          ),
        ),
      ),
    );
  }

  buildUserNameWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            initialValue: UserServices.currentUser!.username,
            enabled: false,
            decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                fillColor: Colors.transparent,
                labelText: "Username"),
          ),
        ),
      ],
    );
  }

  buildFirstnameWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(
            initialValue: UserServices.currentUser!.firstname,
            onChanged: (value) {
              firstNameDebouncer.run(() async {
                var response = await UserServices.editUserData("firstname", value);
                if (response != null && response.statusCode == 200) {
                  UserServices.currentUser!.firstname = value;
                }
              });
            },
            onTapOutside: (event) {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: "Firstname"),
          ),
        ),
      ],
    );
  }

  buildLastnameWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(
            initialValue: UserServices.currentUser!.lastname,
            onChanged: (value) {
              lastNameDebouncer.run(() async {
                var response = await UserServices.editUserData("lastname", value);
                if (response != null && response.statusCode == 200) {
                  UserServices.currentUser!.lastname = value;
                }
              });
            },
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: "Lastname"),
          ),
        ),
      ],
    );
  }

  buildEmailWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: TextFormField(
            initialValue: UserServices.currentUser!.email,
            onChanged: (value) {
              emailDebouncer.run(() async {
                var response = await UserServices.editUserData("email", value);
                if (response != null && response.statusCode == 200) {
                  UserServices.currentUser!.email = value;
                }
              });
            },
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: "Email"),
          ),
        ),
      ],
    );
  }

  FocusedMenuHolder buildImageContainer(BuildContext context) {
    return FocusedMenuHolder(
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
              UserServices.changeImage(null);
            });
          },
        ),
      ],
      onPressed: () {},
    );
  }

  void pickMedia(ImageSource source) async {
    XFile? file;
    file = await ImagePicker().pickImage(source: source);

    if (file != null) {
      setState(() {
        imageProvider = FileImage(File(file!.path));
      });
      await UserServices.changeImage(File(file.path));
    }
  }

  void onChangePasswordClicked() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text("Change Password"),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
              ElevatedButton(
                onPressed: () async {
                  if (oldPasswordController.text.isEmpty) {
                    UserServices.failureToast("Please Fill Old Password Field");
                    return;
                  }
                  if (newPasswordController.text.isEmpty) {
                    UserServices.failureToast("Please Fill New Password Field");
                    return;
                  }
                  if (reTypeNewPasswordController.text.isEmpty) {
                    UserServices.failureToast("Please Fill Re-Type New Password Field");
                    return;
                  }
                  if (oldPasswordController.text == newPasswordController.text) {
                    UserServices.failureToast("Old Password and New Password are equal");
                    return;
                  }
                  if (newPasswordController.text != reTypeNewPasswordController.text) {
                    UserServices.failureToast("Password and Re-Type Password are not equal");
                    return;
                  }
                  var response =
                      await UserServices.changePassword(oldPasswordController.text, newPasswordController.text);
                  if (response != null && response.statusCode == 200) Navigator.pop(context);
                },
                child: Text("Save"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: PasswordTextField(
                    controller: oldPasswordController,
                    hintText: "Old Password",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: PasswordTextField(
                    controller: newPasswordController,
                    hintText: "New Password",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: PasswordTextField(
                    controller: reTypeNewPasswordController,
                    hintText: "Re-Type New Password",
                  ),
                ),
              ],
            ),
          );
        });
  }

  void onDeleteAccountClicked() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(
              child: Text("Delete Account"),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    deleteBtnChild = SizedBox(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      width: 15,
                      height: 15,
                    );
                  });
                  if (oldPasswordController.text.isEmpty) {
                    UserServices.failureToast("Please Fill Your Password Field");
                    setState(() {
                      deleteBtnChild = Text("Delete");
                    });
                    return;
                  }
                  var response = await UserServices.deleteAccount(oldPasswordController.text);
                  if (response != null && response.statusCode == 200)
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (context) => LoginPage()), (r) => false);
                },
                child: deleteBtnChild,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: PasswordTextField(
                    controller: oldPasswordController,
                    hintText: "Password",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }
}
