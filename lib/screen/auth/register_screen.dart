import 'package:ewaste/main.dart';
import 'package:ewaste/screen/auth/login_screen.dart';
import 'package:ewaste/utils/get_pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool validatePW(String value) {
    String pattern = r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[^a-zA-Z]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  // Sign up the user
  Future<void> signUp(BuildContext context) async {
    if (_fullnameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama lengkap tidak boleh kosong'),
        ),
      );
      return;
    }
    if (_pekerjaanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Pekerjaan tidak boleh kosong',
        ),
      ));
      return;
    }
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email tidak boleh kosong'),
        ),
      );
      return;
    }
    if (_noHpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No HP tidak boleh kosong'),
        ),
      );
      return;
    }
    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak boleh kosong'),
        ),
      );
      return;
    }

    if (validatePW(_passwordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Password harus mengandung minimal 6 karakter, huruf besar, huruf kecil, angka, dan karakter spesial'),
        ),
      );
      return;
    }

    // Sign up the user
    final res = await supabase.auth.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );

    final pekerjaanId = (await supabase
        .from('daftar_pekerjaan')
        .select('id')
        .eq('nama', _pekerjaanController.text)
        .single()
        .limit(1))['id'] as num;

    // Insert the user's profile
    await supabase.from('profile').insert({
      'id': res.user!.id,
      'nama_lengkap': _fullnameController.text,
      'pekerjaan_id': pekerjaanId,
      'email': _emailController.text,
      'no_hp': _noHpController.text,
      'pw': _passwordController.text,
    });

    // Log out the user
    await supabase.auth.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Form(
              child: ListView(
                shrinkWrap: true,
                reverse: true,
                children: [
                  Image.asset('assets/images/logo.png',
                      width: 130, height: 130),
                  const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Buat akunmu sekarang!',
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    controller: _fullnameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Masukkan nama lengkap',
                      labelText: 'Nama Lengkap',
                    ),
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
                    controller: _noHpController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.phone),
                      hintText: 'Masukkan No HP',
                      labelText: 'No HP',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  FutureBuilder(
                    future: getPekerjaanList(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }
                      final pekerjaanList =
                          snapshot.data as List<Map<String, dynamic>>;

                      return Row(
                        children: [
                          Icon(Icons.work),
                          const SizedBox(
                            width: 16,
                          ),
                          DropdownMenu(
                            // expandedInsets: EdgeInsets.zero,
                            controller: _pekerjaanController,
                            // leadingIcon: const Icon(Icons.work),
                            label: const Text('Pekerjaan'),
                            hintText: 'Pilih pekerjaan anda',
                            inputDecorationTheme:
                                const InputDecorationTheme(border: null),
                            dropdownMenuEntries: pekerjaanList.map((e) {
                              return DropdownMenuEntry(
                                  label: e['nama'] as String,
                                  value: e['id'] as int);
                            }).toList(),
                          ),
                        ],
                      );
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
                    obscureText: true,
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
                    onPressed: () {
                      // signUp(context);
                    },
                    child: const Text("Register"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  ),
                ].reversed.toList(),
              ),
            ),
          );
        }),
      ),
    );
  }
}
