import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/constants/validation.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_password_field.dart';

class UserFormPage extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final GlobalKey<FormState> formkey;

  const UserFormPage(
      {super.key,
      required this.usernameController,
      required this.emailController,
      required this.passwordController,
      required this.formkey,
      required this.confirmController
      });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);
    return Form(
      key : formkey,
      child: Column(
        children: [
          CustomTextField(
            controller: usernameController,
             labelText: 'Username',
             keyboardType: TextInputType.text,
             validator: (value) => ValidationUtils.validate(value, 'Username') ,
             ),
          // NewCustomTextFormField(
          //   controller: usernameController, 
          //   labelText: 'Username',
          //   keyboardType: TextInputType.text,
          //   validator: (value) => ValidationUtils.validate(value , 'Username'),
          //   ),
            SizedBox(
              height: mediaQuery.screenHeight * 0.02,
            ),
            CustomTextField(
              controller: emailController, 
              labelText: 'Email',
              validator: (value) => ValidationUtils.validateemail(value),
              ),
            // NewCustomTextFormField(
            //   controller: emailController,
            //    labelText: 'Email',
            //    validator: (value) => ValidationUtils.validateemail(value),
            //    ),
               SizedBox(
              height: mediaQuery.screenHeight * 0.02,
            ),
            CustomTextField(
              controller: passwordController, 
              labelText: 'Password',
              validator: (value) => ValidationUtils.validate(value, 'Password'),
               isPassword: true,
              ),
            // NewCustomTextFormField(
            // controller: passwordController, 
            // labelText: 'Password',
            // validator: (value) => ValidationUtils.validate(value, 'Password'),
            // isPassword: true,
            // ),
            SizedBox(
              height: mediaQuery.screenHeight * 0.02,
            ),
            CustomTextField(
              controller: confirmController, 
              labelText: 'Confirm password',
              validator: (value){
                if(value != passwordController.text){
                  return 'password does not match';
                }
                return null;

              },
              isPassword: true,
              )
            // NewCustomTextFormField(
            //   controller:conformController ,
            //  labelText: 'Conform password',
            //  validator: (value) {
            //   if(value != passwordController.text){
            //     return 'password does not match';
            //   } 
            //   return null;
            //  },
            // )
        ],
      ));
  }
}
