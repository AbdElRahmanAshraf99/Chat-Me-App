import 'package:chat_me_app/dtos/DTOUser.dart';
import 'package:chat_me_app/ui/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/UserServices.dart';
import 'FriendRequestsPage.dart';
import 'SearchFriendsPage.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  var imageProvider = UserServices.currentUser.image;
  int _selectedIndex = 0;
  TabController? _controller;
  List<Tab> tabs = [
    Tab(
      child: Row(
          children: [Icon(Icons.chat), SizedBox(width: 10), Text("Chats")],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center),
    ),
    Tab(
      child: Row(
          children: [Icon(Icons.group), SizedBox(width: 10), Text("Friends")],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    _controller!.addListener(() {
      setState(() {
        _selectedIndex = _controller!.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawer: buildDrawerWidget(),
      body: TabBarView(
        controller: _controller,
        children: [
          buildChatsWidget(),
          buildFriendsWidget(),
        ],
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      title: Text("Chat ME"),
      iconTheme: IconThemeData(color: Colors.blue),
      centerTitle: true,
      actions: _selectedIndex == 1
          ? [
              IconButton(
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FriendRequestsPage()));
                },
                icon: Icon(
                  Icons.email_rounded,
                  size: 30,
                  color: Colors.blue,
                ),
              ),
            ]
          : [],
      bottom: TabBar(
        controller: _controller,
        indicatorColor: Colors.blue,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50), // Creates border
            color: Colors.blue),
        labelColor: Colors.white,
        tabs: tabs,
      ),
    );
  }

  buildDrawerWidget() {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(UserServices.currentUser.firstname! + " " + UserServices.currentUser.lastname!),
            accountEmail: Text(UserServices.currentUser.username!),
            currentAccountPicture: CircleAvatar(
              backgroundImage: imageProvider,
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/drawer-background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())).then(
                (value) => this.setState(() {
                  imageProvider = UserServices.currentUser.image;
                }),
              );
            },
          ),
          Divider(
            indent: 30,
            endIndent: 30,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Setting"),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: Text(
              "Logout",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.remove("chat-me-username");
              pref.remove("chat-me-password");
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (r) => false);
            },
          ),
        ],
      ),
    );
  }

  buildChatsWidget() {
    return Stack(
      children: [buildChatsListView()],
    );
  }

  buildChatsListView() {
    List<String> a = ["A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B", "A", "B"];
    return ListView.builder(
        itemCount: a.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(a[index]),
          );
        });
  }

  buildFriendsWidget() {
    return ListView(
      children: [buildNewGroupTile(), buildNewFriendTile(), buildDividerTile(), buildFriendsListView()],
    );
  }

  ListView buildFriendsListView() {
    List<DTOUser> friends = UserServices.currentUser.friends;
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: friends[index].image,
              radius: 28,
            ),
            title: Text(friends[index].firstname! + " " + friends[index].lastname!),
            subtitle: Text(friends[index].username!),
            onTap: () {},
          ),
        );
      },
    );
  }

  Row buildDividerTile() {
    return Row(
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
    );
  }

  Container buildNewFriendTile() {
    return Container(
      alignment: Alignment.center,
      child: ListTile(
        visualDensity: VisualDensity(vertical: 3),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          radius: 22,
          child: Icon(Icons.person_add, size: 30),
        ),
        title: Text("New Friend"),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchFriendsPage()));
        },
      ),
    );
  }

  Container buildNewGroupTile() {
    return Container(
      alignment: Alignment.center,
      child: ListTile(
        visualDensity: VisualDensity(vertical: 3),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          radius: 22,
          child: Icon(Icons.group_add, size: 30),
        ),
        title: Text("New Group"),
        onTap: () {
          //TODO:: Handle New Group
          print("");
        },
      ),
    );
  }
}
