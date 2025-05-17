import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/password_field.dart';
import 'package:forgebase/utils/_auth_services.dart';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  var txtName = TextEditingController();
  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();
  var txtConfirmPassword = TextEditingController();
  var txtAPIKey = TextEditingController();

  final AuthService _authService = AuthService();

  Future<void> _register(BuildContext context) async {
    try {
      final user = await _authService.register(
        txtName.text,
        txtEmail.text,
        txtPassword.text,
        txtConfirmPassword.text,
      );
      
      if (user != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/home");
      }
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (ex) {
      final snackBar = SnackBar(content: Text("Error"));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomBackground(),
          Container(
            margin: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 25,
              children: [
                Image.asset('assets/ForgeBase.png', width: 300, height: 250),
                TextField(
                  controller: txtName,
                  decoration: InputDecoration(
                    hintText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                TextField(
                  controller: txtEmail,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                PasswordField(
                  controller: txtPassword,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                PasswordField(
                  controller: txtConfirmPassword,
                  decoration: InputDecoration(
                    hintText: "Confirm password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                PasswordField(
                  controller: txtAPIKey,
                  decoration: InputDecoration(
                    hintText: "API Key",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _register(context),
                  child: Text("Register"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
