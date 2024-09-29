import 'package:flutter/material.dart';

class StudentScreen extends StatelessWidget {
  
  
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "STUDENT'S SCREEN",
              style: TextStyle(fontSize: 30),
            )
            
          ],
        ),
      ),
    );
  }
}