import 'package:ewaste/screen/default.dart';
import 'package:flutter/material.dart';

class PrivasiKeamananScreen extends StatelessWidget {
  const PrivasiKeamananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Default(
        appBar: AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.transparent,
            title: const Text('Privasi Keamanan',
                style: TextStyle(color: Colors.white))),
        child: const Text("Privasi Keamanan Screen"));
  }
}
