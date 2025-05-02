import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/password_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
                Column(
                  children: [
                    PasswordField(
                      decoration: InputDecoration(
                        hintText: "Senha",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Esqueci minha senha"),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed:
                      () => Navigator.pushReplacementNamed(context, "/home"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
                  ),
                  child: Text("Entrar", style: TextStyle(fontSize: 20)),
                ),
                Column(
                  children: [
                    Text("Ou entre com"),
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
                    Text("Você não tem uma conta?"),
                    TextButton(
                      onPressed:
                          () => Navigator.pushNamed(context, "/register"),
                      child: Text("Registrar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
