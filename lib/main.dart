import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_schedule/screens/login.dart';
import 'package:my_schedule/screens/student_screen2.dart';
import 'package:my_schedule/screens/testScreen.dart';
import 'package:my_schedule/shared/constants.dart';

import 'package:supabase_flutter/supabase_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  
  await Supabase.initialize(
    url: "https://vuphmshlifryuczfphoz.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ1cGhtc2hsaWZyeXVjemZwaG96Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc2NTUzNDcsImV4cCI6MjA0MzIzMTM0N30.jcGi4KNAo5KNZCrT2wdbNOPy3WcCG6uWRzjVlFZ0RpA",
  );
  await Hive.initFlutter();


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