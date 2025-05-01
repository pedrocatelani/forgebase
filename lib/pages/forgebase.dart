import 'package:flutter/material.dart';
import 'package:forgebase/pages/idscanner.dart';
import 'package:forgebase/pages/scannerresult.dart';

class ForgeBaseApp extends StatelessWidget {
  const ForgeBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const QRScannerScreen(),
      routes: {
        // '/': (context) => const TelaInicial(),
        '/scanner': (context) => const QRScannerScreen(),
        '/scannerResult': (context) => const ScannerResult(),
      }
    );
  }
}
