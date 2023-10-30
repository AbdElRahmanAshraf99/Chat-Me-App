import 'package:chat_me_app/services/UserServices.dart';
import 'package:flutter/material.dart';

import '../dtos/DTOUser.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  List<DTOFriendRequest> friendRequests = UserServices.currentUser.friendRequests;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend Requests"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await UserServices.rereadFriendRequests();
          friendRequests = UserServices.currentUser.friendRequests;
          setState(() {});
        },
        child: ListView.builder(
          itemCount: friendRequests.length,
          itemBuilder: (context, index) {
            var fromUser = friendRequests[index].fromUser;
            return Container(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: ListTile(
                tileColor: Colors.white24,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {},
                leading: CircleAvatar(
                  radius: 34,
                  backgroundImage: fromUser.image,
                ),
                title: Text(fromUser.firstname! + " " + fromUser.lastname!),
                subtitle: Text(fromUser.username!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton(
                      onPressed: () async {
                        await UserServices.acceptFriendRequest(fromUser.username!);
                        friendRequests = UserServices.currentUser.friendRequests;
                        setState(() {});
                      },
                      child: Icon(Icons.check),
                      style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await UserServices.declineFriendRequest(fromUser.username!);
                        friendRequests = UserServices.currentUser.friendRequests;
                        setState(() {});
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Text(
                          String.fromCharCode(Icons.close.codePoint),
                          style: TextStyle(
                            inherit: false,
                            color: Colors.white,
                            fontSize: 26.0,
                            fontWeight: FontWeight.w800,
                            fontFamily: Icons.close.fontFamily,
                            package: Icons.close.fontPackage,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
