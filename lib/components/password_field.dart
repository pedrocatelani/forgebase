import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final bool initiallyObscured;
  final Color? iconColor;
  final double? iconSize;
  final InputBorder? border;
  final TextStyle? textStyle;

  const PasswordField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.decoration,
    this.initiallyObscured = true,
    this.iconColor,
    this.iconSize,
    this.border,
    this.textStyle,
  });

  @override
  State<PasswordField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initiallyObscured;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      style: widget.textStyle,
      decoration: (widget.decoration ?? InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: widget.border ?? const OutlineInputBorder(),
      )).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: widget.iconColor ?? Colors.grey,
            size: widget.iconSize ?? 24,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}