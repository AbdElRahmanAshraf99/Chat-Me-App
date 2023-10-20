import 'dart:convert';

import 'package:chat_me_app/services/CommonConstants.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:http/http.dart' as http;

import '../dtos/DTOUser.dart';

class UserServices {
  static String token = "";
  static Map<String, String> _requestHeaders = new Map();
  static DTOUser? currentUser;

  static Future<http.Response> registerUser(
      {required String username,
      required String firstname,
      required String lastname,
      required String password,
      String? email}) {
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['firstname'] = firstname;
    map['lastname'] = lastname;
    map['password'] = password;
    map['email'] = email;
    return http.post(Uri.parse(CommonConstants.BASE_URL + CommonConstants.ADD_USER_URL), body: map);
  }

  static Future<http.Response> login({required String username, required String password}) async {
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['password'] = password;
    var response = await http.post(Uri.parse(CommonConstants.BASE_URL + CommonConstants.LOGIN_USER_URL), body: map);
    if (response.statusCode == 200) {
      token = "Bearer " + json.decode(response.body)["token"];
      _requestHeaders['Authorization'] = token;
      await UserServices.fetchCurrentUserData();
    }
    return response;
  }

  static Future<http.Response> fetchCurrentUserData() async {
    var response =
        await http.get(Uri.parse(CommonConstants.BASE_URL + CommonConstants.FETCH_USER_DATA), headers: _requestHeaders);
    if (response.statusCode == 200) {
      currentUser = JsonMapper.deserialize<DTOUser>(response.body);
    }
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
      users = List<DTOUser>.from(l.map((user)=> JsonMapper.deserialize<DTOUser>(user)));
    }
    return users;
  }
}
