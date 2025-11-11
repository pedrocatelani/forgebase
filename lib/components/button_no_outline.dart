import 'package:flutter/material.dart';

class ButtonNoOutline extends StatelessWidget {
  const ButtonNoOutline({
    super.key,
    required this.buttonTitle,
    required this.onPressed,
    this.icon,
  });
  final String buttonTitle;
  final VoidCallback onPressed;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 60),
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        shadowColor: Color.fromARGB(0, 255, 255, 255),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          if (icon != null) icon!,
          Text(buttonTitle, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
