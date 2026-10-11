import 'package:flutter/material.dart';

class ForgebaseActionIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;

  const ForgebaseActionIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.backgroundColor = const Color.fromARGB(255, 138, 16, 159),
    this.foregroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
