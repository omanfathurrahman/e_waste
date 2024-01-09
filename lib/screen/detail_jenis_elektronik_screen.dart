import 'package:e_waste/main.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailJenisElektronikScreen extends StatefulWidget {
  const DetailJenisElektronikScreen(
      {super.key,
      required this.jenisKategorisasi,
      required this.idJenisKategori});
  final String jenisKategorisasi;
  final int idJenisKategori;

  @override
  State<DetailJenisElektronikScreen> createState() =>
      _DetailJenisElektronikScreenState();
}

class _DetailJenisElektronikScreenState
    extends State<DetailJenisElektronikScreen> {
  final TextEditingController jumlahController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(children: [
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
              children: switch (widget.jenisKategorisasi) {
                "none" => <Widget>[
                    const KomponenHeader(),
                    const SizedBox(height: 16),
                    KomponenJumlahBarang(jumlahController: jumlahController),
                    const SizedBox(height: 16),
                    const KomponenTombol(),
                  ],
                "kecil_sedang_besar" => <Widget>[
                    const KomponenHeader(),
                    const SizedBox(height: 16),
                    KomponenUkuranBarang(
                        idJenisKategori: widget.idJenisKategori),
                    const SizedBox(height: 16),
                    KomponenJumlahBarang(jumlahController: jumlahController),
                    const SizedBox(height: 16),
                    const KomponenTombol(),
                  ],
                "pilihan" => <Widget>[
                    const KomponenHeader(),
                    const SizedBox(height: 16),
                    KomponenDropdown(idJenisKategori: widget.idJenisKategori),
                    const SizedBox(height: 16),
                    KomponenJumlahBarang(jumlahController: jumlahController),
                    const SizedBox(height: 16),
                    const KomponenTombol(),
                  ],
                "pilihan + kecil_sedang_besar" => <Widget>[
                    const KomponenHeader(),
                    const SizedBox(height: 16),
                    KomponenDropdown(idJenisKategori: widget.idJenisKategori),
                    const SizedBox(height: 16),
                    KomponenUkuranBarang(
                        idJenisKategori: widget.idJenisKategori),
                    const SizedBox(height: 16),
                    KomponenJumlahBarang(jumlahController: jumlahController),
                    const SizedBox(height: 16),
                    const KomponenTombol(),
                  ],
                _ => []
              },
            ),
          ),
        ),
      ]),
    );
  }
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // IconButton(
        //   onPressed: () => {},
        //   icon: const Icon(Icons.arrow_back),
        //   color: Colors.white,
        // ),
        BackButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MainLayout()));
          },
          color: Colors.white,
        ),
        const Text(
          "Buang Sampah Elektronik",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }
}

class KomponenUkuranBarang extends StatelessWidget {
  const KomponenUkuranBarang({super.key, required this.idJenisKategori});
  final int idJenisKategori;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ukuran Barang",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: FutureBuilder(
            future: kategorisasiKSB(id: idJenisKategori),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final kategoriKecilSedangBesar = snapshot.data?[0];
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Card(
                      child: ColoredBox(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              const Text(
                                "Kecil",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              Text(kategoriKecilSedangBesar?['kecil_label']),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: ColoredBox(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              const Text(
                                "Sedang",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              Text(kategoriKecilSedangBesar?['sedang_label']),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: ColoredBox(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              const Text(
                                "Besar",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              Text(kategoriKecilSedangBesar?['besar_label']),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class KomponenJumlahBarang extends StatelessWidget {
  const KomponenJumlahBarang({super.key, required this.jumlahController});
  final TextEditingController jumlahController;

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
          controller: jumlahController,
          decoration: const InputDecoration(
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
    return ElevatedButton(
        onPressed: () => {}, child: const Text("Masukkan ke keranjang"));
  }
}

class KomponenDropdown extends StatefulWidget {
  const KomponenDropdown({super.key, required this.idJenisKategori});
  final int idJenisKategori;

  @override
  State<KomponenDropdown> createState() => _KomponenDropdownState();
}

class _KomponenDropdownState extends State<KomponenDropdown> {
  final List<String> kategori = ["Kecil", "Sedang", "Besar"];
  late String pilihanKategori;

  @override
  void initState() {
    super.initState();
    pilihanKategori = kategori.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kategori",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: FutureBuilder(
            future: kategorisasiPilihan(id: widget.idJenisKategori),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final pilihan = snapshot.data;
              return DropdownButton<String>(

                iconEnabledColor: Colors.white,
                dropdownColor: const Color.fromARGB(219, 94, 145, 255),
                focusColor: Colors.transparent,
                items: pilihan!
                    .map(
                      (item) => DropdownMenuItem<String>(
                        // value: item['berat'].toString(),
                        child: Text(item['label'],
                            style: const TextStyle(color: Colors.white)),
                      ),
                    )
                    .toList(),
                value: pilihanKategori,
                onChanged: (String? value) {
                  setState(
                    () {
                      pilihanKategori = value!;
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<List<Map<String, dynamic>>> kategorisasiKSB({required int id}) async {
  final response = await Supabase.instance.client
      .from('kategorisasi_kecilsedangbesar')
      .select()
      .eq('id_jenis_elektronik', id);
  return response;
}

Future<List<Map<String, dynamic>>> kategorisasiPilihan(
    {required int id}) async {
  print(id);
  final response = await Supabase.instance.client
      .from('kategorisasi_pilihan')
      .select()
      .eq('id_jenis_elektronik', id);
  return response;
}
