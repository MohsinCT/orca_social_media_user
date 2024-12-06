import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/forgot_password_controller.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_appbar.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_password_field.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    final forgotpassProvider = Provider.of<ForgotPassController>(context);
    return Scaffold(
      appBar: const CustomAppbar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter the email to sent the reset link "),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.screenWidth * 0.1),
              child: NewCustomTextFormField(
                  controller: _emailController,
                  labelText: 'Enter the Email....'),
            ),
            MaterialButton(
              onPressed: () async {
                await forgotpassProvider.passwordReset(
                    _emailController.text.trim(), context);
              },
              child: const Text('Reset Password'),
            )
          ],
        ),
      ),
    );
  }
}
