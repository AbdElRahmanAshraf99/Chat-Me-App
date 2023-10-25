import 'dart:io';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

@JsonSerializable()
class DTOUser {
  File? _image;
  String? _username;
  String? _firstname;
  String? _lastname;
  String? _email;
  DateTime? _creationDate;
  List<dynamic>? _friends;
  List<DTOPrivateChatRoom>? privateChatRooms;

  DTOUser(this._image, this._username, this._firstname, this._lastname, this._email, this._creationDate, this._friends,
      this.privateChatRooms);

  factory DTOUser.fromJson(Map<String, dynamic> json) {
    return DTOUser(
      json['image'] == null ? null : createImageFileFromJson(json),
      json['username'],
      json['firstname'],
      json['lastname'],
      json['email'],
      json['creationDate'],
      json['friends'] == null
          ? List<DTOUser>.from([])
          : List<DTOUser>.from(json['friends'].map((x) => DTOUser.fromJson(x))),
      json['privateChatRooms'] == null
          ? List<DTOPrivateChatRoom>.from([])
          : List<DTOPrivateChatRoom>.from(json['privateChatRooms'].map((x) => DTOPrivateChatRoom.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        '_image': _image,
        '_username': _username,
        '_firstname': _firstname,
        '_lastname': _lastname,
        '_email': _email,
        '_creationDate': _creationDate,
        '_friends': _friends?.map((e) => e.toJson()).toList(),
        'privateChatRooms': privateChatRooms?.map((e) => e.toJson()).toList(),
      };

  File? get image => _image;

  set image(File? value) {
    _image = value;
  }

  String? get username => _username;

  set username(String? value) {
    _username = value;
  }

  String? get firstname => _firstname;

  List<dynamic> get friends => _friends ?? [];

  set friends(List<dynamic> value) {
    _friends = value;
  }

  DateTime? get creationDate => _creationDate;

  set creationDate(DateTime? value) {
    _creationDate = value;
  }

  String? get email => _email;

  set email(String? value) {
    _email = value;
  }

  String? get lastname => _lastname;

  set lastname(String? value) {
    _lastname = value;
  }

  set firstname(String? value) {
    _firstname = value;
  }

  static createImageFileFromJson(json) async {
    var imageJson = json['_image'];
    var username = json['_username'];
    final Directory directory = await getApplicationDocumentsDirectory();
    File file = await File('${directory.path}/${username + 'ProfileImage'}.jpg');
    if (await file.exists()) {
      await file.delete();
      imageCache.clear();
      file = await File('${directory.path}/${username + 'ProfileImage'}.jpg');
    }
    file = await file.writeAsBytes(imageJson);
    return file;
  }
}

class DTOPrivateChatRoom {
  DTOChatRoomType? type;

  DTOPrivateChatRoom(this.type);

  factory DTOPrivateChatRoom.fromJson(Map<String, dynamic> json) {
    return DTOPrivateChatRoom(
      DTOChatRoomType.values.where((element) => json['type'] == element).first,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.toString(),
      };
}

enum DTOChatRoomType { Private, Group }
