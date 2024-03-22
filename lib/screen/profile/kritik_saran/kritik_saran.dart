import 'package:ewaste/screen/default.dart';
import 'package:flutter/material.dart';

class KritikSaranScreen extends StatefulWidget {
  const KritikSaranScreen({super.key});

  @override
  State<KritikSaranScreen> createState() => _KritikSaranScreenState();
}

class _KritikSaranScreenState extends State<KritikSaranScreen> {
  @override
  Widget build(BuildContext context) {
    return Default(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('Kritik Saran',
                style: TextStyle(color: Colors.white)),
            leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        )),
        child: const Text("Kritik Saran Screen"));
  }
}
