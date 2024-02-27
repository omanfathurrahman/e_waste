import 'package:ewaste/main.dart';
import 'package:ewaste/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Create controllers for the text fields
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _pekerjaanController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Sign up the user
  Future<void> signUp() async {
    // Sign up the user
    final res = await supabase.auth.signUp(
      email: _emailController.text,
      password: _passwordController.text,
      data: {
        'full_name': _fullnameController.text,
      },
    );
    // Insert the user's profile
    await supabase.from('profile').insert({
      'id': res.user!.id,
      'nama_lengkap': _fullnameController.text,
      'pekerjaan': _pekerjaanController.text,
      'email': _emailController.text,
    });
    // Log out the user
    await supabase.auth.signOut();
    // Redirect to the login screen
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: _fullnameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Masukkan nama lengkap',
                    labelText: 'Nama Lengkap',
                  ),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
                TextFormField(
                  controller: _pekerjaanController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Masukkan pekerjaan anda',
                    labelText: 'Pekerjaan',
                  ),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.email),
                    hintText: 'Masukkan Email',
                    labelText: 'Email',
                  ),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    hintText: 'Masukkan Password',
                    labelText: 'Password',
                  ),
                  onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String? value) {
                    return (value != null && value.contains('@'))
                        ? 'Do not use the @ char.'
                        : null;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: signUp,
                  child: const Text("Register"),
                ),
                Row(
                  children: [
                    const Text("Sudah punya akun?"),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
