import 'package:e_waste/main.dart';
import 'package:e_waste/screen/auth/login_screen.dart';
import 'package:e_waste/screen/main_layout.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  // Redirect to the main layout if the user is logged in
  Future<void> _redirect() async {
    // Wait for the next frame to avoid the splash screen from being skipped
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    // Check if the user is logged in
    final session = supabase.auth.currentSession;
    if (session != null) {
      // Redirect to the main layout
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MainLayout(),
        ),
      );
    } else {
      // Redirect to the login screen
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
