import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_schedule/auth/login.dart';
import 'package:my_schedule/auth/register.dart';
import 'package:my_schedule/shared/constants.dart';

import 'package:supabase_flutter/supabase_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  
  await Supabase.initialize(
    url: "https://gktxmfxkiqixazprhzwq.supabase.co",
    anonKey: api_key.toString(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  LoginScreen()
    );
  }
}