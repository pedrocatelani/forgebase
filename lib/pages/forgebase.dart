import 'package:flutter/material.dart';
import 'package:forgebase/pages/deck.dart';
import 'package:forgebase/pages/edituser.dart';
import 'package:forgebase/pages/home.dart';
import 'package:forgebase/pages/idscanner.dart';
import 'package:forgebase/pages/user.dart';
import 'package:forgebase/pages/login.dart';
import 'package:forgebase/pages/register.dart';

class ForgeBaseApp extends StatelessWidget {
  const ForgeBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      routes: {
        "/home": (context) => HomePage(),
        "/deck": (context) => DeckPage(),
        "/user": (context) => UserPage(),
        "/camera": (context) => QRScannerScreen(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/edituser": (context) => EditUserPage(),
      },
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
    );
  }
}
