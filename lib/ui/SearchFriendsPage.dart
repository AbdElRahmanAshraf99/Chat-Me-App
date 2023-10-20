import 'package:chat_me_app/Utils.dart';
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
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
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
                      title: Text(users[index].firstname! + " " + users[index].lastname!),
                      subtitle: Text(users[index].username!),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          //TODO:: Handle Send Friend Request in Server and Mobile
                          print(users[index].username!);
                        },
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
