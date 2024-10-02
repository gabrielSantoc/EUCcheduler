import 'package:flutter/material.dart';
import 'package:my_schedule/auth/register.dart';
import 'package:my_schedule/shared/button.dart';
import 'package:my_schedule/shared/constants.dart';
import 'package:my_schedule/shared/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final studentNumberController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MAROON,
      body: SingleChildScrollView(
        child: Column(
          children: [
        
            Container(
              
              // TOP MAROON CONTAINER
              color: MAROON,
              height: MediaQuery.of(context).size.height * 0.5, 


              child: const Column(

                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
        
                  Text(
                    "Welcome back!",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
        
                  SizedBox(height: 10),
                  
                  Text(
                    "Sign in to Continue!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            
            // BOTTOM MAROON CONTAINER
            Container(
              height: MediaQuery.of(context).size.height * 0.5, 
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30)
                ),
                color: Colors.white,
                boxShadow: [

                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.23),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: Column(

                children: [

                  MyTextFormField(
                    controller: studentNumberController,
                    hintText: "Student Number",
                    obscureText: false,
                  ),

                  const SizedBox(height: 20),

                  MyTextFormField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),

                  const SizedBox(height: 20),

                  Row(

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      const Text("Don't have an account? "),

                      const SizedBox(width: 18),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen())
                          );
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Color(0xFF9e0b0f),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
        
                  MyButton(
                    onTap: () {
                      
                    },
                    buttonName: "Login",
                  ),
        
                  const SizedBox(height: 15),
        
                  const Text(
                    "Your initial password is your birthdate\nin this format YYYY-MM-DD",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
