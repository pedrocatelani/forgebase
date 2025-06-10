import 'package:flutter/material.dart';

class CardGradient extends StatelessWidget {
  CardGradient({super.key, required this.color, required this.title});
  final Color color;
  final Text title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(8),
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [color, const Color.fromARGB(0, 255, 255, 255)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: title,
    );
  }
}
