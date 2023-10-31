import 'package:chat_me_app/main.reflectable.dart';
import 'package:chat_me_app/ui/login.dart';
import 'package:chat_me_app/ui/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'APIs/FirebaseAPI.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAPI().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Me',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.latoTextTheme(
          Typography().white,
        ),
      ),
      home: checkUserLogin(),
      navigatorKey: navigatorKey,
      routes: {
        RegisterPage.route: (context) => RegisterPage(),
      },
    );
  }

  checkUserLogin() {
    //TODO:: Check User Cache Memory If User Login => To Home else => To Login Page
    initializeReflectable();
    return LoginPage();
  }
}
