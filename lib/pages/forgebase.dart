import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/pages/deck.dart';
import 'package:forgebase/pages/edituser.dart';
import 'package:forgebase/pages/home.dart';
import 'package:forgebase/pages/idscanner.dart';
import 'package:forgebase/pages/mastervault.dart';
import 'package:forgebase/pages/user.dart';
import 'package:forgebase/pages/login.dart';
import 'package:forgebase/pages/register.dart';

class ForgeBaseApp extends StatelessWidget {
  ForgeBaseApp({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        "/mastervault": (context) => MasterVault(),
      },
      debugShowCheckedModeBanner: false,
      initialRoute: _auth.currentUser == null ? "/login" : "/home",
    );
  }
}
