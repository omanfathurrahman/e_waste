import 'package:e_waste/main.dart';
import 'package:e_waste/screen/main_layout.dart';
import 'package:e_waste/screen/service/detail/detail_lokasi_service.dart';
import 'package:flutter/material.dart';

class LokasiServiceTerdekatScreen extends StatelessWidget {
  const LokasiServiceTerdekatScreen({super.key, required this.idKecamatan});

  final num idKecamatan;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
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
                  const KomponenHeader(),
                  const SizedBox(height: 16),
                  FutureBuilder(
                    future: getKecamatanName(id: idKecamatan),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final pilihan = snapshot.data;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: pilihan!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailLokasiServiceScreen(
                                    idKecamatan: idKecamatan,
                                    idServiceCenter: pilihan[index]['id'],
                                  ),
                                ),
                              ),
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  pilihan[index]['nama'],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MainLayout(
                curScreenIndex: 3,
              ),
            ),
          );
        }),
        const Text(
          "Service Barang Elektronik",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

Future<List<Map<String, dynamic>>> getKecamatanName({required num id}) async {
  final response = await supabase
      .from('service_center')
      .select()
      .eq('id_kecamatan', id);
  return response;
}
