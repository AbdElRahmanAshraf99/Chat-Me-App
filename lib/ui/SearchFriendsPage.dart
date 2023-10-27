import 'package:chat_me_app/services/UserSevices.dart';
import 'package:flutter/material.dart';

import '../dtos/DTOUser.dart';

class SearchFriendsPage extends StatefulWidget {
  const SearchFriendsPage({super.key});

  @override
  State<SearchFriendsPage> createState() => _SearchFriendsPageState();
}

class _SearchFriendsPageState extends State<SearchFriendsPage> {
  TextEditingController searchController = TextEditingController();
  List<DTOUser> users = [];
  List<String?> sentFriendRequests =
      UserServices.currentUser!.sentFriendRequests.map((e) => e.toUser!.username).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      users = [];
                    });
                  }
                },
                controller: searchController,
                decoration: InputDecoration(
                    hintText: "Search By Username or Email",
                    prefixIcon: GestureDetector(
                      child: Icon(Icons.search),
                      onTap: () async {
                        if (!searchController.text.isEmpty) {
                          List<DTOUser> usersFromSearch = await UserServices.findUsers(searchController.text);
                          setState(() {
                            users = usersFromSearch;
                          });
                        }
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: users.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 22,
                              backgroundImage: users[index].image,
                              // child: Icon(Icons.person, size: 30),
                            ),
                            title: Text(users[index].firstname! + " " + users[index].lastname!),
                            subtitle: Text(users[index].username!),
                            trailing: IconButton(
                              icon: UserServices.currentUser!.sentFriendRequests
                                      .any((request) => request.toUser!.username == users[index].username!)
                                  ? Icon(Icons.delete)
                                  : Icon(Icons.add),
                              onPressed: () async {
                                if (UserServices.currentUser!.sentFriendRequests
                                    .any((request) => request.toUser!.username == users[index].username!)) {
                                  UserServices.currentUser!.sentFriendRequests
                                      .removeWhere((request) => request.toUser!.username == users[index].username!);
                                  setState(() {});
                                  await UserServices.cancelFriendRequest(users[index].username!);
                                } else {
                                  UserServices.currentUser!.sentFriendRequests.add(DTOSentFriendRequest(users[index]));
                                  setState(() {});
                                  await UserServices.sendFriendRequest(users[index].username!);
                                }
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "Sorry, No Users Found",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
