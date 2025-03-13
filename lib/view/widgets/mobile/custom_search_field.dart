import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final Icon prefixIcon;
  final ValueChanged<String> onChanged;

  const CustomSearchField(
      {super.key,
      required this.hintText,
      required this.prefixIcon,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      onChanged: onChanged,
    );
  }
}
