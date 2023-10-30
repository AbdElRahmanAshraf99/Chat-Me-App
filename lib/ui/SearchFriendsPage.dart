import 'package:chat_me_app/services/UserServices.dart';
import 'package:flutter/material.dart';

import '../dtos/DTOUser.dart';

class SearchFriendsPage extends StatefulWidget {
  const SearchFriendsPage({super.key});

  @override
  State<SearchFriendsPage> createState() => _SearchFriendsPageState();
}

class _SearchFriendsPageState extends State<SearchFriendsPage> {
  bool _isSearchPressed = false;
  TextEditingController searchController = TextEditingController();
  List<DTOUser> users = [];
  List<String?> sentFriendRequests =
      UserServices.currentUser.sentFriendRequests.map((e) => e.toUser!.username).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Friends"),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            buildSearchWidget(context),
            buildListViewWidget(),
          ],
        ),
      ),
    );
  }

  Expanded buildListViewWidget() {
    return Expanded(
      child: users.isEmpty
          ? buildEmptyUsersWidget()
          : ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                bool isSent = UserServices.currentUser.sentFriendRequests
                    .any((request) => request.toUser!.username == users[index].username!);
                return Column(
                  children: [
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundImage: users[index].image,
                        // child: Icon(Icons.person, size: 30),
                      ),
                      title: Text(users[index].firstname! + " " + users[index].lastname!),
                      subtitle: Text(users[index].username!),
                      trailing: FilledButton(
                        onPressed: () async {
                          if (isSent) {
                            UserServices.currentUser.sentFriendRequests
                                .removeWhere((request) => request.toUser!.username == users[index].username!);
                            setState(() {});
                            await UserServices.cancelFriendRequest(users[index].username!);
                          } else {
                            UserServices.currentUser.sentFriendRequests.add(DTOSentFriendRequest(users[index]));
                            setState(() {});
                            await UserServices.sendFriendRequest(users[index].username!);
                          }
                        },
                        child: isSent
                            ? Text(
                                "Cancel Request",
                                style: TextStyle(fontWeight: FontWeight.w700),
                              )
                            : Icon(Icons.add),
                        style: FilledButton.styleFrom(backgroundColor: isSent ? Colors.red : Colors.blue),
                      ),
                    ),
                    Divider(
                      indent: 30,
                      endIndent: 30,
                      thickness: 2,
                      color: Colors.blue,
                    )
                  ],
                );
              },
            ),
    );
  }

  buildEmptyUsersWidget() {
    return Center(
      child: Text(
        searchController.text.isEmpty ? "Search For Users" : "Sorry, No Users found",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic),
      ),
    );
  }

  Padding buildSearchWidget(BuildContext context) {
    return Padding(
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
        onTapOutside: (event) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20),
            hintText: "Search By Username or Email",
            suffixIcon: _isSearchPressed
                ? null
                : GestureDetector(
                    child: Icon(Icons.search),
                    onTap: _isSearchPressed ? null : () async => await onSearchClicked(context),
                  ),
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(25.0)))),
      ),
    );
  }

  Future<void> onSearchClicked(BuildContext context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (!searchController.text.isEmpty) {
      setState(() {
        _isSearchPressed = true;
      });
      List<DTOUser> usersFromSearch = await UserServices.findUsers(searchController.text);
      setState(() {
        _isSearchPressed = false;
        users = usersFromSearch;
      });
    }
  }
}
