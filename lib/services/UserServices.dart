import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:chat_me_app/Utils.dart';
import 'package:chat_me_app/services/CommonConstants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../dtos/DTOUser.dart';

class UserServices {
  static String token = "";
  static Map<String, String> _requestHeaders = new Map();
  static DTOUser currentUser = new DTOUser.emptyInstance();

  static Future<http.Response> registerUser(
      {required String username,
      required String firstname,
      required String lastname,
      required String password,
      String? email}) async {
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['password'] = password;
    map['email'] = email;
    var response = await http.post(Uri.parse(CommonConstants.BASE_URL + CommonConstants.ADD_USER_URL), body: map);
    toastResponseMsg(response);
    return response;
  }

  static Future<http.Response> login({required String username, required String password}) async {
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['password'] = password;
    var response = await http.post(Uri.parse(CommonConstants.BASE_URL + CommonConstants.LOGIN_USER_URL), body: map);
    if (response.statusCode == 200) {
      token = "Bearer " + json.decode(response.body)["token"];
      currentUser = DTOUser.fromJson(json.decode(response.body)["user"]);
      _requestHeaders['Authorization'] = token;
    } else {
      failureToast(response.body);
    }
    return response;
  }

  static Future<http.Response> fetchCurrentUserData() async {
    var response =
        await http.get(Uri.parse(CommonConstants.BASE_URL + CommonConstants.FETCH_USER_DATA), headers: _requestHeaders);
    if (response.statusCode == 200) currentUser = DTOUser.fromJson(json.decode(response.body));
    return response;
  }

  static Future<List<DTOUser>> findUsers(String value) async {
    var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.FIND_USERS);
    var map = new Map<String, dynamic>();
    map['usernameOrEmail'] = value;
    final newURI = url.replace(queryParameters: map);
    var response = await http.get(newURI, headers: _requestHeaders);
    List<DTOUser> users = [];
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      users = List<DTOUser>.from(l.map((user)=> DTOUser.fromJson(user)));
    }
    return users;
  }

  static Future<void> changeImage(File? file) async {
    if (file == null) {
      var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.REMOVE_IMAGE);
      var response = await http.post(url, headers: _requestHeaders);
      currentUser.image = null;
      toastResponseMsg(response);
      return;
    }
    var bytes = await file.readAsBytes();
    var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.SAVE_IMAGE);
    http.MultipartRequest request = new http.MultipartRequest("post", url);
    request.headers.addAll(_requestHeaders);
    request.files.add(new http.MultipartFile.fromBytes("image", bytes,
        /*ParamName*/ filename: "image", contentType: new MediaType('image', '*')));
    var response = await request.send();
    var msg = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      currentUser!.image = Image.memory(Uint8List.fromList(bytes)).image;
      successToast(msg);
    } else {
      failureToast(msg);
    }
  }

  static void failureToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void successToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static void toastResponseMsg(Response response) {
    if (response.statusCode == 200) {
      successToast(response.body.toString());
    } else {
      failureToast(response.body.toString().isEmpty ? response.statusCode.toString() : response.body.toString());
    }
  }

  static Future<Response?>? editUserData(String key, String value) async {
    if (!changesExists(key, value)) return null;
    var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.UPDATE_USER);
    Map<String, String> body = new Map();
    body[key] = value;
    var response = await http.patch(url, headers: _requestHeaders, body: body);
    if (response.statusCode != 200)
      failureToast(response.body);
    else
      successToast(StringEditor.capitalize(key) + " updated Successfully");
    return response;
  }

  static bool changesExists(String key, String value) {
    switch (key) {
      case "firstname":
        return value != currentUser.firstname;
      case "lastname":
        return value != currentUser.lastname;
      case "email":
        return value != currentUser.email;
    }
    return true;
  }

  static Future<Response?>? changePassword(String oldPassword, String newPassword) async {
    var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.CHANGE_PASSWORD);
    Map<String, String> body = new Map();
    body["oldPassword"] = oldPassword;
    body["newPassword"] = newPassword;
    var response = await http.patch(url, headers: _requestHeaders, body: body);
    toastResponseMsg(response);
    return response;
  }

  static Future<Response?>? deleteAccount(String password) async {
    var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.DELETE_ACCOUNT);
    Map<String, String> body = new Map();
    body["password"] = password;
    var response = await http.delete(url, headers: _requestHeaders, body: body);
    toastResponseMsg(response);
    return response;
  }

  static Future<Response?>? sendFriendRequest(String username) async {
    var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.SEND_FRIEND_REQUEST);
    Map<String, String> body = new Map();
    body["friendUsername"] = username;
    var response = await http.post(url, headers: _requestHeaders, body: body);
    toastResponseMsg(response);
    return response;
  }

  static Future<Response?>? cancelFriendRequest(String username) async {
    var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.CANCEL_FRIEND_REQUEST);
    Map<String, String> body = new Map();
    body["friendUsername"] = username;
    var response = await http.post(url, headers: _requestHeaders, body: body);
    toastResponseMsg(response);
    return response;
  }

  static rereadFriendRequests() async {
    var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.READ_FRIEND_REQUESTS);
    var response = await http.get(url, headers: _requestHeaders);
    if (response.statusCode == 200) {
      Iterable l = json.decode(response.body);
      currentUser.friendRequests = List<DTOFriendRequest>.from(l.map((request) => DTOFriendRequest.fromJson(request)));
    }
    return response;
  }

  static acceptFriendRequest(String username) async {
    var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.ACCEPT_FRIEND_REQUESTS);
    Map<String, String> body = new Map();
    body["friendUsername"] = username;
    var response = await http.post(url, headers: _requestHeaders, body: body);
    toastResponseMsg(response);
    await rereadFriendRequests();
    return response;
  }

  static declineFriendRequest(String username) async {
    var url = Uri.parse(CommonConstants.BASE_URL + CommonConstants.DECLINE_FRIEND_REQUESTS);
    Map<String, String> body = new Map();
    body["friendUsername"] = username;
    var response = await http.post(url, headers: _requestHeaders, body: body);
    toastResponseMsg(response);
    await rereadFriendRequests();
    return response;
  }
}
