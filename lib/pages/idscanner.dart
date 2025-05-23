import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/utils/_firebase_collections.dart';
import 'package:forgebase/utils/dok_api.dart';
import 'package:iconly/iconly.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

enum _SelectedTab { user, home, camera }

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  _SelectedTab _selectedTab = _SelectedTab.camera;
  final TextEditingController idController = TextEditingController();

  void _onTapChange(int index) {
    setState(() {
      _selectedTab = _SelectedTab.values[index];
    });

    Navigator.pushNamed(context, '/${_SelectedTab.values[index].name}');
  }

  Future<void> saveDeck(String dokiD) async {
    final dokApi = DoKApi();
    final firestore = FirebaseColletion();

    final result = await dokApi.getStatistics(dokiD);
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

  User? user = FirebaseAuth.instance.currentUser;

  MobileScannerController cameraController = MobileScannerController();
  String? qrCode;
  String? idDeck;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) async {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  setState(() {
                    qrCode = barcode.rawValue;
                    if (qrCode != null && qrCode!.length >= 17) {
                      idDeck = qrCode!.substring(qrCode!.length - 17);
                      idDeck = idDeck!.replaceAll('-', '');

                      cameraController.stop();

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Deck has been found!"),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            content: SizedBox(
                              child: Text(
                                "Deck id: $idDeck! \nit's a great deck! Would you like to add him to your decks?",
                              ),
                            ),

                            actions: [
                              TextButton(
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 8,
                                  ),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    138,
                                    16,
                                    159,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  foregroundColor: Colors.white,
                                ),

                                child: Text("Return"),
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Deck Not Added!"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );

                                  cameraController.start();
                                },
                              ),

                              TextButton(
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 8,
                                  ),
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    138,
                                    16,
                                    159,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text("Add"),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Deck Added!"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  Navigator.pushNamed(context, "/user");
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  });
                }
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                backgroundColor: const Color.fromARGB(255, 138, 16, 159),
              ),

              onPressed: () {
                cameraController.stop();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final screenHeight = MediaQuery.of(context).size.height;

                    return AlertDialog(
                      title: Text("Write the ID!"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      content: SizedBox(
                        width: screenWidth * 0.15,
                        height: screenHeight * 0.07,
                        child: TextField(
                          controller: idController,
                          decoration: InputDecoration(
                            hintText: "Write the Id",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text("Return"),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              138,
                              16,
                              159,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Deck not added!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            cameraController.start();
                          },
                        ),

                        TextButton(
                          child: Text("Add"),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 8,
                            ),
                            backgroundColor: const Color.fromARGB(
                              255,
                              138,
                              16,
                              159,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            final dokId = idController.text;
                            await saveDeck(dokId);
                            Navigator.pop(context);
                            cameraController.start();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.edit),
              label: Text("ID"),
            ),
          ),
        ],
      ),

      //Crystal Navigations
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CrystalNavigationBar(
          onTap: _onTapChange,
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          indicatorColor: Colors.purple,
          backgroundColor: const Color.fromARGB(255, 240, 240, 240),
          enableFloatingNavBar: true,
          items: [
            CrystalNavigationBarItem(
              icon: IconlyBold.user_2,
              unselectedIcon: IconlyLight.user,
              selectedColor: Colors.purple,
              unselectedColor: Colors.purple,
            ),
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Colors.purple,
              unselectedColor: Colors.purple,
            ),
            CrystalNavigationBarItem(
              icon: IconlyBold.category,
              unselectedIcon: IconlyLight.category,
              selectedColor: Colors.purple,
              unselectedColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}
