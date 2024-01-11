import 'package:e_waste/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final TextEditingController alamat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const KomponenHeader(),
        const SizedBox(height: 16),
        const KomponenDropdown(),
        const SizedBox(height: 16),
        KomponenAlamat(alamat: alamat),
        const SizedBox(height: 16),
        const KomponenTombol(),
      ],
    );
  }
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Text(
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
          "Jumlah Barang",
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

class KomponenDropdown extends StatefulWidget {
  const KomponenDropdown({super.key});

  @override
  State<KomponenDropdown> createState() => _KomponenDropdownState();
}

class _KomponenDropdownState extends State<KomponenDropdown> {
  late String pilihanKategori;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final jenisElektronik = Supabase.instance.client
        .from('jenis_elektronik')
        .select()
        .order("id", ascending: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Jenis Elektronik",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: width,
          child: FutureBuilder(
            future: jenisElektronik,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final pilihan = snapshot.data;
              return DropdownMenu(
                textStyle: const TextStyle(color: Colors.white),
                inputDecorationTheme: const InputDecorationTheme(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                ),
                initialSelection: pilihan?[0]['jenis'],
                dropdownMenuEntries: pilihan!
                    .map(
                      (item) => DropdownMenuEntry(
                        value: item['jenis'],
                        label: item['jenis'],
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
