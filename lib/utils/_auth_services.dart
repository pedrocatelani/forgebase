import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/utils/_firebase_collections.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseColletion _database = FirebaseColletion();

  Future<User?> login(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    // ignore: non_constant_identifier_names
    String APIKey,
    BuildContext context,
  ) async {
    try {
      if (password == confirmPassword) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await credential.user!.updateDisplayName(name);

        var data = {'user': email, 'api_key': APIKey, 'user_image': ''};

        await _database.insertUser(email, data);

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

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, "/login");
  }
}
