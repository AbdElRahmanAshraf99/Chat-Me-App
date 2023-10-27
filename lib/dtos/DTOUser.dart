import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

@JsonSerializable()
class DTOUser {
  ImageProvider? _image;
  String? _username;
  String? _firstname;
  String? _lastname;
  String? _email;
  DateTime? _creationDate;
  List<dynamic>? _friends;
  List<DTOPrivateChatRoom>? privateChatRooms;
  List<DTOFriendRequest>? _friendRequests;
  List<DTOSentFriendRequest>? _sentFriendRequests;

  DTOUser(this._image, this._username, this._firstname, this._lastname, this._email, this._creationDate, this._friends,
      this.privateChatRooms, this._friendRequests, this._sentFriendRequests);

  factory DTOUser.fromJson(Map<String, dynamic> json) {
    return DTOUser(
      json['image'] == null ? null : Image.memory(Uint8List.fromList(base64Decode(json['image']))).image,
      json['username'],
      json['firstname'],
      json['lastname'],
      json['email'],
      json['creationDate'] != null ? DateTime.parse(json['creationDate']) : null,
      json['friends'] == null
          ? List<DTOUser>.from([])
          : List<DTOUser>.from(json['friends'].map((x) => DTOUser.fromJson(x))),
      json['privateChatRooms'] == null
          ? List<DTOPrivateChatRoom>.from([])
          : List<DTOPrivateChatRoom>.from(json['privateChatRooms'].map((x) => DTOPrivateChatRoom.fromJson(x))),
      json['friendRequests'] == null
          ? List<DTOFriendRequest>.from([])
          : List<DTOFriendRequest>.from(json['friendRequests'].map((x) => DTOFriendRequest.fromJson(x))),
      json['sentFriendRequests'] == null
          ? List<DTOSentFriendRequest>.from([])
          : List<DTOSentFriendRequest>.from(json['sentFriendRequests'].map((x) => DTOSentFriendRequest.fromJson(x))),
    );
  }

  List<DTOSentFriendRequest> get sentFriendRequests => _sentFriendRequests ?? [];

  set sentFriendRequests(List<DTOSentFriendRequest>? value) {
    _sentFriendRequests = value;
  }

  List<DTOFriendRequest> get friendRequests => _friendRequests ?? [];

  set friendRequests(List<DTOFriendRequest>? value) {
    _friendRequests = value;
  }

  ImageProvider? get image => _image;

  set image(ImageProvider? value) {
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

class DTOSentFriendRequest {
  DTOUser? toUser;

  DTOSentFriendRequest(this.toUser);

  factory DTOSentFriendRequest.fromJson(Map<String, dynamic> json) {
    return DTOSentFriendRequest(
      DTOUser.fromJson(json['toUser']),
    );
  }

  Map<String, dynamic> toJson() => {
        'toUser': toUser,
      };
}

class DTOFriendRequest {
  int? _id;
  DTOUser? _fromUser;
  DateTime? _creationDate;
  bool? _isRead;

  DTOFriendRequest(this._id,this._fromUser,this._creationDate,this._isRead);

  factory DTOFriendRequest.fromJson(Map<String, dynamic> json) {
    return DTOFriendRequest(
      json['id'],
      DTOUser.fromJson(json['fromUser']),
      json['creationDate'] != null ? DateTime.parse(json['creationDate']) : null,
      json['isRead'] != null ? json['isRead'] : false,
    );
  }

  DateTime? get creationDate => _creationDate;

  set creationDate(DateTime? value) {
    _creationDate = value;
  }

  DTOUser? get fromUser => _fromUser;

  set fromUser(DTOUser? value) {
    _fromUser = value;
  }

  bool? get isRead => _isRead;

  set isRead(bool? value) {
    _isRead = value;
  }

  int? get id => _id;

  set id(int? value) {
    _id = value;
  }
}

enum DTOChatRoomType { Private, Group }
