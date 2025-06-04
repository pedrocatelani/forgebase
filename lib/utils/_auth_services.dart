import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
import 'package:forgebase/utils/dok_api.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseColletion _database = FirebaseColletion();
  final dokApi = DoKApi();

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ignore: unnecessary_null_comparison
      if (credential != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      }
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (ex) {
      final snackBar = SnackBar(content: Text("Email or password invalid"));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String confirmPassword,
    // ignore: non_constant_identifier_names
    String apiKey,
    BuildContext context,
  ) async {
    try {
      if (password == confirmPassword) {
        String dokiD = 'c340a4e0-eec2-4b80-b333-178b65b6f596';
        final result = await dokApi.getStatistics(dokiD, apiKey);

        if (result['status'] == 200) {
          UserCredential credential = await _auth
              .createUserWithEmailAndPassword(email: email, password: password);
          await credential.user!.updateDisplayName(name);

          var data = {'user': email, 'api_key': apiKey, 'user_image': ''};

          await _database.insertUser(email, data);

          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, "/home");
        } else {
          final snackBar = SnackBar(content: Text("APIKey invaled"));
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        final snackBar = SnackBar(content: Text("The passwords are different"));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      // ignore: unused_catch_clause
    } on FirebaseAuthException catch (ex) {
      final snackBar = SnackBar(content: Text("Error in register"));
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
    if (userName != _auth.currentUser?.displayName) {
      _auth.currentUser?.updateDisplayName(userName);
      final snackBar = SnackBar(content: Text("Updated name"));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text("Current name same as previous one"),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    var oldApiKey = await _database.getApiKey(userEmail);

    if (apiKey != oldApiKey) {
      final isApiKeyValid = await _database.updateApiKey(
        userEmail,
        apiKey.trim(),
      );

      if (isApiKeyValid) {
        final snackBar = SnackBar(content: Text("Updated Api Key"));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(content: Text("Api Key invalid"));
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      final snackBar = SnackBar(
        content: Text("Current APIKey same as previous one"),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/user');
  }
}
