import 'package:chat_me_app/Utils.dart';
import 'package:chat_me_app/services/UserSevices.dart';
import 'package:chat_me_app/ui/SearchFriendsPage.dart';
import 'package:flutter/material.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({super.key});

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  @override
  Widget build(BuildContext context) {
    var friends = UserServices.currentUser!.friends;
    return Scaffold(
      backgroundColor: AppUtils.fetchColorFromHex("181619"),
      appBar: AppBar(
        title: Text("New Chat Room"),
        backgroundColor: AppUtils.fetchColorFromHex("181B22"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            child: ListTile(
              visualDensity: VisualDensity(vertical: 3),
              leading: CircleAvatar(
                backgroundColor: AppUtils.fetchColorFromHex("A76B09"),
                foregroundColor: AppUtils.fetchColorFromHex("272A31"),
                radius: 22,
                child: Icon(Icons.group_add, size: 30),
              ),
              title: Text("New Group"),
              onTap: () {
                //TODO:: Handle New Group
                print("");
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: ListTile(
              visualDensity: VisualDensity(vertical: 3),
              leading: CircleAvatar(
                backgroundColor: AppUtils.fetchColorFromHex("A76B09"),
                foregroundColor: AppUtils.fetchColorFromHex("272A31"),
                radius: 22,
                child: Icon(Icons.person_add, size: 30),
              ),
              title: Text("New Friend"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SearchFriendsPage()));
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Select To Chat',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: friends.length,
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppUtils.fetchColorFromHex("A76B09"),
                    foregroundColor: AppUtils.fetchColorFromHex("272A31"),
                    radius: 22,
                    child: Icon(Icons.person, size: 30),
                  ),
                  title: Text(friends[index].firstname + " " + friends[index].lastname),
                  subtitle: Text(friends[index].username),
                  onTap: () {},
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
