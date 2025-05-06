import 'package:camera/camera.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/pages/scannerresult.dart';
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
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  setState(() {
                    qrCode = barcode.rawValue;
                    if (qrCode != null && qrCode!.length >= 17) {
                      idDeck = qrCode!.substring(qrCode!.length - 17);
                      idDeck = idDeck!.replaceAll('-', '');
                    } else {
                      idDeck = null;
                    }
                  });
                } //Final do for
                if (idDeck == null) {
                } else {
                  // cameraController.stop();
                  Navigator.pushNamed(
                    context,
                    '/scannerResult',
                    arguments: idDeck,
                  );
                }
              },
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
