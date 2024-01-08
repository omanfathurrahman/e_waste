import 'dart:ffi';

import 'package:e_waste/component/grid_jenis_elektronik.dart';
import 'package:e_waste/component/icon_widget.dart';
import 'package:e_waste/layout/default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailJenisElektronikScreen extends StatefulWidget {
  const DetailJenisElektronikScreen({super.key});

  @override
  State<DetailJenisElektronikScreen> createState() =>
      _DetailJenisElektronikScreenState();
}

class _DetailJenisElektronikScreenState
    extends State<DetailJenisElektronikScreen> {
  final TextEditingController jumlahController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: ListView(
        children: [
          const KomponenHeader(),
          const SizedBox(height: 16),
          const KomponenDropdown(),
          const SizedBox(height: 16),
          const KomponenUkuranBarang(),
          const SizedBox(height: 16),
          KomponenJumlahBarang(jumlahController: jumlahController),
          const SizedBox(height: 16),
          const KomponenTombol(),
        ],
      ),
    );
  }
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        // IconButton(
        //   onPressed: () => {},
        //   icon: const Icon(Icons.arrow_back),
        //   color: Colors.white,
        // ),
        BackButton(
          color: Colors.white,
        ),
        Text(
          "Buang Sampah Elektronik",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ],
    );
  }
}

class KomponenUkuranBarang extends StatelessWidget {
  const KomponenUkuranBarang({super.key});

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
          child: const Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Card(
                  child: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Text(
                            "Kecil",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                          Text("1kg - 15kg"),
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
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Text(
                            "Sedang",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                          Text("1kg - 15kg"),
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
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Text(
                            "Besar",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10),
                          Text("1kg - 15kg"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
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
  const KomponenDropdown({super.key});

  @override
  State<KomponenDropdown> createState() => _KomponenDropdownState();
}

class _KomponenDropdownState extends State<KomponenDropdown> {
  final List<String> kategori = ["Kecil", "Sedang", "Besar"];
  String pilihanKategori = "";

  @override
  void initState() {
    // TODO: implement initState
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
          child: DropdownButton<String>(
            hint: const Text(
              "Pilih Kategori",
              style: TextStyle(color: Colors.white),
            ),
            iconEnabledColor: Colors.white,
            dropdownColor: const Color.fromARGB(219, 94, 145, 255),
            focusColor: Colors.transparent,
            items: kategori
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
                .toList(),
            // value: pilihanKategori,
            onChanged: (String? value) {
              setState(
                () {
                  pilihanKategori = value!;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
