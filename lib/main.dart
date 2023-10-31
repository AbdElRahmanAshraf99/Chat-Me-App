import 'package:chat_me_app/main.reflectable.dart';
import 'package:chat_me_app/ui/Home.dart';
import 'package:chat_me_app/ui/login.dart';
import 'package:chat_me_app/ui/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'APIs/FirebaseAPI.dart';
import 'firebase_options.dart';
import 'services/UserServices.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAPI().initNotifications();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var username = prefs.getString("chat-me-username");
  var password = prefs.getString("chat-me-password");
  bool loginSuccessful = false;
  if (username != null && !username.isEmpty && password != null && !password.isEmpty) {
    var res = await UserServices.login(username: username, password: password);
    if (res.statusCode == 200) loginSuccessful = true;
  }
  runApp(MyApp(loginSuccessful));
}

class MyApp extends StatefulWidget {
  bool loginSuccessful;

  MyApp(this.loginSuccessful, {super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    initializeReflectable();
    return MaterialApp(
      title: 'Chat Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.latoTextTheme(
          Typography().white,
        ),
      ),
      home: widget.loginSuccessful ? HomePage() : LoginPage(),
      navigatorKey: navigatorKey,
      routes: {
        RegisterPage.route: (context) => RegisterPage(),
      },
    );
  }
}

checkUserLogin(BuildContext context, SharedPreferences prefs) {
  var username = prefs.getString("chat-me-username");
  var password = prefs.getString("chat-me-password");
  if (username == null || username.isEmpty || password == null || password.isEmpty) return LoginPage();
  UserServices.login(username: username, password: password).then((res) {});
}
