import 'package:ewaste/main.dart';
import 'package:ewaste/screen/buang/daftar_droppoin/detail_buang_droppoin/detail_buang_droppoin.dart';
import 'package:ewaste/screen/default.dart';
import 'package:ewaste/screen/donasi/keranjang/keranjang_donasi.dart';
import 'package:flutter/material.dart';

class DaftarDroppoinDonasi extends StatefulWidget {
  const DaftarDroppoinDonasi({super.key, required this.alamatId});
  final num alamatId;

  @override
  State<DaftarDroppoinDonasi> createState() => _DaftarDroppoinDonasiState();
}

class _DaftarDroppoinDonasiState extends State<DaftarDroppoinDonasi> {
  Future<void> _donasiKeDroppoin({required num droppoinId}) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBuangDroppoin(droppoinId: droppoinId),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Default(
      child: ListView(
        children: [
          const KomponenHeader(),
          const SizedBox(height: 16),
          const Text(
            'Pilih Drop Poin',
            style: TextStyle(color: Colors.white),
          ),
          FutureBuilder(
            future: _getDroppoinList(id: widget.alamatId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final droppoinList = snapshot.data!;
              return Column(
                children: droppoinList
                    .map((droppoin) => GestureDetector(
                          onTap: () {
                            _donasiKeDroppoin(droppoinId: droppoin['id']);
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(droppoin['nama'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text(droppoin['alamat']),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          )
        ],
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> _getDroppoinList({required num id}) async {
  final response =
      await supabase.from('daftar_droppoin').select().eq('alamat_id', id);
  return response;
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const KeranjangDonasi(),
              ),
            );
          },
        ),
        const Text(
          "Daftar Drop Poin",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
