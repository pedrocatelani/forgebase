import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forgebase/components/crystal_nav_bar.dart';
import 'package:forgebase/utils/translate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

enum _SelectedTab { home, user, settings }

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  _SelectedTab _selectedTab = _SelectedTab.settings;
  final TextEditingController idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    cameraController.stop();
    cameraController.start();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    idController.dispose();
    super.dispose();
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
                          title: Text(translate('SCANNER.DECK_FOUND')),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          content: SizedBox(
                            child: Text(
                              translate(
                                'SCANNER.DECK_FOUND_MESSAGE',
                                namedArgs: {'id': idDeck ?? ''},
                              ),
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

                              child: Text(translate('COMMON.RETURN')),
                              onPressed: () {
                                Navigator.of(context).pop();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      translate('SCANNER.DECK_NOT_ADDED'),
                                    ),
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
                              child: Text(translate('COMMON.ADD')),
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
                      title: Text(translate('SCANNER.WRITE_ID_TITLE')),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      content: SizedBox(
                        width: screenWidth * 0.15,
                        height: screenHeight * 0.07,
                        child: TextField(
                          controller: idController,
                          decoration: InputDecoration(
                            hintText: translate('SCANNER.WRITE_ID_HINT'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          // ignore: sort_child_properties_last
                          child: Text(translate('COMMON.RETURN')),
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
                                content: Text(
                                  translate('SCANNER.DECK_NOT_ADDED'),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            cameraController.start();
                          },
                        ),

                        TextButton(
                          // ignore: sort_child_properties_last
                          child: Text(translate('COMMON.ADD')),
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
              label: Text(translate('SCANNER.ID')),
            ),
          ),
        ],
      ),

      //Crystal Navigations
      extendBody: true,
      bottomNavigationBar: ForgebaseCrystalNavigationBar(
        currentIndex: _SelectedTab.values.indexOf(_selectedTab),
        onTap: _onTapChange,
      ),
    );
  }
}
