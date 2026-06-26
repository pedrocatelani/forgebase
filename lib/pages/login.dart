// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/password_field.dart';
import 'package:forgebase/utils/_auth_services.dart';
import 'package:forgebase/utils/translate.dart';

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
                        hintText: translate('AUTH.EMAIL'),
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
                            hintText: translate('AUTH.PASSWORD'),
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
                                        title: Text(
                                          translate('AUTH.ENTER_USER_EMAIL'),
                                        ),
                                        actions: [
                                          TextField(
                                            controller: txtForgotPassword,
                                            decoration: InputDecoration(
                                              label: Text(
                                                translate('AUTH.USER_EMAIL'),
                                              ),
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
                                                child: Text(
                                                  translate('COMMON.SEND'),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text(
                                                  translate('COMMON.CLOSE'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                ),
                            child: Text(translate('AUTH.FORGOT_PASSWORD')),
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
                      child: Text(
                        translate('AUTH.LOGIN'),
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Column(
                      children: [
                        Text(translate('AUTH.LOGIN_WITH')),
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
                        Text(translate('AUTH.NO_ACCOUNT')),
                        TextButton(
                          onPressed:
                              () => Navigator.pushNamed(context, "/register"),
                          child: Text(translate('AUTH.SIGN_UP')),
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
