import 'package:e_waste/screen/service/daftar_lokasi_service/lokasi_service_terdekat_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late final TextEditingController alamat;

  @override
  void initState() {
    alamat = TextEditingController();
    alamat.addListener(() {
      final text = alamat.value.text;
      print(text);
    });
    super.initState();
  }

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
        KomponenTombol(alamat: alamat),
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
          "Service Barang Elektronik",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class KomponenAlamat extends StatefulWidget {
  const KomponenAlamat({super.key, required this.alamat});

  final TextEditingController alamat;

  @override
  State<KomponenAlamat> createState() => _KomponenAlamatState();
}

class _KomponenAlamatState extends State<KomponenAlamat> {
  // final TextEditingController alamatController = TextEditingController();
  final listKecamatan = Supabase.instance.client
      .from('kecamatan')
      .select()
      .order("id", ascending: true);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pilih Kecamatan",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(
          height: 16,
        ),
        FutureBuilder(
          future: listKecamatan,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final pilihan = snapshot.data;
            return DropdownMenu(
              onSelected: (value) {
                widget.alamat.text = value.toString();
              },
              controller: widget.alamat,
              textStyle: const TextStyle(color: Colors.white),
              inputDecorationTheme: const InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Colors.white),
                ),
              ),
              initialSelection: pilihan?[0]['kecamatan'],
              dropdownMenuEntries: pilihan!
                  .map(
                    (item) => DropdownMenuEntry(
                      value: item['id'],
                      label: item['kecamatan'],
                    ),
                  )
                  .toList(),
            );
          },
        )
      ],
    );
  }
}

class KomponenTombol extends StatelessWidget {
  const KomponenTombol({super.key, required this.alamat});
  final TextEditingController alamat;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        if (alamat.value.text != "")
          {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LokasiServiceTerdekatScreen(
                    idKecamatan: int.parse(alamat.value.text)),
              ),
            )
          }
        else
          {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Alamat tidak boleh kosong"),
              ),
            )
          }
      },
      child: const Text("Cari"),
    );
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
