import 'package:dart_json_mapper/dart_json_mapper.dart';

@JsonSerializable()
class DTOUser {
  String? _username;
  String? _firstname;
  String? _lastname;
  String? _email;
  DateTime? _creationDate;
  List<dynamic>? _friends;
  List<DTOPrivateChatRoom>? privateChatRooms;

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
}

class DTOPrivateChatRoom {
  DTOChatRoomType? type;
}

enum DTOChatRoomType { Private, Group }
