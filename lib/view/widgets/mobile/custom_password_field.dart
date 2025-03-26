import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/controllers/textfield_provider.dart';
import 'package:provider/provider.dart';

// class CustomPasswordField extends StatelessWidget {
//   final String name;
//   final TextEditingController controller;
//   final Color color;
//   final IconData icon;
//   final TextInputType keyboardtype;
//   final double vertical;
//   final double horizontal;
//   final String ? Function(String?)? validator;
//   final bool isPassword; // Indicates if it's a password field
//   final bool isObscure; // Determines if the text is hidden or visible
//   final VoidCallback togglePasswordVisibility; // Callback for toggling password visibility
//   final ValueChanged<String> onChanged;

//   const CustomPasswordField({
//     super.key,
//     required this.controller,
//     required this.onChanged,
//     required this.color,
//     required this.icon,
//     required this.validator,
//     required this.keyboardtype,
//     required this.name,
//     required this.horizontal,
//     required this.vertical,
//     this.isPassword = false, // By default, it's not a password field
//     this.isObscure = true, // By default, the password is obscured
//     required this.togglePasswordVisibility,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       onChanged: onChanged,
//       controller: controller,
//       obscureText: isPassword && isObscure, // Obscures text if it's a password field and isObscure is true
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10)
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: color,width: 1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue , width: 2),
//           borderRadius: BorderRadius.circular(10)
//         ),
//         prefixIcon: Icon(icon),
//         hintText: name,
//         hintStyle: const TextStyle(fontSize: 12),
//         contentPadding: EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
//         suffixIcon: isPassword
//             ? IconButton(
//                 icon: Icon(
//                   isObscure ? Icons.visibility_off : Icons.visibility, // Toggle between visibility icons
//                   color: AppColors.oRLightGrey, // Change the icon color
//                 ),
//                 onPressed: togglePasswordVisibility, // Call the function to toggle visibility
//               )
//             : null, // No icon if it's not a password field
//       ),
//       keyboardType: keyboardtype,
//       style: const TextStyle(fontSize: 16),
//     );
//   }
// }

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final String? prefixText;
  const CustomTextField(
      {super.key,
      required this.controller,
      this.isPassword = false,
      required this.labelText,
      this.keyboardType,
      this.validator,
      this.prefixText});

  @override
  Widget build(BuildContext context) {
    return Consumer<TextfieldProvider>(
      builder: (context, textProvider, child) {
        return TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          obscureText: isPassword && textProvider.obscureText,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            fillColor: Colors.grey.shade200,
            filled: true,
            prefixText: prefixText,
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(textProvider.obscureText
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: textProvider.toggleObscureText,
                  )
                : null,
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10),
            //   borderSide: const BorderSide(
            //     color: Colors.black,
            //     width: 2.0,
            //   ),
            // ),
          ),
        );
      },
    );
  }
}

class NewCustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final String? prefixText;

  const NewCustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType,
    this.validator,
    this.isPassword = false,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TextfieldProvider>(
      builder: (context, provider, child) {
        return TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && provider.obscureText,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 10.0,
            ),
            prefixText: prefixText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            fillColor: AppColors.oRwhite,
            filled: true,
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(provider.obscureText
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: provider.toggleObscureText,
                  )
                : null,
          ),
          validator: validator,
        );
      },
    );
  }
}
