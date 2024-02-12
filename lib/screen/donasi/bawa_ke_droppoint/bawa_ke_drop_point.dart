import 'package:flutter/material.dart';

class BawaKeDropPointScreen extends StatefulWidget {
  const BawaKeDropPointScreen({super.key});

  @override
  State<BawaKeDropPointScreen> createState() => _BawaKeDropPointScreenState();
}

class _BawaKeDropPointScreenState extends State<BawaKeDropPointScreen> {
  final TextEditingController alamat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, 1.00),
            end: Alignment(0, -1),
            colors: [Color(0xFFE9EBFF), Color(0xFF8B97FF)],
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: ListView(
            children: <Widget>[
              const KomponenHeader(),
              const SizedBox(height: 16),
              KomponenAlamat(alamat: alamat),
              const SizedBox(height: 16),
              const KomponenTombol(),
            ],
          ),
        ),
      ),
    ]);
  }
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
        const Text(
          "Buang Sampah Elektronik",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class KomponenAlamat extends StatelessWidget {
  const KomponenAlamat({super.key, required this.alamat});
  final TextEditingController alamat;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Alamat",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          controller: alamat,
          decoration: const InputDecoration(
            hintStyle: TextStyle(color: Colors.white),
            hintText: "Masukkan alamat",
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 1, color: Colors.white), //<-- SEE HERE
            ),
          ),
        )
      ],
    );
  }
}

class KomponenTombol extends StatelessWidget {
  const KomponenTombol({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {}, child: const Text("Cari"));
  }
}
