import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchField extends StatelessWidget {
  TextEditingController controller;
  ValueChanged<String> onChanged;
  SearchField({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
