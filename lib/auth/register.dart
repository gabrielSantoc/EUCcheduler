import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_schedule/auth/login.dart';
import 'package:my_schedule/main.dart';
import 'package:my_schedule/screens/student_screen.dart';
import 'package:my_schedule/shared/button.dart';
import 'package:my_schedule/shared/constants.dart';
import 'package:my_schedule/shared/text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterNewState();
}

class _RegisterNewState extends State<RegisterScreen> {
  final _studentNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _sectionController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  
  late final StreamSubscription<AuthState>  _authSubscription;

  @override
  void initState() {
    // TODO: implement initState
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;

      if(session != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudentScreen())
        );
      }

    });
  }

  void registerAccount () async{
    
    try{
      
      print("EMAIL ::: ${_emailController.text}");
      print("PASSWORD ::: ${_birthDateController.text}");
      await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _birthDateController.text.trim(),
      );
      
    }catch(e) {

      print("ERROR ::: $e");

    }

    

  }   

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
                    controller: _studentNumberController,
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
                            controller: _firstNameController,
                            hintText: "First Name",
                            obscureText: true,
                          ),
                        ),

                        const SizedBox(width: 5),

                        Expanded(
                          child: MyTextFormFieldForName(
                            controller: _lastNameController,
                            hintText: "Last Name",
                            obscureText: true,
                          ),
                        ),
                    
                    
                      ],
                    ),
                  ),


                  
                  const SizedBox(height: 20),



                  MyTextFormField(
                    controller: _sectionController,
                    hintText: "Section",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),

                  MyTextFormField(
                    controller: _birthDateController,
                    hintText: "Birthdate",
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  
                  MyTextFormField(
                    controller: _emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  
                  MyTextFormField(
                    controller: _confirmEmailController,
                    hintText: "Confirm Email",
                    obscureText: false,
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
                            color: MAROON,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],

                  ),
                  const SizedBox(height: 25),
        
                  MyButton(
                    onTap: () {
                      registerAccount();
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
