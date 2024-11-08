import 'package:flutter/material.dart';
import 'package:my_schedule/auth/reset_password.dart';
import 'package:my_schedule/main.dart';
import 'package:my_schedule/screens/schedule_screen.dart';
import 'package:my_schedule/shared/alert.dart';
import 'package:my_schedule/shared/button.dart';
import 'package:my_schedule/shared/constants.dart';
import 'package:my_schedule/shared/text_field.dart';
import 'package:my_schedule/shared/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  
  final forgotPasswordFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future sendToken() async {

    if(forgotPasswordFormKey.currentState!.validate()) {

      try {

        final res = await supabase.auth.resetPasswordForEmail(
          _emailController.text.trim()
        );

        Alert.of(context).showSuccess('Please check your email and spam folder for the TOKEN if it is not in your inbox! 🥰🥰🥰');

      } on AuthException catch (error) {
        
        Alert.of(context).showError('${error.message} 😢😢😢');

      }

    } else {

      Alert.of(context).showError('An error occured please try again 😢');

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MAROON,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Form(
            key: forgotPasswordFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
            
            
                const Text(
                  'Enter your email and we will send you a token to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w300
                  ),
                ),
            
                const SizedBox(height: 40),
            
                MyTextFormField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                  validator: Validator.of(context).validateEmail,
                ),
                
                const SizedBox(height: 20),
            
                MyButton(
                  onTap: sendToken,
                  buttonName: 'Send Reset Password Token'
                ),
            
                const SizedBox(height: 20),
            
                GestureDetector(
            
                  onTap: () {

                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const ResetPassowrdScreen()));

                  },
            
                  child: const Text(
                    'Already have a token? Reset Your Password',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: MAROON
                    ),
                    
                  ),
                ),
              ],  
            ),
          ),
        ),
      ),
    );
  }
}