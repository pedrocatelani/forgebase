import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(110, 155, 39, 176), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
    );
  }
}
