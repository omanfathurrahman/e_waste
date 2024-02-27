import 'package:ewaste/main.dart';
import 'package:ewaste/screen/main_layout.dart';
import 'package:ewaste/utils/hitung_berat.dart';
import 'package:flutter/material.dart';

class DetailDonasiJenisElektronikScreen extends StatefulWidget {
  const DetailDonasiJenisElektronikScreen({
    super.key,
    required this.jenisKategorisasi,
    required this.idJenisKategori,
  });
  final String jenisKategorisasi;
  final int idJenisKategori;

  @override
  State<DetailDonasiJenisElektronikScreen> createState() =>
      _DetailDonasiJenisElektronikScreenState();
}

class _DetailDonasiJenisElektronikScreenState
    extends State<DetailDonasiJenisElektronikScreen> {
  // final TextEditingController jumlahController = TextEditingController();

  String pilihanKategori = "";
  int jumlahBarang = 1;
  var userId = supabase.auth.currentUser!.id;

  void gantiPilihan(String pilihan) {
    setState(() {
      pilihanKategori = pilihan;
    });
    print("jenis kategori: $pilihanKategori");
  }

  void gantiJumlah(int jumlah) {
    setState(() {
      jumlahBarang = jumlah;
    });
    print("jumlah barang: $jumlahBarang");
  }

  Future<void> tambahKeKeranjang() async {
    if (pilihanKategori == "") {
      await supabase.from("keranjang_donasi").insert({
        "id_jenis_elektronik": widget.idJenisKategori,
        "id_user": userId,
        "jumlah": jumlahBarang,
        "berat_total": (await beratJenisElektronik(
                idJenisElektronik: widget.idJenisKategori)) *
            jumlahBarang
      });
    } else {
      await supabase.from("keranjang_donasi").insert({
        "id_jenis_elektronik": widget.idJenisKategori,
        "id_user": userId,
        "jumlah": jumlahBarang,
        "kategorisasi": pilihanKategori,
        "berat_total": (await beratJenisElektronik(
                idJenisElektronik: widget.idJenisKategori,
                label: pilihanKategori)) *
            jumlahBarang
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Berhasil ditambahkan ke keranjang"),
      ),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MainLayout(
          curScreenIndex: 2,
        ),
      ),
    );
  }

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
                    KomponenJumlahBarang(gantiJumlah: gantiJumlah),
                    const SizedBox(height: 16),
                    KomponenTombol(tambahKeKeranjang: tambahKeKeranjang),
                  ],
                "kecil_sedang_besar" => <Widget>[
                    const KomponenHeader(),
                    const SizedBox(height: 16),
                    KomponenUkuranBarang(
                      idJenisKategori: widget.idJenisKategori,
                      gantiPilihan: gantiPilihan,
                    ),
                    const SizedBox(height: 16),
                    KomponenJumlahBarang(gantiJumlah: gantiJumlah),
                    const SizedBox(height: 16),
                    KomponenTombol(tambahKeKeranjang: tambahKeKeranjang),
                  ],
                "pilihan" => <Widget>[
                    const KomponenHeader(),
                    const SizedBox(height: 16),
                    KomponenDropdown(
                        idJenisKategori: widget.idJenisKategori,
                        gantiPilihan: gantiPilihan),
                    const SizedBox(height: 16),
                    KomponenJumlahBarang(gantiJumlah: gantiJumlah),
                    const SizedBox(height: 16),
                    KomponenTombol(tambahKeKeranjang: tambahKeKeranjang),
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
              MaterialPageRoute(
                builder: (context) => const MainLayout(
                  curScreenIndex: 2,
                ),
              ),
            );
          },
          color: Colors.white,
        ),
        const Text(
          "Donasi Sampah Elektronik",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }
}

class KomponenUkuranBarang extends StatefulWidget {
  const KomponenUkuranBarang(
      {super.key, required this.idJenisKategori, required this.gantiPilihan});
  final Function(String pilihan) gantiPilihan;
  final int idJenisKategori;

  @override
  State<KomponenUkuranBarang> createState() => _KomponenUkuranBarangState();
}

class _KomponenUkuranBarangState extends State<KomponenUkuranBarang> {
  String kategoriPilihan = "";

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
            future: kategorisasiKSB(id: widget.idJenisKategori),
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
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          kategoriPilihan = "kecil";
                        });
                        widget.gantiPilihan(kategoriPilihan);
                      },
                      child: Card(
                        child: ColoredBox(
                          color: (kategoriPilihan == "kecil")
                              ? Colors.grey.shade300
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              children: [
                                const Text(
                                  "Kecil",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                Text(kategoriKecilSedangBesar?['label_kecil']),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          kategoriPilihan = "sedang";
                        });
                        widget.gantiPilihan(kategoriPilihan);
                      },
                      child: Card(
                        child: ColoredBox(
                          color: (kategoriPilihan == "sedang")
                              ? Colors.grey.shade300
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              children: [
                                const Text(
                                  "Sedang",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                Text(kategoriKecilSedangBesar?['label_sedang']),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          kategoriPilihan = "besar";
                        });
                        widget.gantiPilihan(kategoriPilihan);
                      },
                      child: Card(
                        child: ColoredBox(
                          color: (kategoriPilihan == "besar")
                              ? Colors.grey.shade300
                              : Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              children: [
                                const Text(
                                  "Besar",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                Text(kategoriKecilSedangBesar?['label_besar']),
                              ],
                            ),
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
  KomponenJumlahBarang({super.key, required this.gantiJumlah});
  final TextEditingController jumlahController = TextEditingController();

  final Function(int jumlah) gantiJumlah;

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
        DropdownMenu(
          onSelected: (value) => gantiJumlah(value as int),
          initialSelection: 1,
          dropdownMenuEntries: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
              .map(
                (number) => DropdownMenuEntry(
                  value: number,
                  label: number.toString(),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}

class KomponenTombol extends StatelessWidget {
  const KomponenTombol({super.key, required this.tambahKeKeranjang});
  final Function() tambahKeKeranjang;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: tambahKeKeranjang,
      child: const Text("Masukkan ke keranjang"),
    );
  }
}

class KomponenDropdown extends StatefulWidget {
  const KomponenDropdown(
      {super.key, required this.idJenisKategori, required this.gantiPilihan});
  final int idJenisKategori;
  final void Function(String) gantiPilihan;

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
    var width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Kategori",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: width,
          child: FutureBuilder(
            future: kategorisasiPilihan(id: widget.idJenisKategori),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final pilihan = snapshot.data;
              return DropdownMenu(
                onSelected: (value) => widget.gantiPilihan(value),
                textStyle: const TextStyle(color: Colors.white),
                inputDecorationTheme: const InputDecorationTheme(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Colors.white),
                  ),
                ),
                initialSelection: pilihan?[0]['berat'],
                dropdownMenuEntries: pilihan!
                    .map(
                      (item) => DropdownMenuEntry(
                        value: item['label'],
                        label: item['label'],
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

Future<List<Map<String, dynamic>>> kategorisasiKSB({required int id}) async {
  final response = await supabase
      .from('kategorisasi_kecilsedangbesar')
      .select()
      .eq('id_jenis_elektronik', id);
  return response;
}

Future<List<Map<String, dynamic>>> kategorisasiPilihan(
    {required int id}) async {
  print(id);
  final response = await supabase
      .from('kategorisasi_pilihan')
      .select()
      .eq('id_jenis_elektronik', id);
  return response;
}
