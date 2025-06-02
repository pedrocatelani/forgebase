import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 115, 35, 255), Color(0xFF1C1B22)],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
    );
  }
}
