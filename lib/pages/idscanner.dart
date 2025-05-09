import 'package:camera/camera.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
// import 'package:forgebase/pages/scannerresult.dart';
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
                            title: Text("Seu Deck foi encontrado!"),
                            content: Text(
                              "Deck de id: $idDeck!, é um belo deck! gostaria de adicionar ele aos seus baralhos?",
                            ),
                            actions: [
                              TextButton(
                                child: Text("Cancelar"),
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Deck Nâo foi adicionado!"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );

                                  cameraController.start();
                                },
                              ),

                              TextButton(
                                child: Text("Adicionar"),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Deck adicionado com sucesso!",
                                      ),
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
                    } else {
                      // showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (BuildContext context) {
                      //     return AlertDialog(
                      //       title: Text("Erro"),
                      //       content: Text(
                      //         "Não foi possivel encontrar o deck, gostaria de Digitar manualmente?",
                      //       ),
                      //       actions: [
                      //         TextButton(
                      //           child: Text("Sim"),
                      //           onPressed: () {
                      //             Navigator.of(context).pop();
                      //             showDialog(
                      //               context: context,
                      //               barrierDismissible: false,
                      //               builder: (BuildContext context) {
                      //                 return AlertDialog(
                      //                   title: Text("Digite a ID do deck!"),
                      //                   content: TextField(
                      //                     decoration: InputDecoration(
                      //                       hintText: "Id do deck",
                      //                     ),
                      //                     onSubmitted: (idDeck) {
                      //                       if (idDeck.length == 17) {
                      //                         Navigator.of(context).pop();
                      //                         ScaffoldMessenger.of(
                      //                           context,
                      //                         ).showSnackBar(
                      //                           SnackBar(
                      //                             content: Text(
                      //                               "Deck adicionado com sucesso!",
                      //                             ),
                      //                             duration: Duration(
                      //                               seconds: 2,
                      //                             ),
                      //                           ),
                      //                         );
                      //                       } else {
                      //                         ScaffoldMessenger.of(
                      //                           context,
                      //                         ).showSnackBar(
                      //                           SnackBar(
                      //                             content: Text(
                      //                               "Não foi possível adicionar o deck!",
                      //                             ),
                      //                             duration: Duration(
                      //                               seconds: 2,
                      //                             ),
                      //                           ),
                      //                         );
                      //                       }
                      //                     },
                      //                   ),
                      //                 );
                      //               },
                      //             ); //Show Dialog
                      //           },
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
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
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Digite a ID do deck!"),
                      content: TextField(
                        decoration: InputDecoration(hintText: "Id"),
                      ),
                      actions: [
                        TextButton(
                          child: Text("Cancelar"),
                          onPressed: () {
                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Deck Nâo foi adicionado!"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),

                        TextButton(
                          child: Text("Adicionar"),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Deck adicionado com sucesso!"),
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
              },
              icon: Icon(Icons.edit),
              label: Text("Inserir ID"),
            ),
          ),
        ],
      ),

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
