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

  Future<void> changePasswordByEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await _auth.currentUser?.reauthenticateWithCredential(credential);
      await _database.unlinkDecksUser(email);
      await _database.deleteUserDocument(email);
      await _auth.currentUser?.delete();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      final snackBar = SnackBar(content: Text("Password invalid"));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> updateUser(
    String userName,
    userEmail,
    String apiKey,
    BuildContext context,
  ) async {
    try {
      _auth.currentUser?.updateDisplayName(userName);
      final snackBar = SnackBar(content: Text("Updated name"));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (ex) {
      final snackBar = SnackBar(content: Text("Error"));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    final isApiKeyValid = await _database.updateApiKey(
      userEmail,
      apiKey,
      context,
    );

    if (isApiKeyValid) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/user');
      final snackBar = SnackBar(content: Text("Updated Api Key"));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(content: Text("Api Key invalid"));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
