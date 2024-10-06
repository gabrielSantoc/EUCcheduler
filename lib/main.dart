import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_schedule/auth/auth.dart';
import 'package:my_schedule/box/boxes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: "***REMOVED***",
    anonKey: "***REMOVED***",
  );

  // BOXES
  await Hive.initFlutter();
  boxUserId = await Hive.openBox<String>('userIdBox');


  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  AuthScreen()
    );
  }
}