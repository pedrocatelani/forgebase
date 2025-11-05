// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/utils/_auth_services.dart';

// ignore: must_be_immutable
class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            CustomBackground(),
            Container(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(child: Column()),
            ),
          ],
        ),
      ),
    );
  }
}
