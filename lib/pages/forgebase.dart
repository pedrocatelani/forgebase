import 'package:flutter/material.dart';
import 'package:forgebase/pages/home.dart';
import 'package:forgebase/pages/idscanner.dart';
import 'package:forgebase/pages/user.dart';

class ForgeBaseApp extends StatelessWidget {
  const ForgeBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      routes: {
        "/home": (context) => HomePage(),
        "/user": (context) => UserPage(),
        "/camera": (context) => QRScannerScreen(),
      },
      initialRoute: "/home",
      debugShowCheckedModeBanner: false,
    );
  }
}
