import 'package:e_waste/main.dart';
import 'package:e_waste/screen/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void signIn(BuildContext context) async {
    await Supabase.instance.client.auth.signInWithPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MainLayout(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Masukkan email',
                  labelText: 'Email',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                // validator: (String? value) {
                //   return (value != null && value.contains('@'))
                //       ? 'Do not use the @ char.'
                //       : null;
                // },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Masukkan Password',
                  labelText: 'Password',
                ),
                onSaved: (String? value) {
                  // This optional block of code can be used to run
                  // code when the user saves the form.
                },
                // validator: (String? value) {
                //   return (value != null && value.contains('@'))
                //       ? 'Do not use the @ char.'
                //       : null;
                // },
              ),
              ElevatedButton(
                onPressed: () => signIn(context),
                child: const Text("Register"),
              ),
              Row(
                children: [
                  const Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
