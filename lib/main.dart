import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_schedule/screens/login.dart';
import 'package:my_schedule/screens/student_screen2.dart';
import 'package:my_schedule/screens/testScreen.dart';
import 'package:my_schedule/shared/constants.dart';

import 'package:supabase_flutter/supabase_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  
  await Supabase.initialize(
    url: "***REMOVED***",
    anonKey: "***REMOVED***",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  ScheduleScreen()
    );
  }
}