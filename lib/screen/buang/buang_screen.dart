import 'package:e_waste/component/grid_jenis_elektronik.dart';
import 'package:e_waste/component/icon_widget.dart';
import 'package:e_waste/screen/buang/keranjang_buang.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BuangScreen extends StatelessWidget {
  const BuangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const KomponenHeader(),
        const SizedBox(height: 16),
        const KomponenCari(),
        const SizedBox(height: 16),
        KomponenJenisElektronik(),
      ],
    );
  }
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Buang Sampah Elektronik",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        ClipOval(
          child: Material(
            color: Colors.white, // Button color
            child: InkWell(
              splashColor: Colors.deepPurple[400], // Splash color
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const KeranjangBuang();
                }));
              },
              child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: IconWidget(
                      "basket",
                      color: Color(0xFF4285F4),
                    ),
                  )),
            ),
          ),
        )
      ],
    );
  }
}

class KomponenCari extends StatelessWidget {
  const KomponenCari({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(),
          hintText: 'Cari jenis sampah',
        ),
      ),
    );
  }
}

class KomponenJenisElektronik extends StatelessWidget {
  KomponenJenisElektronik({super.key});

  final _jenisElektronik = Supabase.instance.client
      .from('jenis_elektronik')
      .select()
      .order("id", ascending: true);

  Future<Widget> getSvg(String fileName) async {
    final response = await Supabase.instance.client.storage
        .from('jenis_elektronik')
        .download('$fileName.svg');

    final String svgString = String.fromCharCodes(response);
    return SvgPicture.string(
      svgString,
      height: 30,
      width: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Jenis Elektronik",
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: SizedBox(
            height: 440,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(colors: [
                    Color.fromARGB(255, 155, 155, 155),
                    Color.fromARGB(255, 204, 204, 204),
                  ], radius: 0.85, focal: Alignment.center),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.8),
                  child: GridJenisElektronik(
                    tipe: "buang",
                    listJenisEletronik: _jenisElektronik,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
