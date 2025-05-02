import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/password_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                  decoration: InputDecoration(
                    hintText: "Nome de usuário",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                PasswordField(
                  decoration: InputDecoration(
                    hintText: "Senha",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                PasswordField(
                  decoration: InputDecoration(
                    hintText: "Confirmar senha",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      () => Navigator.pushReplacementNamed(context, "/login"),
                  child: Text("Registrar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
