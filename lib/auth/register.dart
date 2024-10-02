import 'package:flutter/material.dart';
import 'package:my_schedule/auth/login.dart';
import 'package:my_schedule/shared/button.dart';
import 'package:my_schedule/shared/constants.dart';
import 'package:my_schedule/shared/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterNewState();
}

class _RegisterNewState extends State<RegisterScreen> {
  final studentNumberController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MAROON,
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            // TOP WHITE CONTAINER
            Container(

              color: MAROON,
              height: MediaQuery.of(context).size.height * 0.2, 

              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,         
                children: [
                  SizedBox(height: 50),
                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
        
                  SizedBox(height: 10),
                ],
              ),
            ),
        
            // BOTTOM WHITE CONTAINER
            Container(
              
              height: MediaQuery.of(context).size.height * 0.8, 
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  MyTextFormField(
                    controller: studentNumberController,
                    hintText: "Student Number",
                    obscureText: false,
                  ),

                  const SizedBox(height: 20),


                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyTextFormFieldForName(
                            controller: passwordController,
                            hintText: "First Name",
                            obscureText: true,
                          ),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: MyTextFormFieldForName(
                            controller: passwordController,
                            hintText: "Last Name",
                            obscureText: true,
                          ),
                        ),
                    
                    
                      ],
                    ),
                  ),


                  
                  const SizedBox(height: 20),



                  MyTextFormField(
                    controller: passwordController,
                    hintText: "Section",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  MyTextFormField(
                    controller: passwordController,
                    hintText: "Birthdate",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  
                  MyTextFormField(
                    controller: passwordController,
                    hintText: "Email",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  
                  MyTextFormField(
                    controller: passwordController,
                    hintText: "Confirm Email",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      const SizedBox(width: 18),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen())
                          );
                        },
                        child: const Text(
                          "Log in",
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
                      // Handle login logic
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
