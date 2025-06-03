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

  final ThemeData geistoidTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF1C1B22),
    primaryColor: Color(0xFFB692F6),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFFB692F6),
      secondary: Color(0xFFFFB800),
      surface: Color(0xFF2A2930),
      onSurface: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF39364B), 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: geistoidTheme,
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
