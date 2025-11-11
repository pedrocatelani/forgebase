// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/components/background.dart';
import 'package:forgebase/components/button_no_outline.dart';
import 'package:forgebase/utils/_auth_services.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String urlString) async {
  // Converte a string em um Uri (obrigatório para launchUrl)
  final Uri url = Uri.parse(urlString);

  // Tentativa de lançar a URL
  if (!await launchUrl(url)) {
    throw Exception('Não foi possível lançar $urlString');
  }
}

// ignore: must_be_immutable
class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("About")),
        body: Stack(
          children: [
            CustomBackground(),
            Container(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Container(height: 8),
                      Text(
                        "Forgebase Project",
                        style: TextStyle(
                          color: Color(0xFFFFB800),
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Started: Apr 14, 2025",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "       Forgebase is a project aiming to make Keyforge player's life easier. It started as a college project from a friend group of 4 passionate players, and developed to be this app. Thank you for staying with us!",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 8),
                      Container(
                        height: 1,
                        color: Color.fromARGB(71, 255, 183, 0),
                      ),
                      Container(height: 8),
                      Container(height: 8),
                      Text(
                        "GAS Project",
                        style: TextStyle(
                          color: Color(0xFFFFB800),
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Started: Nov 12, 2024",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "       Genetic Algorithm Score, or GAS for short, was born as a sub-product of our graduation work at Fatec São José do Rio Preto, a Brazilian Technology College",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "       GAS is a work-in-progress open-scource API, based off of battle simulations using the public Decks of Keyforge API.",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 8),
                      Container(
                        height: 1,
                        color: Color.fromARGB(71, 255, 183, 0),
                      ),
                      Container(height: 8),
                      Text(
                        "Who are we?",
                        style: TextStyle(
                          color: Color(0xFFFFB800),
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Pedro Catelani", style: TextStyle(fontSize: 12)),
                      Text("Tales Brandt", style: TextStyle(fontSize: 12)),
                      Text("Gustavo Souza", style: TextStyle(fontSize: 12)),
                      Text("Gustavo Minghetti", style: TextStyle(fontSize: 12)),
                      Text(
                        "       A group of 4, we all met during our first college year, and quickly become close friends. During our years studying together, we came to know Keyforge, and helped create a local comunity of the game.",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "       Our wish is to make the game more and more popular in our region, supporting it by playing, hosting tournaments, and, specially, contributing to the scientific research around the game using our GAS API.",
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(height: 8),
                      Container(
                        height: 1,
                        color: Color.fromARGB(71, 255, 183, 0),
                      ),
                      Container(height: 8),
                      Text(
                        "Useful Links",
                        style: TextStyle(
                          color: Color(0xFFFFB800),
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ButtonNoOutline(
                        buttonTitle: "Forgebase Repo",
                        onPressed:
                            () => _launchUrl(
                              "https://github.com/pedrocatelani/forgebase",
                            ),
                      ),
                      ButtonNoOutline(
                        buttonTitle: "GAS Repo",
                        onPressed:
                            () => _launchUrl(
                              "https://github.com/pedrocatelani/aerc-sas-kf",
                            ),
                      ),
                      ButtonNoOutline(
                        buttonTitle: "DoK API",
                        onPressed:
                            () =>
                                _launchUrl("https://decksofkeyforge.com/about"),
                      ),
                      ButtonNoOutline(
                        buttonTitle: "Challonge API",
                        onPressed:
                            () => _launchUrl(
                              "https://challonge.com/pt_BR/connect.html",
                            ),
                      ),
                      Container(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
