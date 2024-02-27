import 'package:ewaste/screen/buang/detail/detail_buang_jenis_elektronik_screen.dart';
import 'package:ewaste/screen/donasi/detail/detail_donasi_jenis_elektronik_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../component/get_svg_widget.dart';

class GridJenisElektronik extends StatelessWidget {
  const GridJenisElektronik({
    super.key,
    required this.listJenisEletronik,
    required this.tipe,
  });
  final PostgrestTransformBuilder<List<Map<String, dynamic>>>
      listJenisEletronik;
  final String tipe;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listJenisEletronik,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final jenisBarangElektronik = snapshot.data;
          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 1.8,
              mainAxisSpacing: 1.8,
              crossAxisCount: 3,
            ),
            itemCount: jenisBarangElektronik?.length,
            itemBuilder: (context, index) {
              final item = jenisBarangElektronik?[index];
              return InkWell(
                splashColor: Colors.deepPurple[400],
                onTap: () {
                  tipe == "buang"
                      ? context.go(
                          '/buang/detail/${item?['kategorisasi']}/${item?['id']}')
                      : context.go(
                          '/donasi/detail/${item?['kategorisasi']}/${item?['id']}');
                },
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetSvgWidget(fileName: item?["jenis"]),
                        Text(
                          item?["jenis"],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
