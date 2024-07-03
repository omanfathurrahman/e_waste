import 'package:ewaste/screen/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure that FlutterFire is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://rzogzczqlzdsgugljcik.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6b2d6Y3pxbHpkc2d1Z2xqY2lrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAwMDQ3MTMsImV4cCI6MjAzNTU4MDcxM30.ffdgNELGID6JIc-dQVojdxijkQRmbgl0lbACJW29nhI',
  );
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
