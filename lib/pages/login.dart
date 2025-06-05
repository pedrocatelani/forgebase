// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/password_field.dart';
import 'package:forgebase/utils/_auth_services.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();
  var txtForgotPassword = TextEditingController();

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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 25,
                  children: [
                    Image.asset(
                      'assets/ForgeBase.png',
                      width: 300,
                      height: 250,
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
                    Column(
                      children: [
                        PasswordField(
                          controller: txtPassword,
                          decoration: InputDecoration(
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed:
                                () => showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: Text('Enter your user email'),
                                        actions: [
                                          TextField(
                                            controller: txtForgotPassword,
                                            decoration: InputDecoration(
                                              label: Text('User email'),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(22),
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed:
                                                    () => authService
                                                        .changePasswordByEmail(
                                                          txtForgotPassword.text
                                                              .trim(),
                                                        ),
                                                child: Text('Send'),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text('Close'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                ),
                            child: Text("Forgot password?"),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed:
                          () => authService.login(
                            txtEmail.text.trim(),
                            txtPassword.text.trim(),
                            context,
                          ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 60),
                      ),
                      child: Text("Log In", style: TextStyle(fontSize: 20)),
                    ),
                    Column(
                      children: [
                        Text("Log in with"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Image.asset(
                                'assets/google_icon.png',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed:
                              () => Navigator.pushNamed(context, "/register"),
                          child: Text("Sign up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
