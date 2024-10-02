import 'package:flutter/material.dart';
import 'package:my_schedule/main.dart';
import 'package:my_schedule/shared/button.dart';

class StudentScreen extends StatelessWidget {
  
  
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "STUDENT'S SCREEN",
              style: TextStyle(fontSize: 30),
            ),

            const SizedBox(height: 20),

            MyButton(
              onTap: () async{
                await supabase.auth.signOut();
              },
              buttonName: "Log out"
            )
            
          ],
        ),
      ),
    );
  }
}