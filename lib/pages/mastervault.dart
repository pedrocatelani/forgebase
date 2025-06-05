import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
// import 'package:forgebase/utils/dok_api.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MasterVault extends StatefulWidget {
  const MasterVault({super.key});

  @override
  State<MasterVault> createState() => _MasterVaultState();
}

class _MasterVaultState extends State<MasterVault> {
  User? user = FirebaseAuth.instance.currentUser;
  final FirebaseColletion database = FirebaseColletion();

  void _close(String deckId) {
    Clipboard.setData(ClipboardData(text: deckId)).then((_) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(const SnackBar(content: Text("ID was copied!")));
    });
    setState(() {
      _showInstructions = false;
    });
  }

  // Future<void> _saveDeck(String dokiD) async {
  //   final dokApi = DoKApi();
  //   final firestore = FirebaseColletion();
  //   final apiKey = await firestore.getApiKey(user!.email!);
  //   final FirebaseFirestore db = FirebaseFirestore.instance;

  //   final checkDeckRegistered =
  //       await db.collection('decks').where('vaulId', isEqualTo: dokiD).get();
  //   // ignore: unnecessary_null_comparison
  //   if (checkDeckRegistered.docs.isEmpty) {
  //     final result = await dokApi.getStatistics(dokiD, apiKey);
  //     if (result['status'] == 200) {
  //       await firestore.insertDeck(
  //         user!.email!,
  //         dokiD,
  //         Map<String, dynamic>.from(result['deck']),
  //       );
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text("Success!\nDeck saved!")));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text("Error to find the Deck! ${result['status']}"),
  //         ),
  //       );
  //     }
  //   } else {
  //     for (var doc in checkDeckRegistered.docs) {
  //       if (doc['user_email'] == '') {
  //         await db.collection('decks').doc(dokiD).update({
  //           'user_email': user?.email,
  //         });
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("You have discovered an abandoned deck")),
  //         );
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("This deck is already registered")),
  //         );
  //       }
  //     }
  //   }
  // }

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
    'assets/instructions/instruction4.jpg',
    'assets/instructions/instruction5.jpg',
    'assets/instructions/instruction6.jpg',
    'assets/instructions/instruction7.jpg',
    'assets/instructions/instruction8.jpg',
    'assets/instructions/instruction9.jpg',
    'assets/instructions/instruction10.jpg',
  ];
  final List<String> instructionTexts = [
    'Step 1: Read all instructions, then click "Ok, copy and continue".',
    'Step 2: Click the menu (three bars) as shown.',
    'Step 3: Log in to Master Vault.',
    'Step 4: After login, click the highlighted area.',
    'Step 5: Scroll down and paste your ID.',
    'Step 6: Confirm the ID, then click "Add Deck".',
    'Step 7: Click "Go to Deck" to add it to Master Vault.',
    'Step 8: On the deck page, click the icon to save.',
    'Step 9: Wait a few moments for it to complete.',
    'Step 10: You’ll be redirected to the user page with your deck.',
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

          if (url == null || url.length < 36) {
            Future.delayed(Duration.zero, () {
              ScaffoldMessenger.of(
                // ignore: use_build_context_synchronously
                context,
              ).showSnackBar(const SnackBar(content: Text("Invalid Url")));
            });
            return;
          }

          var dokId = url.substring(url.length - 36);

          final validIdRegex = RegExp(r'^[a-zA-Z0-9-]{36}$');

          if (!validIdRegex.hasMatch(dokId)) {
            Future.delayed(Duration.zero, () {
              ScaffoldMessenger.of(
                // ignore: use_build_context_synchronously
                context,
              ).showSnackBar(const SnackBar(content: Text("Invalid Id")));
            });
            return;
          }

          // ignore: use_build_context_synchronously
          await database.saveDeck(dokId, user!.email!, context);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, "/user");
        },

        child: const Icon(Icons.save),
      ),
    );
  }
}
