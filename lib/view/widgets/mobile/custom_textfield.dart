import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextfield extends StatelessWidget {
  String name;
  Color color;
  IconData icon;
  TextInputType keyboardtype;
  double vertical;
  String? Function(String?)? validator;
  TextEditingController controller;
  ValueChanged<String> onChanged;
  
  double horizontal;

  CustomTextfield(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.color,
      required this.validator,
      required this.icon,
      required this.keyboardtype,
      required this.name,
      required this.horizontal,
      required this.vertical});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: color),
        hintText: name,
        hintStyle: const TextStyle(fontSize: 12),
        contentPadding:
            EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
        // Default border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),  // Rounded corners for the border
        ),
        // Border when the TextField is enabled but not focused
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 1),  // Custom color for enabled border
          borderRadius: BorderRadius.circular(10),
        ),
        // Border when the TextField is focused
        focusedBorder: OutlineInputBorder(
          borderSide:const BorderSide(color: Colors.blue, width: 2),  // Custom color and width for focused border
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardtype,
      style: const TextStyle(fontSize: 16),
    );
  }
}
