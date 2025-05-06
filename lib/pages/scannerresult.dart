import 'package:flutter/material.dart';
import 'package:forgebase/pages/idscanner.dart';

class ScannerResult extends StatefulWidget {
  const ScannerResult({super.key});

  @override
  State<ScannerResult> createState() => _ScannerResultState();
}

class _ScannerResultState extends State<ScannerResult> {
  @override
  Widget build(BuildContext context) {
    final String? idDeck = ModalRoute.of(context)?.settings.arguments as String?;
    ModalRoute.of(context)?.settings.arguments as String?;
    return Scaffold(
      body: Text("d"), 
      appBar: AppBar(),
      );
  }
}
