import 'package:ewaste/screen/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure that FlutterFire is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://oexltokstwraweaozqav.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9leGx0b2tzdHdyYXdlYW96cWF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ1NjM5OTEsImV4cCI6MjAyMDEzOTk5MX0.4IB_1dfaBU6Ew-CtE4Uvs2Pmfd5SPi1Lan1oe5PSwIU');

  runApp(const MainApp());
}

// Create a new instance of supabase
final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
