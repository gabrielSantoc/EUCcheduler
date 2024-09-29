import 'package:flutter/material.dart';

class TeacherScreen extends StatelessWidget {
  
  
  const TeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(
              "TEACHER'S SCREEN",
              style: TextStyle(fontSize: 30),
            )
            
          ],
        ),
      ),
    );
  }
}