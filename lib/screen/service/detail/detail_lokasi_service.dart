import 'dart:typed_data';

import 'package:ewaste/main.dart';
import 'package:ewaste/screen/service/daftar_lokasi_service/lokasi_service_terdekat_screen.dart';
import 'package:flutter/material.dart';

class DetailLokasiServiceScreen extends StatefulWidget {
  const DetailLokasiServiceScreen(
      {super.key, required this.idKecamatan, required this.idServiceCenter});
  final num idKecamatan;
  final num idServiceCenter;

  @override
  State<DetailLokasiServiceScreen> createState() =>
      _DetailLokasiServiceScreenState();
}

class _DetailLokasiServiceScreenState extends State<DetailLokasiServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
              children: [
                KomponenHeader(idKecamatan: widget.idKecamatan),
                Container(
                  color: Colors.white24,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        FutureBuilder(
                          future: getServiceCenterName(widget.idKecamatan),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final data = snapshot.data as Map<String, dynamic>;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['nama']!,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  data['alamat']!,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        FutureBuilder(
                          future: getServiceCenterMaps(
                              idServiceCenter: widget.idServiceCenter),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final imgPath = snapshot.data!;
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(imgPath),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key, required this.idKecamatan});
  final num idKecamatan;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => LokasiServiceTerdekatScreen(
                  idKecamatan: idKecamatan,
                ),
              ),
            );
          },
        ),
        const Text(
          "Service Barang Elektronik",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

Future<Map<String, dynamic>> getServiceCenterName(num idKecamatan) async {
  final response = await supabase
      .from('daftar_servicecenter')
      .select()
      .eq('id', idKecamatan)
      .limit(1)
      .single();
  return response;
}

Future<String> getServiceCenterMaps({
  required num idServiceCenter,
}) async {
  // final response = await supabase.storage
  //     .from('peta_servicecenter')
  //     .download('$idServiceCenter.png');
  final response = supabase.storage
      .from("peta_servicecenter")
      .getPublicUrl("$idServiceCenter.png");

  return response;
}
