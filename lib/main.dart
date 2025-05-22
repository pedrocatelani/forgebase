import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forgebase/firebase_options.dart';
import 'package:forgebase/pages/forgebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(ForgeBaseApp());
}
