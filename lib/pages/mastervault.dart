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

  Future<void> saveDeck(String dokiD) async {
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

  @override
  Widget build(BuildContext context) {
    final idDeck = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(idDeck),
            IconButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: idDeck));
              },
              icon: Icon(Icons.copy),
            ),
          ],
        ),
      ),
      body: WebViewWidget(controller: _controller),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? url = await _controller.currentUrl();

          var dokId = url!.substring(url.length - 36);

          await saveDeck(dokId);
          Navigator.pushReplacementNamed(context, "/home");
        },
      ),
    );
  }
}
