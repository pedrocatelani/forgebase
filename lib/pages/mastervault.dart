import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
import 'package:forgebase/utils/dok_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MasterVault extends StatefulWidget {
  const MasterVault({super.key});

  @override
  State<MasterVault> createState() => _MasterVaultState();
}

class _MasterVaultState extends State<MasterVault> {
  User? user = FirebaseAuth.instance.currentUser;

  void _close(String deckId) {
    Clipboard.setData(ClipboardData(text: deckId)).then((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ID was copied!")));
    });
    setState(() {
      _showInstructions = false;
    });
  }

  Future<void> _saveDeck(String dokiD) async {
    final dokApi = DoKApi();
    final firestore = FirebaseColletion();
    final apiKey = await firestore.getApiKey(user!.email!);

    final result = await dokApi.getStatistics(dokiD, apiKey);
    if (result['status'] == 200) {
      await firestore.insertDeck(
        user!.email!,
        dokiD,
        Map<String, dynamic>.from(result['deck']),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Success!\nDeck saved!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error to find the Deck! ${result['status']}")),
      );
    }
  }

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse('https://www.keyforgegame.com'));
  }

  bool _showInstructions = true;
  final List<String> instructionImages = [
    'assets/instructions/instruction1.jpg',
    'assets/instructions/instruction2.jpg',
    'assets/instructions/instruction3.jpg',
  ];
  final List<String> instructionTexts = [
    'Step 1: Navigate to the deck in Master Vault',
    'Step 2: Make sure the URL contains the deck ID',
    'Step 3: Click the floating button to save',
  ];

  @override
  Widget build(BuildContext context) {
    final idDeck = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: const Text('Master Vault')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),

          if (_showInstructions)
            Container(
              color: const Color.fromARGB(37, 115, 0, 86),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Your deck ID:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SelectableText(
                        idDeck,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Instructions:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),

                      SizedBox(
                        height: 280,
                        child: CarouselSlider.builder(
                          itemCount: instructionImages.length,
                          itemBuilder: (context, index, realIndex) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 180,
                                    child: Image.asset(
                                      instructionImages[index],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  Flexible(
                                    child: Text(
                                      instructionTexts[index],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 280,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 4),
                            enlargeCenterPage: true,
                            viewportFraction: 0.85,
                            enableInfiniteScroll: true,
                            pauseAutoPlayOnTouch: true,
                          ),
                        ),
                      ),
                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () => _close(idDeck),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              138,
                              16,
                              159,
                            ),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Ok, copy the ID and continue',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 164, 19, 255),
        onPressed: () async {
          String? url = await _controller.currentUrl();

          var dokId = url!.substring(url.length - 36);

          final validIdRegex = RegExp(r'^[a-zA-Z0-9-]{36}$');
          if (!validIdRegex.hasMatch(dokId)) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Invalid ID")));
            return;
          }

          await _saveDeck(dokId);
          Navigator.pushReplacementNamed(context, "/home");
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
