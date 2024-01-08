import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'get_svg_widget.dart';

class GridJenisElektronik extends StatelessWidget {
  const GridJenisElektronik({super.key, required this.listJenisEletronik});
  final PostgrestFilterBuilder<List<Map<String, dynamic>>> listJenisEletronik;

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
                onTap: () => {print(item?['id'])},
                child: ColoredBox(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GetSvgWidget(fileName: item?["jenis"]),
                      Text(item?["jenis"]),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
