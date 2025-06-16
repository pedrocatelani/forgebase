import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    cameraController.stop();
    cameraController.start();
  }

  void _onTapChange(int index) {
    setState(() {
      _selectedTab = _SelectedTab.values[index];
    });

    Navigator.pushNamed(context, '/${_SelectedTab.values[index].name}');
  }

  MobileScannerController cameraController = MobileScannerController();
  String? qrCode;
  String? idDeck;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
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
                                Navigator.pushNamed(
                                  context,
                                  "/mastervault",
                                  arguments: idDeck.toString(),
                                );
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
                          // ignore: sort_child_properties_last
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
                          // ignore: sort_child_properties_last
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
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              "/mastervault",
                              arguments: idController.text.trim(),
                            );
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
          indicatorColor: Color.fromARGB(255, 138, 80, 238),
          backgroundColor: const Color.fromARGB(255, 73, 72, 72),
          enableFloatingNavBar: true,
          items: [
            CrystalNavigationBarItem(
              icon: IconlyBold.user_2,
              unselectedIcon: IconlyLight.user,
              selectedColor: Color.fromARGB(255, 138, 80, 238),
              unselectedColor: Color.fromARGB(255, 138, 80, 238),
            ),
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Color.fromARGB(255, 138, 80, 238),
              unselectedColor: Color.fromARGB(255, 138, 80, 238),
            ),
            CrystalNavigationBarItem(
              icon: IconlyBold.category,
              unselectedIcon: IconlyLight.category,
              selectedColor: Color.fromARGB(255, 138, 80, 238),
              unselectedColor: Color.fromARGB(255, 138, 80, 238),
            ),
          ],
        ),
      ),
    );
  }
}
