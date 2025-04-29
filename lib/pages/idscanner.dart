import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  String? qrCode;
  String? idDeck;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AppBar")),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue == qrCode) return;
                  setState(() {
                    qrCode = barcode.rawValue;
                    if (qrCode != null && qrCode!.length >= 17) {
                      idDeck = qrCode!.substring(qrCode!.length - 17);
                    } else {
                      idDeck = null;
                    }
                  });
                  // print(qrCode);
                  // print(idDeck);
                  cameraController.stop();
                  
                }
              },
            ),
          ),
         
          
        ],
      ),
    );
  }
}
